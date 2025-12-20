// Parser for .mbti files

import type { Token, TokenType } from "./lexer.ts";
import type {
  Attribute,
  EnumVariant,
  ErrorDef,
  FunctionDef,
  MbtiFile,
  Param,
  StructField,
  Type,
  TypeDef,
} from "./types.ts";

export class Parser {
  private tokens: Token[];
  private pos: number = 0;

  constructor(tokens: Token[]) {
    // Filter out newlines and comments that aren't section markers
    this.tokens = tokens.filter((t) => t.type !== "NEWLINE");
  }

  private peek(offset = 0): Token {
    return this.tokens[this.pos + offset] ?? { type: "EOF", value: "", line: 0, column: 0 };
  }

  private advance(): Token {
    return this.tokens[this.pos++];
  }

  private expect(type: TokenType): Token {
    const token = this.advance();
    if (token.type !== type) {
      throw new Error(
        `Expected ${type} but got ${token.type} (${token.value}) at line ${token.line}:${token.column}`
      );
    }
    return token;
  }

  private match(...types: TokenType[]): boolean {
    return types.includes(this.peek().type);
  }

  private skipComments(): void {
    while (this.match("COMMENT")) {
      this.advance();
    }
  }

  parse(): MbtiFile {
    const result: MbtiFile = {
      package: "",
      imports: [],
      values: [],
      errors: [],
      types: [],
      typeAliases: [],
      traits: [],
    };

    this.skipComments(); // Skip "Generated using moon info" comment

    // Parse package
    if (this.match("PACKAGE")) {
      this.advance();
      result.package = this.expect("STRING").value;
    }

    // Parse imports
    this.skipComments();
    if (this.match("IMPORT")) {
      this.advance();
      this.expect("LPAREN");
      while (!this.match("RPAREN") && !this.match("EOF")) {
        this.skipComments();
        if (this.match("STRING")) {
          result.imports.push(this.advance().value);
        } else {
          break;
        }
      }
      if (this.match("RPAREN")) this.advance();
    }

    // Parse sections
    while (!this.match("EOF")) {
      this.skipComments();
      if (this.match("EOF")) break;

      // Check for section markers in comments
      if (this.match("COMMENT")) {
        const comment = this.advance().value;
        if (comment === "Values" || comment === "Errors" ||
            comment === "Types and methods" || comment === "Type aliases" ||
            comment === "Traits") {
          continue;
        }
      }

      // Parse declarations
      if (this.match("HASH")) {
        this.parseAttribute();
        continue;
      }

      if (this.match("PUB", "PUB_ALL", "PRIV")) {
        this.parseDeclaration(result);
        continue;
      }

      // Skip unknown tokens
      this.advance();
    }

    return result;
  }

  private attributes: Attribute[] = [];

  private parseAttribute(): Attribute {
    this.expect("HASH");
    const name = this.expect("IDENT").value;
    const args: string[] = [];
    if (this.match("LPAREN")) {
      this.advance();
      while (!this.match("RPAREN") && !this.match("EOF")) {
        if (this.match("STRING")) {
          args.push(this.advance().value);
        } else if (this.match("IDENT")) {
          args.push(this.advance().value);
        } else {
          this.advance();
        }
        if (this.match("COMMA")) this.advance();
      }
      if (this.match("RPAREN")) this.advance();
    }
    const attr = { name, args };
    this.attributes.push(attr);
    return attr;
  }

  private consumeAttributes(): Attribute[] {
    const attrs = [...this.attributes];
    this.attributes = [];
    return attrs;
  }

  private parseDeclaration(result: MbtiFile): void {
    const visibility = this.advance(); // pub, pub(all), or priv
    const vis = visibility.type === "PUB_ALL" ? "pub(all)" : visibility.value;

    const attributes = this.consumeAttributes();
    const isExternal = attributes.some((a) => a.name === "external");

    // pub async fn
    if (this.match("ASYNC")) {
      this.advance();
      if (this.match("FN")) {
        const fn = this.parseFunction(vis, true);
        fn.attributes = attributes;
        this.addFunctionOrMethod(result, fn);
        return;
      }
    }

    // pub fn
    if (this.match("FN")) {
      const fn = this.parseFunction(vis, false);
      fn.attributes = attributes;
      this.addFunctionOrMethod(result, fn);
      return;
    }

    // pub type
    if (this.match("TYPE")) {
      this.advance();
      const name = this.expect("IDENT").value;
      const typeParams = this.parseTypeParams();
      result.types.push({
        kind: "external",
        name,
        typeParams,
        visibility: vis as "pub" | "pub(all)" | "priv",
        isExternal: true,
        methods: [],
        impls: [],
        attributes,
      });
      return;
    }

    // pub struct
    if (this.match("STRUCT")) {
      this.advance();
      const name = this.expect("IDENT").value;
      const typeParams = this.parseTypeParams();
      const fields = this.parseStructFields();
      result.types.push({
        kind: "struct",
        name,
        typeParams,
        visibility: vis as "pub" | "pub(all)" | "priv",
        isExternal: false,
        fields,
        methods: [],
        impls: [],
        attributes,
      });
      return;
    }

    // pub enum
    if (this.match("ENUM")) {
      this.advance();
      const name = this.expect("IDENT").value;
      const typeParams = this.parseTypeParams();
      const variants = this.parseEnumVariants();
      result.types.push({
        kind: "enum",
        name,
        typeParams,
        visibility: vis as "pub" | "pub(all)" | "priv",
        isExternal: false,
        variants,
        methods: [],
        impls: [],
        attributes,
      });
      return;
    }

    // pub suberror
    if (this.match("SUBERROR")) {
      this.advance();
      const name = this.expect("IDENT").value;
      const type = this.parseType();
      result.errors.push({ name, type });
      return;
    }

    // pub impl Trait for Type
    if (this.match("IMPL")) {
      this.advance();
      const traitName = this.expect("IDENT").value;
      this.expect("FOR");
      const typeName = this.expect("IDENT").value;
      // Find the type and add the impl
      const typeDef = result.types.find((t) => t.name === typeName);
      if (typeDef) {
        typeDef.impls.push(traitName);
      }
      return;
    }
  }

  private addFunctionOrMethod(result: MbtiFile, fn: FunctionDef): void {
    if (fn.typeName) {
      // It's a method, find or create the type
      let typeDef = result.types.find((t) => t.name === fn.typeName);
      if (!typeDef) {
        typeDef = {
          kind: "external",
          name: fn.typeName,
          typeParams: [],
          visibility: "pub",
          isExternal: true,
          methods: [],
          impls: [],
          attributes: [],
        };
        result.types.push(typeDef);
      }
      typeDef.methods.push(fn);
    } else {
      result.values.push(fn);
    }
  }

  private parseFunction(visibility: string, isAsync: boolean): FunctionDef {
    this.expect("FN");

    // Type parameters before function name (e.g., pub fn[T] name)
    let typeParams = this.parseTypeParams();

    // Function name - could be TypeName::method or just name
    let name = this.expect("IDENT").value;
    let typeName: string | undefined;

    if (this.match("DOUBLE_COLON")) {
      this.advance();
      typeName = name;
      name = this.expect("IDENT").value;
    }

    // Type parameters after method name (e.g., pub fn TypeName::method[T])
    if (this.match("LBRACKET") && typeParams.length === 0) {
      typeParams = this.parseTypeParams();
    }

    // Parameters
    this.expect("LPAREN");
    const params: Param[] = [];
    while (!this.match("RPAREN") && !this.match("EOF")) {
      this.skipComments();
      const param = this.parseParam();
      params.push(param);
      if (this.match("COMMA")) this.advance();
    }
    this.expect("RPAREN");

    // Return type
    let returnType: Type = { kind: "simple", name: "Unit", typeArgs: [] };
    if (this.match("ARROW")) {
      this.advance();
      returnType = this.parseType();
    }

    // Check for raise/noraise (only process once, don't loop)
    if (this.match("RAISE")) {
      this.advance();
      // Optionally there might be an error type after raise
      if (this.peek().type === "IDENT" && !["pub", "priv", "fn", "type", "struct", "enum", "async", "impl", "suberror"].includes(this.peek().value)) {
        this.advance();
      }
    } else if (this.match("NORAISE")) {
      this.advance();
    }

    return {
      name,
      typeParams,
      typeName,
      params,
      returnType,
      isAsync,
      attributes: [],
    };
  }

  private parseTypeParams(): string[] {
    const params: string[] = [];
    if (this.match("LBRACKET")) {
      this.advance();
      while (!this.match("RBRACKET") && !this.match("EOF")) {
        if (this.match("IDENT")) {
          const param = this.advance().value;
          params.push(param);
          // Skip trait bounds (: Trait + Trait2)
          if (this.match("COLON")) {
            this.advance();
            while (this.match("IDENT")) {
              this.advance();
              if (this.peek().value === "+") {
                this.advance();
              } else {
                break;
              }
            }
          }
        }
        if (this.match("COMMA")) this.advance();
      }
      if (this.match("RBRACKET")) this.advance();
    }
    return params;
  }

  private parseParam(): Param {
    // Check for optional parameter (name? : Type)
    // or named parameter (name : Type)
    // or just type
    let name: string | undefined;
    let isOptional = false;

    // Check for Self or Self[T]
    if (this.match("SELF")) {
      this.advance();
      // Check for generic Self[T]
      let typeArgs: Type[] = [];
      if (this.match("LBRACKET")) {
        typeArgs = this.parseTypeArgs();
      }
      const selfType: Type = typeArgs.length > 0
        ? { kind: "generic", name: "Self", typeArgs }
        : { kind: "simple", name: "Self", typeArgs: [] };
      return { type: selfType, isOptional: false };
    }

    // Look ahead to see if this is a named parameter
    // Named parameter patterns: "name : Type" or "name? : Type"
    if (this.match("IDENT")) {
      const next = this.peek(1).type;
      const afterNext = this.peek(2).type;

      // Check for "name : Type"
      if (next === "COLON") {
        name = this.advance().value;
        this.expect("COLON");
      }
      // Check for "name? : Type" (optional named parameter)
      else if (next === "QUESTION" && afterNext === "COLON") {
        name = this.advance().value;
        this.advance(); // skip ?
        isOptional = true;
        this.expect("COLON");
      }
      // Otherwise it's just a type, fall through to parseType
    }

    const type = this.parseType();
    return { name, type, isOptional };
  }

  private parseType(): Type {
    // Handle async function type: async () -> T
    if (this.match("ASYNC")) {
      this.advance();
      if (this.match("LPAREN")) {
        this.advance();
        const types: Type[] = [];
        while (!this.match("RPAREN") && !this.match("EOF")) {
          types.push(this.parseType());
          if (this.match("COMMA")) this.advance();
        }
        this.expect("RPAREN");

        if (this.match("ARROW")) {
          this.advance();
          const returnType = this.parseType();
          // Skip raise/noraise
          if (this.match("RAISE")) {
            this.advance();
            if (this.peek().type === "IDENT" && !["pub", "priv", "fn", "type", "struct", "enum", "async", "impl", "suberror"].includes(this.peek().value)) {
              this.advance();
            }
          } else if (this.match("NORAISE")) {
            this.advance();
          }
          // Return as async function - wrap return in Promise
          return {
            kind: "function",
            name: "AsyncFunction",
            typeArgs: [],
            params: types,
            returnType: { kind: "generic", name: "Promise", typeArgs: [returnType] }
          };
        }
      }
      // Fallback for malformed async type
      return { kind: "simple", name: "Unknown", typeArgs: [] };
    }

    // Option type with ?
    if (this.peek().type === "IDENT" || this.peek().type === "SELF") {
      const typeName = this.advance().value;

      // Check for type parameters
      let typeArgs: Type[] = [];
      if (this.match("LBRACKET")) {
        typeArgs = this.parseTypeArgs();
      }

      // Check for ?
      if (this.match("QUESTION")) {
        this.advance();
        const innerType: Type = typeArgs.length > 0
          ? { kind: "generic", name: typeName, typeArgs }
          : { kind: "simple", name: typeName, typeArgs: [] };
        return {
          kind: "option",
          name: "Option",
          typeArgs: [innerType],
        };
      }

      // Handle @package.Type format
      if (typeName.startsWith("@")) {
        return { kind: "simple", name: typeName, typeArgs };
      }

      if (typeArgs.length > 0) {
        return { kind: "generic", name: typeName, typeArgs };
      }
      return { kind: "simple", name: typeName, typeArgs: [] };
    }

    // Tuple or function type
    if (this.match("LPAREN")) {
      this.advance();
      const types: Type[] = [];
      while (!this.match("RPAREN") && !this.match("EOF")) {
        types.push(this.parseType());
        if (this.match("COMMA")) this.advance();
      }
      this.expect("RPAREN");

      // Check for function type
      if (this.match("ARROW")) {
        this.advance();
        const returnType = this.parseType();
        // Skip raise/noraise after function return type
        if (this.match("RAISE")) {
          this.advance();
          // Handle raise? (optional error)
          if (this.match("QUESTION")) {
            this.advance();
          }
          // Skip error type if present
          else if (this.peek().type === "IDENT" && !["pub", "priv", "fn", "type", "struct", "enum", "async", "impl", "suberror"].includes(this.peek().value)) {
            this.advance();
          }
        } else if (this.match("NORAISE")) {
          this.advance();
        }
        return { kind: "function", name: "Function", typeArgs: [], params: types, returnType };
      }

      // Tuple
      if (types.length > 1) {
        return { kind: "tuple", name: "Tuple", typeArgs: types };
      }
      return types[0] || { kind: "simple", name: "Unit", typeArgs: [] };
    }

    // Array type
    if (this.match("LBRACKET")) {
      // This shouldn't happen in normal type position, skip
      this.advance();
      while (!this.match("RBRACKET") && !this.match("EOF")) {
        this.advance();
      }
      if (this.match("RBRACKET")) this.advance();
    }

    return { kind: "simple", name: "Unknown", typeArgs: [] };
  }

  private parseTypeArgs(): Type[] {
    const args: Type[] = [];
    if (this.match("LBRACKET")) {
      this.advance();
      while (!this.match("RBRACKET") && !this.match("EOF")) {
        args.push(this.parseType());
        if (this.match("COMMA")) this.advance();
      }
      if (this.match("RBRACKET")) this.advance();
    }
    return args;
  }

  private parseStructFields(): StructField[] {
    const fields: StructField[] = [];
    if (this.match("LBRACE")) {
      this.advance();
      while (!this.match("RBRACE") && !this.match("EOF")) {
        let isMutable = false;
        if (this.match("MUT")) {
          this.advance();
          isMutable = true;
        }
        if (this.match("IDENT")) {
          const name = this.advance().value;
          this.expect("COLON");
          const type = this.parseType();
          fields.push({ name, type, isMutable });
        }
        // Skip newlines and commas within struct
        if (this.match("COMMA")) this.advance();
      }
      if (this.match("RBRACE")) this.advance();
    }
    return fields;
  }

  private parseEnumVariants(): EnumVariant[] {
    const variants: EnumVariant[] = [];
    if (this.match("LBRACE")) {
      this.advance();
      while (!this.match("RBRACE") && !this.match("EOF")) {
        if (this.match("IDENT")) {
          const name = this.advance().value;
          let payloadType: Type | undefined;
          // Check for payload type
          if (this.match("LPAREN")) {
            this.advance();
            payloadType = this.parseType();
            this.expect("RPAREN");
          }
          variants.push({ name, payloadType });
        }
        // Skip newlines and commas
        if (this.match("COMMA")) this.advance();
      }
      if (this.match("RBRACE")) this.advance();
    }
    return variants;
  }
}
