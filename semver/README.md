# mizchi/npm_typed/semver

MoonBit FFI bindings for the [npm semver package](https://www.npmjs.com/package/semver).

## Installation

```bash
moon add mizchi/js
moon add mizchi/npm_typed
npm install semver
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "mizchi/js",
    "mizchi/js/core",
    "mizchi/npm_typed/semver"
  ]
}
```

## Usage

```moonbit
let version = @semver.parse("1.2.3")
@semver.valid("1.2.3") // returns "1.2.3"
@semver.clean("  =v1.2.3   ") // returns "1.2.3"

// Comparison
@semver.gt("1.2.4", "1.2.3") // true
@semver.satisfies("1.2.3", "1.x || >=2.5.0") // true

// Version manipulation
@semver.inc("1.2.3", "major") // "2.0.0"
@semver.inc("1.2.3", "minor") // "1.3.0"
@semver.inc("1.2.3", "patch") // "1.2.4"

// Version parts
@semver.major("1.2.3") // 1
@semver.minor("1.2.3") // 2
@semver.patch("1.2.3") // 3

// Arrays
let versions = ["1.2.3", "1.0.0", "2.0.0"]
@semver.sort(versions)
@semver.max(versions)
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
