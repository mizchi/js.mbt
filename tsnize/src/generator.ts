// TypeScript .d.ts generator from MbtiFile

import type {
  EnumVariant,
  FunctionDef,
  MbtiFile,
  Param,
  StructField,
  Type,
  TypeDef,
} from "./types.ts";

export interface GeneratorOptions {
  /** Generate union types for enums (default: true) */
  enumAsUnion: boolean;
  /** Generate converter functions for enums (default: true) */
  generateEnumConverters: boolean;
  /** Package name mapping for imports */
  packageMap?: Map<string, string>;
  /** Export style: "named" | "namespace" | "default" */
  exportStyle: "named" | "namespace";
}

const DEFAULT_OPTIONS: GeneratorOptions = {
  enumAsUnion: true,
  generateEnumConverters: true,
  exportStyle: "named",
};

export class Generator {
  private options: GeneratorOptions;
  private output: string[] = [];
  private indent: number = 0;

  constructor(options: Partial<GeneratorOptions> = {}) {
    this.options = { ...DEFAULT_OPTIONS, ...options };
  }

  generate(file: MbtiFile): string {
    this.output = [];

    this.writeLine("// Generated from .mbti file - DO NOT EDIT");
    this.writeLine("");

    // Generate imports if needed
    this.generateImports(file);

    // Generate type definitions
    for (const typeDef of file.types) {
      this.generateTypeDef(typeDef);
      this.writeLine("");
    }

    // Generate error types
    for (const error of file.errors) {
      this.writeLine(`export type ${error.name} = ${this.typeToTS(error.type)};`);
    }
    if (file.errors.length > 0) this.writeLine("");

    // Generate standalone functions
    for (const fn of file.values) {
      this.generateFunction(fn);
    }

    return this.output.join("\n");
  }

  private writeLine(line: string): void {
    const indentStr = "  ".repeat(this.indent);
    this.output.push(line ? indentStr + line : "");
  }

  private generateImports(file: MbtiFile): void {
    // Collect external type references
    const externalTypes = new Set<string>();

    for (const typeDef of file.types) {
      this.collectExternalTypes(typeDef, externalTypes);
    }

    // Generate import statements if needed
    if (externalTypes.size > 0 || file.imports.length > 0) {
      this.writeLine("// External type imports would go here");
      this.writeLine("");
    }
  }

  private collectExternalTypes(typeDef: TypeDef, types: Set<string>): void {
    // Collect types starting with @
    for (const method of typeDef.methods) {
      this.collectTypeRefs(method.returnType, types);
      for (const param of method.params) {
        this.collectTypeRefs(param.type, types);
      }
    }
  }

  private collectTypeRefs(type: Type, types: Set<string>): void {
    if (type.name.startsWith("@")) {
      types.add(type.name);
    }
    for (const arg of type.typeArgs) {
      this.collectTypeRefs(arg, types);
    }
  }

  private generateTypeDef(typeDef: TypeDef): void {
    switch (typeDef.kind) {
      case "external":
        this.generateExternalType(typeDef);
        break;
      case "struct":
        this.generateStruct(typeDef);
        break;
      case "enum":
        if (this.options.enumAsUnion) {
          this.generateEnumAsUnion(typeDef);
        } else {
          this.generateEnum(typeDef);
        }
        break;
    }

    // Generate methods as namespace or interface methods
    if (typeDef.methods.length > 0) {
      this.generateMethods(typeDef);
    }
  }

  private generateExternalType(typeDef: TypeDef): void {
    const typeParams = this.typeParamsToTS(typeDef.typeParams);
    this.writeLine(`export interface ${typeDef.name}${typeParams} {`);
    this.indent++;
    this.writeLine(`readonly __brand: "${typeDef.name}";`);
    this.indent--;
    this.writeLine("}");
  }

  private generateStruct(typeDef: TypeDef): void {
    const typeParams = this.typeParamsToTS(typeDef.typeParams);
    this.writeLine(`export interface ${typeDef.name}${typeParams} {`);
    this.indent++;
    for (const field of typeDef.fields ?? []) {
      this.generateStructField(field);
    }
    this.indent--;
    this.writeLine("}");
  }

  private generateStructField(field: StructField): void {
    const readonly = field.isMutable ? "" : "readonly ";
    this.writeLine(`${readonly}${field.name}: ${this.typeToTS(field.type)};`);
  }

  private generateEnum(typeDef: TypeDef): void {
    const typeParams = this.typeParamsToTS(typeDef.typeParams);
    this.writeLine(`export enum ${typeDef.name}${typeParams} {`);
    this.indent++;
    for (const variant of typeDef.variants ?? []) {
      this.writeLine(`${variant.name},`);
    }
    this.indent--;
    this.writeLine("}");
  }

  private generateEnumAsUnion(typeDef: TypeDef): void {
    const variants = typeDef.variants ?? [];
    const typeParams = this.typeParamsToTS(typeDef.typeParams);

    // Generate individual variant types
    for (const variant of variants) {
      this.generateVariantType(typeDef.name, variant, typeDef.typeParams);
    }

    // Generate union type
    const variantTypes = variants.map((v) => `${typeDef.name}_${v.name}`).join(" | ");
    this.writeLine(`export type ${typeDef.name}${typeParams} = ${variantTypes};`);
    this.writeLine("");

    // Generate converter functions if enabled
    if (this.options.generateEnumConverters) {
      this.generateEnumConverters(typeDef, variants);
    }
  }

  private generateVariantType(
    enumName: string,
    variant: EnumVariant,
    _typeParams: string[]
  ): void {
    if (variant.payloadType) {
      this.writeLine(
        `export interface ${enumName}_${variant.name} { readonly $tag: "${variant.name}"; readonly $0: ${this.typeToTS(variant.payloadType)}; }`
      );
    } else {
      this.writeLine(
        `export interface ${enumName}_${variant.name} { readonly $tag: "${variant.name}"; }`
      );
    }
  }

  private generateEnumConverters(typeDef: TypeDef, variants: EnumVariant[]): void {
    const name = typeDef.name;
    const typeParams = this.typeParamsToTS(typeDef.typeParams);
    const typeArgs = typeDef.typeParams.length > 0
      ? `<${typeDef.typeParams.join(", ")}>`
      : "";

    this.writeLine(`export const ${name} = {`);
    this.indent++;

    // Constructor functions
    for (const variant of variants) {
      if (variant.payloadType) {
        const payloadTS = this.typeToTS(variant.payloadType);
        this.writeLine(
          `${variant.name}${typeParams}(value: ${payloadTS}): ${name}${typeArgs} { return { $tag: "${variant.name}", $0: value }; },`
        );
      } else {
        this.writeLine(
          `${variant.name}: { $tag: "${variant.name}" } as ${name}${typeArgs},`
        );
      }
    }

    // Type guards
    this.writeLine("");
    for (const variant of variants) {
      this.writeLine(
        `is${variant.name}${typeParams}(value: ${name}${typeArgs}): value is ${name}_${variant.name} { return value.$tag === "${variant.name}"; },`
      );
    }

    // Match function
    this.writeLine("");
    this.generateMatchFunction(typeDef, variants);

    this.indent--;
    this.writeLine("} as const;");
  }

  private generateMatchFunction(typeDef: TypeDef, variants: EnumVariant[]): void {
    const name = typeDef.name;
    const typeParams = typeDef.typeParams.length > 0
      ? `<${typeDef.typeParams.join(", ")}, R>`
      : "<R>";
    const typeArgs = typeDef.typeParams.length > 0
      ? `<${typeDef.typeParams.join(", ")}>`
      : "";

    const handlersType = variants
      .map((v) => {
        if (v.payloadType) {
          return `${v.name}: (value: ${this.typeToTS(v.payloadType)}) => R`;
        }
        return `${v.name}: () => R`;
      })
      .join(", ");

    this.writeLine(
      `match${typeParams}(value: ${name}${typeArgs}, handlers: { ${handlersType} }): R {`
    );
    this.indent++;
    this.writeLine("switch (value.$tag) {");
    this.indent++;
    for (const variant of variants) {
      if (variant.payloadType) {
        this.writeLine(
          `case "${variant.name}": return handlers.${variant.name}(value.$0);`
        );
      } else {
        this.writeLine(`case "${variant.name}": return handlers.${variant.name}();`);
      }
    }
    this.indent--;
    this.writeLine("}");
    this.indent--;
    this.writeLine("},");
  }

  private generateMethods(typeDef: TypeDef): void {
    this.writeLine(`export namespace ${typeDef.name} {`);
    this.indent++;
    for (const method of typeDef.methods) {
      this.generateMethod(typeDef, method);
    }
    this.indent--;
    this.writeLine("}");
  }

  private generateMethod(typeDef: TypeDef, method: FunctionDef): void {
    const typeParams = this.typeParamsToTS(method.typeParams);
    const params = this.paramsToTS(method.params, typeDef);
    const returnType = method.isAsync
      ? `Promise<${this.typeToTS(method.returnType)}>`
      : this.typeToTS(method.returnType);

    this.writeLine(`export function ${method.name}${typeParams}(${params}): ${returnType};`);
  }

  private generateFunction(fn: FunctionDef): void {
    const typeParams = this.typeParamsToTS(fn.typeParams);
    const params = this.paramsToTS(fn.params);
    const returnType = fn.isAsync
      ? `Promise<${this.typeToTS(fn.returnType)}>`
      : this.typeToTS(fn.returnType);

    this.writeLine(`export function ${fn.name}${typeParams}(${params}): ${returnType};`);
  }

  private typeParamsToTS(params: string[]): string {
    if (params.length === 0) return "";
    return `<${params.join(", ")}>`;
  }

  private paramsToTS(params: Param[], typeDef?: TypeDef): string {
    return params
      .filter((p) => p.type.name !== "Self") // Skip Self parameter
      .map((p, i) => {
        const name = p.name ?? `arg${i}`;
        const optional = p.isOptional ? "?" : "";
        return `${name}${optional}: ${this.typeToTS(p.type, typeDef)}`;
      })
      .join(", ");
  }

  private typeToTS(type: Type, context?: TypeDef): string {
    // Handle Self type
    if (type.name === "Self") {
      return context?.name ?? "this";
    }

    // Handle Option type
    if (type.kind === "option" && type.typeArgs.length > 0) {
      return `${this.typeToTS(type.typeArgs[0], context)} | undefined`;
    }

    // Handle function types
    if (type.kind === "function") {
      const params = (type.params ?? [])
        .map((p, i) => `arg${i}: ${this.typeToTS(p, context)}`)
        .join(", ");
      const ret = type.returnType ? this.typeToTS(type.returnType, context) : "void";
      return `(${params}) => ${ret}`;
    }

    // Handle tuple types
    if (type.kind === "tuple") {
      const elements = type.typeArgs.map((t) => this.typeToTS(t, context)).join(", ");
      return `[${elements}]`;
    }

    // Handle built-in type mappings
    const typeMap: Record<string, string> = {
      String: "string",
      Int: "number",
      Int64: "bigint",
      UInt: "number",
      UInt64: "bigint",
      Float: "number",
      Double: "number",
      Bool: "boolean",
      Unit: "void",
      Bytes: "Uint8Array",
      BigInt: "bigint",
      Any: "any",
      Error: "Error",
      Nullable: "null",
      Nullish: "null | undefined",
    };

    const mappedType = typeMap[type.name];
    if (mappedType) {
      return mappedType;
    }

    // Handle Array type
    if (type.name === "Array" && type.typeArgs.length > 0) {
      return `${this.typeToTS(type.typeArgs[0], context)}[]`;
    }

    // Handle Promise type
    if (type.name === "Promise" && type.typeArgs.length > 0) {
      return `Promise<${this.typeToTS(type.typeArgs[0], context)}>`;
    }

    // Handle external package types (@package.Type)
    if (type.name.startsWith("@")) {
      const parts = type.name.split(".");
      const typeName = parts[parts.length - 1];
      const typeArgs =
        type.typeArgs.length > 0
          ? `<${type.typeArgs.map((t) => this.typeToTS(t, context)).join(", ")}>`
          : "";
      return `${typeName}${typeArgs}`;
    }

    // Handle generic types
    if (type.typeArgs.length > 0) {
      const args = type.typeArgs.map((t) => this.typeToTS(t, context)).join(", ");
      return `${type.name}<${args}>`;
    }

    return type.name;
  }
}
