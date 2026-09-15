# mizchi/js_dev

Development-only workspace member. **Never published.**

`moon.mod` has no `exclude` or `files` field (an `exclude` key makes `moon`
fail to calculate the build plan) and `source = "src"` does not scope the
publish archive, so everything under a published module's source tree ships to
consumers. This module is where dev-only packages live so they stay out of
`mizchi/js` and `mizchi/js_core`:

| package | moved from | what it is |
| ------- | ---------- | ---------- |
| `src/bench` | `mizchi/js` `src/internal/bench` | bundle-size bench over `js_convert` |
| `src/examples` | `mizchi/js` `src/examples` | literate `.mbt.md` docs, checked by `moon check` |
| `src/size/*` | `mizchi/js_core` `src/_tests/size*` | 14 bundle-size fixtures, one per feature |

`scripts/release.ts` publishes a hardcoded module list that does not include
this one, so adding packages here cannot leak into a release.

Being a `moon.work` member, everything here is still covered by
`moon check` / `moon test` / `moon build` from the repo root.

`.moonignore` is the other half of this: it *does* exclude files from the
publish archive, and each published module has one for its test code. It is
not a substitute for this module, because it cannot drop an `import` from a
`moon.mod` - `src/bench` pulls `js_convert`, so leaving it inside `mizchi/js`
would keep that dependency in the published manifest however many files were
ignored. See CLAUDE.md for the full set of packaging rules.

Note: `moon.mod` rejects `#` comments - keep notes in this file instead.
