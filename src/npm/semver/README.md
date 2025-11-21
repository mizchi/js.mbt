# @mizchi/js/npm/semver

MoonBit FFI bindings for the [npm semver package](https://www.npmjs.com/package/semver).

## Prerequisites

You need to install the `semver` package in your Node.js environment:

```bash
npm install semver
# or
yarn add semver
# or
pnpm add semver
```

## Usage

```moonbit
let version = @npm/semver.parse("1.2.3")
@npm/semver.valid("1.2.3") // returns "1.2.3"
@npm/semver.clean("  =v1.2.3   ") // returns "1.2.3"

// Comparison
@npm/semver.gt("1.2.4", "1.2.3") // true
@npm/semver.satisfies("1.2.3", "1.x || >=2.5.0") // true

// Version manipulation
@npm/semver.inc("1.2.3", "major") // "2.0.0"
@npm/semver.inc("1.2.3", "minor") // "1.3.0"
@npm/semver.inc("1.2.3", "patch") // "1.2.4"

// Version parts
@npm/semver.major("1.2.3") // 1
@npm/semver.minor("1.2.3") // 2
@npm/semver.patch("1.2.3") // 3

// Arrays
let versions = ["1.2.3", "1.0.0", "2.0.0"].to_js()
@npm/semver.sort(versions)
@npm/semver.max(versions)
```

## API Reference

See the [npm semver documentation](https://github.com/npm/node-semver#usage) for detailed usage information.

## Supported Functions

- Version Parsing: `parse`, `valid`, `clean`, `coerce`
- Comparison: `compare`, `gt`, `gte`, `lt`, `lte`, `eq`, `neq`
- Ranges: `satisfies`, `valid_range`, `max_satisfying`, `min_satisfying`, `gtr`, `ltr`, `outside`
- Version Manipulation: `inc`, `diff`
- Version Parts: `major`, `minor`, `patch`, `prerelease`
- Array Operations: `sort`, `rsort`, `max`, `min`
