# @drizzle - drizzle-orm bindings for MoonBit

**WARNING: This API is not recommended for use.**

This binding lacks type safety compared to TypeScript's drizzle-orm. Column access returns `@nostd.Any`, and field validation only happens at runtime.

## Recommendations

- Wait for a future code generation tool that creates typed MoonBit code from drizzle schemas
