#!/bin/bash

# Sports Activity Ontology Documentation Generator using pyLODE
# This script generates documentation with better content negotiation support

set -e

ONTOLOGY_FILE="ontology.ttl"
DOCS_DIR="docs"

echo "🚀 Sports Activity Ontology Documentation Generator (pyLODE)"
echo "=================================================="

# Check if ontology file exists
if [ ! -f "$ONTOLOGY_FILE" ]; then
    echo "❌ Error: $ONTOLOGY_FILE not found!"
    exit 1
fi

# Create docs directory
mkdir -p "$DOCS_DIR"

echo "📚 Generating documentation with pyLODE..."

# Generate HTML documentation using pyLODE
if [ -f ".venv/bin/python" ]; then
    .venv/bin/python -m pylode "$ONTOLOGY_FILE" -o "$DOCS_DIR/index.html"
else
    python -m pylode "$ONTOLOGY_FILE" -o "$DOCS_DIR/index.html"
fi

# Copy ontology files to docs directory for download
cp "$ONTOLOGY_FILE" "$DOCS_DIR/"

# Generate additional formats if needed
echo "📄 Copying ontology source files..."

# Create .htaccess content for w3id.org setup
cat > "$DOCS_DIR/.htaccess" << 'EOF'
# Content negotiation for Sports Activity Ontology
# Dereferencable URIs with proper content negotiation

Options +FollowSymLinks
RewriteEngine on

# Default response (HTML documentation)
RewriteCond %{HTTP_ACCEPT} !application/rdf\+xml.*(text/html|application/xhtml\+xml)
RewriteCond %{HTTP_ACCEPT} text/html [OR]
RewriteCond %{HTTP_ACCEPT} application/xhtml\+xml [OR]
RewriteCond %{HTTP_USER_AGENT} ^Mozilla/.*
RewriteRule ^$ index.html [R=303,L]

# Turtle format
RewriteCond %{HTTP_ACCEPT} text/turtle [OR]
RewriteCond %{HTTP_ACCEPT} application/turtle [OR]
RewriteCond %{HTTP_ACCEPT} application/x-turtle
RewriteRule ^$ ontology.ttl [R=303,L]

# RDF/XML format
RewriteCond %{HTTP_ACCEPT} application/rdf\+xml
RewriteRule ^$ ontology.ttl [R=303,L]

# JSON-LD format  
RewriteCond %{HTTP_ACCEPT} application/ld\+json
RewriteRule ^$ ontology.ttl [R=303,L]

# Default fallback to HTML
RewriteRule ^$ index.html [R=303,L]

# Individual class/property resolution
# Example: https://solidlabresearch.github.io/activity-ontology#Activity
RewriteCond %{HTTP_ACCEPT} text/html [OR]
RewriteCond %{HTTP_ACCEPT} application/xhtml\+xml [OR]
RewriteCond %{HTTP_USER_AGENT} ^Mozilla/.*
RewriteRule ^(.*)$ index.html#$1 [R=303,L]

# For RDF content, return the ontology file
RewriteRule ^(.*)$ ontology.ttl [R=303,L]
EOF

# Create README for w3id.org submission
cat > "$DOCS_DIR/README.md" << 'EOF'
# Sports Activity Ontology - W3ID Permanent Identifier

## Contact
- **Name**: Maarten Vandenbrande
- **Organization**: SolidLab Research
- **Email**: maarten.vandenbrande@ugent.be
- **GitHub**: https://github.com/maartyman

## Project Information
- **Ontology**: Sports Activity Ontology
- **Namespace**: https://w3id.org/activity-ontology/
- **Repository**: https://github.com/SolidLabResearch/activity-ontology
- **Documentation**: https://solidlabresearch.github.io/activity-ontology/

## Redirects
This directory contains the redirect configuration for the Sports Activity Ontology permanent identifiers.

### Content Negotiation
- HTML: Returns human-readable documentation
- RDF formats (Turtle, RDF/XML, JSON-LD): Returns machine-readable ontology
- Individual terms: Redirects to documentation with fragment identifier

### Examples
- `https://w3id.org/activity-ontology/` → Documentation or RDF based on Accept header
- `https://w3id.org/activity-ontology/Activity` → `https://solidlabresearch.github.io/activity-ontology/#Activity`
EOF

echo "🌐 Creating enhanced index page with better navigation..."

# Create improved index.html if pyLODE output needs enhancement
if [ -f "$DOCS_DIR/index.html" ]; then
    # Add navigation and styling if needed
    echo "✅ pyLODE documentation generated successfully!"
else
    echo "❌ Failed to generate pyLODE documentation"
    exit 1
fi

echo "✅ Documentation generated successfully!"
echo "🌐 Open docs/index.html in your browser to view the documentation"
echo "📁 Documentation files are in: $DOCS_DIR/"
