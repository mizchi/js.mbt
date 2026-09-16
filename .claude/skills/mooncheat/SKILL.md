---
name: mooncheat
description: Moonbit cheatsheet to check syntax and corelibrary usages
allowed-tools: Read, Grep, Glob
---

- See [syntax.mbt.md](./syntax.mbt.md) to check moonbit syntax
- Search builtin APIs
  - Grep `~/.moon/lib/core` to check syntax details.
  - MoonDoc: `moon doc ArrayView`, `moon doc Array*`
- Grep `.mooncakes/` to check library usages.
  - username/pkg/(src/)?pkg.generated.mbti
- Configuration
  - moon.pkg (per package; superseded moon.pkg.json, and is not JSON)
    - See https://docs.moonbitlang.com/en/latest/toolchain/moon/package.html
    - `import { "a/b", "c/d" @alias }`, `supported_targets`, `warnings`,
      `pkgtype(kind: "executable")`, and `options(link: {...}, targets: {...})`
    - the schemas under moonbuild/template describe the old JSON form only
  - moon.mod (per module; superseded moon.mod.json, and is not JSON)
    - See https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
    - `name`, `version`, `import { "a/b@1.0.0" }`, `readme`, `source`,
      `preferred_target`; no `exclude`/`files`, and `#` comments are rejected
  - `moon check` warning and alert configuration
    - Get warning list by `moonc build-package -warn-help`
