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
test-moon:
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

# Run Deno tests (mizchi/js_deno integration bundle, debug build)
test-deno:
    deno task test:deno

# Run the mizchi/js_convert TypeScript tests (needs the release build)
test-convert:
    deno task test:convert

# Run WASM-GC tests with Deno
test-wasm:
    moon build --target wasm-gc --release modules/js/src/wasm
    deno run --allow-read modules/js/src/wasm/test_deno.ts

# Run WASM-GC DOM tests with happy-dom
test-wasm-dom:
    moon build --target wasm-gc --release modules/js/src/wasm
    deno run --allow-read --allow-env modules/js/src/wasm/test_happydom.ts

# Run Bun tests
test-bun: build
    bun test _build/js/debug/build/mizchi/js_bun/bun_test/bun_test.js

# Run all tests (MoonBit, Deno, Bun, WASM, WASM-DOM)
test: test-moon test-deno test-convert test-bun test-wasm test-wasm-dom

# Clean build artifacts
clean:
    moon clean

# Development workflow: format, info, check
dev: format check

# CI workflow: format, info, check, build, test
ci: format check build test

# Development workflow: format, info, check
dev-react: build
    pnpm run dev:spa

test-playwright: build
    PLAYWRIGHT_TEST=1 moon test --no-parallelize ./src/npm/playwright/playwright_test.mbt
