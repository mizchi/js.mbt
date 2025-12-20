// Enum converter code generator
// Generates runtime conversion code between MoonBit JS representation and TypeScript union types

import type { EnumVariant, TypeDef } from "./types.ts";

export interface EnumConverterOptions {
  /** Generate fromMbt() function to convert MoonBit enum to TS union */
  generateFromMbt: boolean;
  /** Generate toMbt() function to convert TS union to MoonBit enum */
  generateToMbt: boolean;
  /** Include runtime type checking */
  includeTypeChecks: boolean;
}

const DEFAULT_OPTIONS: EnumConverterOptions = {
  generateFromMbt: true,
  generateToMbt: true,
  includeTypeChecks: true,
};

/**
 * Generate TypeScript runtime conversion code for MoonBit enums
 */
export function generateEnumConverter(
  typeDef: TypeDef,
  options: Partial<EnumConverterOptions> = {}
): string {
  if (typeDef.kind !== "enum" || !typeDef.variants) {
    return "";
  }

  const opts = { ...DEFAULT_OPTIONS, ...options };
  const name = typeDef.name;
  const variants = typeDef.variants;
  const output: string[] = [];

  // Generate MoonBit representation types
  output.push(generateMbtTypes(name, variants));
  output.push("");

  // Generate fromMbt converter
  if (opts.generateFromMbt) {
    output.push(generateFromMbt(name, variants, opts.includeTypeChecks));
    output.push("");
  }

  // Generate toMbt converter
  if (opts.generateToMbt) {
    output.push(generateToMbt(name, variants));
    output.push("");
  }

  return output.join("\n");
}

/**
 * Generate TypeScript types for MoonBit's JS representation
 */
function generateMbtTypes(name: string, variants: EnumVariant[]): string {
  const lines: string[] = [];

  lines.push(`// MoonBit representation types for ${name}`);

  // Unit variant type
  lines.push(`export interface Mbt${name}Unit {`);
  lines.push(`  readonly $tag: number;`);
  lines.push(`  readonly $name: string;`);
  lines.push(`}`);
  lines.push("");

  // Tuple variant type (if any have payloads)
  const hasPayload = variants.some((v) => v.payloadType);
  if (hasPayload) {
    lines.push(`export interface Mbt${name}Tuple {`);
    lines.push(`  readonly _0: unknown;`);
    lines.push(`}`);
    lines.push("");
  }

  // Combined MoonBit enum type
  if (hasPayload) {
    lines.push(`export type Mbt${name} = Mbt${name}Unit | Mbt${name}Tuple;`);
  } else {
    lines.push(`export type Mbt${name} = Mbt${name}Unit;`);
  }

  return lines.join("\n");
}

/**
 * Generate fromMbt converter function
 */
function generateFromMbt(
  name: string,
  variants: EnumVariant[],
  includeTypeChecks: boolean
): string {
  const lines: string[] = [];

  lines.push(`/**`);
  lines.push(` * Convert MoonBit ${name} to TypeScript union type`);
  lines.push(` */`);
  lines.push(`export function ${lowerFirst(name)}FromMbt(value: Mbt${name}): ${name} {`);

  if (includeTypeChecks) {
    lines.push(`  if (typeof value !== "object" || value === null) {`);
    lines.push(`    throw new Error("Expected MoonBit enum object");`);
    lines.push(`  }`);
    lines.push("");
  }

  // Check for $name (unit variants) or constructor.name (tuple variants)
  lines.push(`  // Check unit variant first`);
  lines.push(`  if ("$name" in value && typeof value.$name === "string") {`);
  lines.push(`    const unitValue = value as Mbt${name}Unit;`);
  lines.push(`    switch (unitValue.$name) {`);

  for (const variant of variants) {
    if (!variant.payloadType) {
      lines.push(`      case "${variant.name}":`);
      lines.push(`        return ${name}.${variant.name};`);
    }
  }

  lines.push(`      default:`);
  lines.push(`        throw new Error(\`Unknown variant: \${unitValue.$name}\`);`);
  lines.push(`    }`);
  lines.push(`  }`);
  lines.push("");

  // Tuple variants (check constructor.name)
  const tupleVariants = variants.filter((v) => v.payloadType);
  if (tupleVariants.length > 0) {
    lines.push(`  // Check tuple variant by constructor name`);
    lines.push(`  const ctorName = (value as object).constructor?.name ?? "";`);
    lines.push(`  const variantName = ctorName.split("$").pop() ?? "";`);
    lines.push("");
    lines.push(`  switch (variantName) {`);

    for (const variant of tupleVariants) {
      lines.push(`    case "${variant.name}":`);
      lines.push(`      return ${name}.${variant.name}((value as Mbt${name}Tuple)._0);`);
    }

    lines.push(`    default:`);
    lines.push(`      throw new Error(\`Unknown tuple variant: \${ctorName}\`);`);
    lines.push(`  }`);
  } else {
    lines.push(`  throw new Error("Could not determine variant type");`);
  }

  lines.push(`}`);

  return lines.join("\n");
}

/**
 * Generate toMbt converter function
 */
function generateToMbt(name: string, variants: EnumVariant[]): string {
  const lines: string[] = [];

  lines.push(`/**`);
  lines.push(` * Convert TypeScript ${name} to MoonBit representation`);
  lines.push(` * Note: This creates a plain object. For full MoonBit compatibility,`);
  lines.push(` * you may need to use the MoonBit API directly.`);
  lines.push(` */`);
  lines.push(`export function ${lowerFirst(name)}ToMbt(value: ${name}): Mbt${name} {`);
  lines.push(`  switch (value.$tag) {`);

  variants.forEach((variant, index) => {
    lines.push(`    case "${variant.name}":`);
    if (variant.payloadType) {
      lines.push(`      // Tuple variant - create object with _0`);
      lines.push(`      return { _0: (value as ${name}_${variant.name}).$0 } as Mbt${name};`);
    } else {
      lines.push(`      // Unit variant`);
      lines.push(`      return { $tag: ${index}, $name: "${variant.name}" };`);
    }
  });

  lines.push(`    default:`);
  lines.push(`      throw new Error(\`Unknown variant: \${(value as { $tag: string }).$tag}\`);`);
  lines.push(`  }`);
  lines.push(`}`);

  return lines.join("\n");
}

function lowerFirst(s: string): string {
  return s.charAt(0).toLowerCase() + s.slice(1);
}

/**
 * Generate a complete enum module with types and converters
 */
export function generateEnumModule(
  typeDef: TypeDef,
  options: Partial<EnumConverterOptions> = {}
): string {
  if (typeDef.kind !== "enum" || !typeDef.variants) {
    return "";
  }

  const name = typeDef.name;
  const variants = typeDef.variants;
  const output: string[] = [];

  output.push(`// ${name} enum types and converters`);
  output.push(`// Generated from .mbti - DO NOT EDIT`);
  output.push("");

  // Generate TypeScript union types (same as generator.ts)
  for (const variant of variants) {
    if (variant.payloadType) {
      output.push(
        `export interface ${name}_${variant.name} { readonly $tag: "${variant.name}"; readonly $0: unknown; }`
      );
    } else {
      output.push(
        `export interface ${name}_${variant.name} { readonly $tag: "${variant.name}"; }`
      );
    }
  }

  const variantTypes = variants.map((v) => `${name}_${v.name}`).join(" | ");
  output.push(`export type ${name} = ${variantTypes};`);
  output.push("");

  // Generate constructor object
  output.push(`export const ${name} = {`);
  for (const variant of variants) {
    if (variant.payloadType) {
      output.push(`  ${variant.name}(value: unknown): ${name}_${variant.name} {`);
      output.push(`    return { $tag: "${variant.name}", $0: value };`);
      output.push(`  },`);
    } else {
      output.push(`  ${variant.name}: { $tag: "${variant.name}" } as ${name}_${variant.name},`);
    }
  }
  output.push("");

  // Type guards
  for (const variant of variants) {
    output.push(`  is${variant.name}(value: ${name}): value is ${name}_${variant.name} {`);
    output.push(`    return value.$tag === "${variant.name}";`);
    output.push(`  },`);
  }
  output.push("");

  // Match function
  const handlersType = variants
    .map((v) => {
      if (v.payloadType) {
        return `${v.name}: (value: unknown) => R`;
      }
      return `${v.name}: () => R`;
    })
    .join("; ");

  output.push(`  match<R>(value: ${name}, handlers: { ${handlersType} }): R {`);
  output.push(`    switch (value.$tag) {`);
  for (const variant of variants) {
    if (variant.payloadType) {
      output.push(`      case "${variant.name}": return handlers.${variant.name}((value as ${name}_${variant.name}).$0);`);
    } else {
      output.push(`      case "${variant.name}": return handlers.${variant.name}();`);
    }
  }
  output.push(`    }`);
  output.push(`  },`);
  output.push(`} as const;`);
  output.push("");

  // Add converter code
  output.push(generateEnumConverter(typeDef, options));

  return output.join("\n");
}
