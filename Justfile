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

# Run Cloudflare tests
test-cloudflare: build
    pnpm test:cloudflare

# Run Deno tests
test-deno: build
    deno test -A

# Run all tests (MoonBit, Cloudflare, Deno)
test-all: test test-cloudflare test-deno

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

# Development workflow: format, info, check
dev-cf: build
    pnpm wrangler dev fixtures/cf-worker.js
