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

if [ -f ".venv/bin/python" ]; then
    PYTHON_BIN=".venv/bin/python"
else
    PYTHON_BIN="python"
fi

TEMP_ONTOLOGY=$(mktemp)
trap 'rm -f "$TEMP_ONTOLOGY" "${TEMP_FILE:-}"' EXIT

echo "🧭 Preparing ontology metadata for pyLODE..."

# pyLODE treats every skos:ConceptScheme as top-level document metadata.
# Render from a temporary graph without those type triples so the HTML
# metadata block describes only the owl:Ontology resource. The published
# ontology copied below remains unchanged.
"$PYTHON_BIN" - "$ONTOLOGY_FILE" "$TEMP_ONTOLOGY" <<'PY'
import sys
from rdflib import Graph, RDF, OWL, SKOS

source, destination = sys.argv[1:3]
graph = Graph()
graph.parse(source, format="turtle")

ontology_subjects = set(graph.subjects(RDF.type, OWL.Ontology))
for subject in list(graph.subjects(RDF.type, SKOS.ConceptScheme)):
    if subject not in ontology_subjects:
        graph.remove((subject, RDF.type, SKOS.ConceptScheme))

graph.serialize(destination=destination, format="turtle")
PY

echo "📚 Generating documentation with pyLODE..."

# Generate HTML documentation using pyLODE
"$PYTHON_BIN" -m pylode "$TEMP_ONTOLOGY" -o "$DOCS_DIR/index.html"

# Copy ontology files to docs directory for download
echo "📄 Copying ontology source files..."
cp "$ONTOLOGY_FILE" "$DOCS_DIR/"

# Create improved index.html if pyLODE output needs enhancement
if [ -f "$DOCS_DIR/index.html" ]; then
    echo "🔄 Post-processing documentation: replacing JSON-LD with Turtle script..."
    
    # Create a temporary file for processing
    TEMP_FILE=$(mktemp)
    
    # Remove the JSON-LD script section and replace with Turtle script
    awk '
    BEGIN { in_jsonld = 0; print_turtle = 0 }
    /<script id="schema\.org" type="application\/ld\+json">/ {
        in_jsonld = 1
        # Insert Turtle script instead
        print "    <script type=\"text/turtle\">"
        # Read and insert the ontology content
        while ((getline line < "'"$ONTOLOGY_FILE"'") > 0) {
            print line
        }
        close("'"$ONTOLOGY_FILE"'")
        print_turtle = 1
        next
    }
    /^[[:space:]]*<\/script>[[:space:]]*$/ && in_jsonld {
        if (print_turtle) {
            print "\t</script>"
            print_turtle = 0
        }
        in_jsonld = 0
        next
    }
    !in_jsonld { print }
    ' "$DOCS_DIR/index.html" > "$TEMP_FILE"
    
    # Replace the original file
    mv "$TEMP_FILE" "$DOCS_DIR/index.html"
    
    echo "✅ pyLODE documentation generated and enhanced successfully!"
else
    echo "❌ Failed to generate pyLODE documentation"
    exit 1
fi

echo "✅ Documentation generated successfully!"
echo "🌐 Open docs/index.html in your browser to view the documentation"
echo "📁 Documentation files are in: $DOCS_DIR/"
