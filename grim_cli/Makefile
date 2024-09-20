# Makefile for grim_cli

# Variables
BINARY_NAME = grim
INSTALL_PATH = /usr/local/bin

# Phony targets
.PHONY: build install deploy clean

# Default target
all: build

# Build the project
build:
	@echo "Building $(BINARY_NAME)..."
	@cargo build --release

# Install the binary
install: build
	@echo "Installing $(BINARY_NAME) to $(INSTALL_PATH)..."
	@sudo cp target/release/$(BINARY_NAME) $(INSTALL_PATH)/$(BINARY_NAME)
	@echo "Installation complete."

# Deploy (build and install)
deploy: install

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@cargo clean

# Help target
help:
	@echo "Available targets:"
	@echo "  build   - Compile the project"
	@echo "  install - Install the binary to $(INSTALL_PATH)"
	@echo "  deploy  - Build and install the binary"
	@echo "  clean   - Remove build artifacts"
	@echo "  help    - Show this help message"