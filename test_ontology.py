#!/usr/bin/env python3
"""
Test script to validate the Turtle syntax of the Sports Activity Ontology.

This script parses the ontology.ttl file using rdflib to ensure it contains
valid Turtle syntax and can be properly loaded as an RDF graph.
"""

import sys
from pathlib import Path
from rdflib import Graph
from rdflib.exceptions import ParserError


def test_turtle_syntax(ontology_path: Path) -> bool:
    """
    Test if the ontology file contains valid Turtle syntax.
    
    Args:
        ontology_path: Path to the ontology.ttl file
        
    Returns:
        True if the syntax is valid, False otherwise
    """
    try:
        # Create a new RDF graph
        graph = Graph()
        
        # Parse the Turtle file
        print(f"🔍 Parsing {ontology_path}...")
        graph.parse(ontology_path, format="turtle")
        
        # Get basic statistics
        num_triples = len(graph)
        print(f"✅ Successfully parsed {num_triples} triples")
        
        # Basic validation: check that we have some triples
        if num_triples == 0:
            print("⚠️  Warning: No triples found in the ontology")
            return False
            
        # Count different types of statements using SPARQL queries
        from rdflib import RDF, OWL
        
        classes = len(list(graph.subjects(RDF.type, OWL.Class)))
        datatype_props = len(list(graph.subjects(RDF.type, OWL.DatatypeProperty)))
        object_props = len(list(graph.subjects(RDF.type, OWL.ObjectProperty)))
        
        print(f"📊 Ontology statistics:")
        print(f"   - Total triples: {num_triples}")
        print(f"   - Classes: {classes}")
        print(f"   - Datatype properties: {datatype_props}")
        print(f"   - Object properties: {object_props}")
        
        return True
        
    except ParserError as e:
        print(f"❌ Turtle syntax error: {e}")
        return False
    except FileNotFoundError:
        print(f"❌ File not found: {ontology_path}")
        return False
    except Exception as e:
        print(f"❌ Unexpected error: {e}")
        return False


def main():
    """Main test function."""
    print("🧪 Sports Activity Ontology - Turtle Syntax Validator")
    print("=" * 55)
    
    # Find the ontology file
    ontology_path = Path(__file__).parent / "ontology.ttl"
    
    if not ontology_path.exists():
        print(f"❌ Ontology file not found: {ontology_path}")
        sys.exit(1)
    
    # Run the test
    success = test_turtle_syntax(ontology_path)
    
    if success:
        print("\n🎉 All tests passed! The ontology has valid Turtle syntax.")
        sys.exit(0)
    else:
        print("\n💥 Tests failed! Please check the ontology syntax.")
        sys.exit(1)


if __name__ == "__main__":
    main()
