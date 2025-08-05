# Sports Activity Ontology

An ontology for modeling sports activities, performance metrics, and athlete data. This ontology integrates with PROV-O for provenance tracking and FOAF for person modeling.

## 📖 Documentation

The complete ontology documentation is automatically generated and hosted at:
**[https://solidlabresearch.github.io/activity-ontology/](https://solidlabresearch.github.io/activity-ontology/)**

## 🚀 Features

- **Comprehensive Activity Modeling**: Supports various sports activities (cycling, running, swimming)
- **Performance Metrics**: Detailed statistics for speed, power, heart rate, cadence, and more
- **Athlete Profiles**: Performance snapshots and athlete data modeling
- **Provenance Integration**: Built-in support for data lineage and device tracking using PROV-O
- **Standards Compliant**: Follows W3C best practices and integrates with established ontologies
- **Dereferencable URIs**: Content negotiation support for both human and machine-readable formats

## 🏗️ Ontology Structure

### Core Classes
- `Activity` - Base class for all sports activities
- `Athlete` - Athlete profiles with performance data
- `Stats` - Statistical measurements and metrics
- `Device` - Sports tracking devices and data sources

### Activity Types
- `Ride` - Cycling activities
- `Run` - Running activities  
- `Swim` - Swimming activities

### Statistics Categories
- Speed, Pace, Power, Heart Rate
- Cadence, Grade, Elevation
- Cycling and Running Dynamics

## 🔧 Development

### Automatic Documentation Generation

This repository uses GitHub Actions to automatically generate and deploy documentation using [pyLODE](https://github.com/RDFLib/pyLODE). The documentation is updated automatically when changes are pushed to the main branch.

### Local Development

To work with the ontology locally:

1. **First-time setup** (recommended):
   ```bash
   make setup
   ```

   *Or manually*:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # On Linux/macOS
   # .venv\Scripts\activate     # On Windows
   pip install -r requirements.txt
   ```

2. **Validate ontology syntax**:
   ```bash
   make test
   ```

3. **Generate documentation**:
   ```bash
   make docs
   ```

4. **View the documentation**:
   Open `docs/index.html` in your browser

**Note**: The `.venv` directory is excluded from version control and should be created locally by each developer.

### Testing

The ontology includes automated validation to ensure Turtle syntax correctness:

- **Local testing**: Run `python test_ontology.py` or `make test`
- **CI/CD**: Automated validation runs on every push and pull request
- **Statistics**: The test provides helpful statistics about classes, properties, and triples

The script automatically:
- Generates HTML documentation with enhanced styling (`vocpub` profile)
- Creates content negotiation rules (`.htaccess`)
- Copies the ontology file for download
- Sets up w3id.org redirect documentation

## 🌐 Dereferencable URIs

This ontology supports content negotiation for dereferencable URIs:

- **HTML**: Human-readable documentation  
- **RDF formats**: Machine-readable ontology (Turtle, RDF/XML, JSON-LD)
- **Individual terms**: Direct access to classes and properties

For permanent identifiers, consider using [w3id.org](https://w3id.org/) namespace redirection.

## 📋 Setup GitHub Pages

To enable automatic documentation deployment:

1. Go to your repository Settings
2. Navigate to "Pages" in the left sidebar
3. Under "Source", select "GitHub Actions"
4. The workflow will automatically run on the next push to main

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes to `ontology.ttl`
4. **Test the ontology syntax**: `make test` or `python test_ontology.py`
5. Submit a pull request

All pull requests are automatically validated using GitHub Actions.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [Elevate](https://github.com/SolidLabResearch/elevate) - Sports analytics platform
- [PROV-O](http://www.w3.org/ns/prov#) - W3C Provenance Ontology
- [FOAF](http://xmlns.com/foaf/0.1/) - Friend of a Friend Ontology
