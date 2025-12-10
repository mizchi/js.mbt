# MoonBit build and test commands

# Default recipe: show available commands
default:
    @just --list

setup:
    pnpm install
    moon check

# Format code
fmt:
    moon fmt

# Check code
check:
    moon check

# Update interface files
info:
    moon info

# Format and update interfaces
format: info fmt

# Generate inheritance code and format
gen:
    pnpm generate:inheritance
    moon fmt

# Build the project
build:
    moon build

# Run tests
test:
    moon test

# Run tests and update snapshots
test-update:
    moon test --update

# Show test coverage
coverage:
    moon coverage analyze

# Show coverage for a specific package
coverage-package pkg:
    moon coverage analyze --package {{pkg}}

# Run all MoonBit checks (format, info, check, test)
check-all: format check test

# Run all tests (MoonBit, Deno, Bun)
test-all: test

# Clean build artifacts
clean:
    moon clean

# Development workflow: format, info, check
dev: format check

# CI workflow: format, info, check, build, test
ci: format check build test

# Development workflow: format, info, check
dev-react: build
    pnpm vite dev

test-playwright: build
    PLAYWRIGHT_TEST=1 moon test --no-parallelize ./src/npm/playwright/playwright_test.mbt 