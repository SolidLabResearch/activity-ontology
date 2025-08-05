# Makefile for Sports Activity Ontology
.PHONY: test install setup clean docs check help prereqs

# Detect Python executable
PYTHON_CMD := $(shell command -v python3 2> /dev/null || command -v python 2> /dev/null || echo "python3")
PYTHON := .venv/bin/python

# Check prerequisites
prereqs:
	@echo "🔍 Checking prerequisites..."
	@if ! command -v $(PYTHON_CMD) >/dev/null 2>&1; then \
		echo "❌ Python not found"; \
		echo "   Install with: sudo apt install python3 python3-venv (Ubuntu/Debian)"; \
		echo "   Install with: brew install python3 (macOS)"; \
		exit 1; \
	else \
		echo "✅ Python found: $(PYTHON_CMD)"; \
	fi
	@if ! $(PYTHON_CMD) -c "import venv" 2>/dev/null; then \
		echo "❌ Python venv module not found"; \
		echo "   Install with: sudo apt install python3-venv (Ubuntu/Debian)"; \
		exit 1; \
	else \
		echo "✅ Python venv module available"; \
	fi
	@echo "✅ All prerequisites satisfied!"

# First-time setup
setup: prereqs
	@echo "📦 Installing Python dependencies..."
	@echo "Using Python: $(PYTHON_CMD)"
	@if [ ! -d ".venv" ]; then \
		echo "Creating virtual environment..."; \
		$(PYTHON_CMD) -m venv .venv; \
	else \
		echo "Virtual environment already exists."; \
	fi
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install -r requirements.txt
	@echo "✅ Installation complete! Virtual environment is ready."

# Run ontology validation tests
test:
	@echo "🧪 Running ontology validation tests..."
	$(PYTHON) test_ontology.py

# Generate documentation
docs:
	@echo "📚 Generating documentation..."
	./generate-pylode.sh

# Clean generated files
clean:
	@echo "🧹 Cleaning up..."
	rm -rf docs/
	rm -rf .venv/

# Help
help:
	@echo "Available targets:"
	@echo "  prereqs  - Check system prerequisites"
	@echo "  setup    - First-time setup (creates venv and installs dependencies)"
	@echo "  test     - Run ontology validation tests"
	@echo "  docs     - Generate documentation"
	@echo "  clean    - Clean generated files"
	@echo "  help     - Show this help message"
	@echo ""
	@echo "For first-time setup, run: make setup"
