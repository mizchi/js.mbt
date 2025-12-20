// Types for .mbti AST

export interface MbtiFile {
  package: string;
  imports: string[];
  values: FunctionDef[];
  errors: ErrorDef[];
  types: TypeDef[];
  typeAliases: TypeAlias[];
  traits: TraitDef[];
}

export interface FunctionDef {
  name: string;
  typeParams: string[];
  typeName?: string; // For methods (e.g., "TypeName::method")
  params: Param[];
  returnType: Type;
  isAsync: boolean;
  attributes: Attribute[];
}

export interface Param {
  name?: string;
  type: Type;
  isOptional: boolean;
}

export interface Type {
  kind: "simple" | "generic" | "function" | "tuple" | "option" | "array";
  name: string;
  typeArgs: Type[];
  // For function types
  params?: Type[];
  returnType?: Type;
}

export interface ErrorDef {
  name: string;
  type: Type;
}

export interface TypeDef {
  kind: "external" | "struct" | "enum";
  name: string;
  typeParams: string[];
  visibility: "pub" | "pub(all)" | "priv";
  isExternal: boolean;
  // For struct
  fields?: StructField[];
  // For enum
  variants?: EnumVariant[];
  // Methods
  methods: FunctionDef[];
  // Impl traits
  impls: string[];
  attributes: Attribute[];
}

export interface StructField {
  name: string;
  type: Type;
  isMutable: boolean;
}

export interface EnumVariant {
  name: string;
  payloadType?: Type;
}

export interface TypeAlias {
  name: string;
  typeParams: string[];
  type: Type;
}

export interface TraitDef {
  name: string;
  typeParams: string[];
  methods: FunctionDef[];
}

export interface Attribute {
  name: string;
  args: string[];
}
