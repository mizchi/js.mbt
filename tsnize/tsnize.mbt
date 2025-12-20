// tsnize - Generate TypeScript definitions from MoonBit .mbti files
//
// Uses moonbitlang/parser to correctly parse MBTI and generate TypeScript

///|
/// Parse MBTI content and return the AST
pub fn parse_mbti(content : String, filename : String) -> @mbti_ast.Mbti raise {
  let lex_result = @lexer.tokens_from_string(
    name=filename,
    content,
    comment=false,
  )
  let tokens = lex_result.tokens.filter(fn(triple) {
    not(triple.0 is (NEWLINE | COMMENT(_)))
  })
  @mbti_parser.mbti(tokens, initial_pos=@basic.Position::{
    fname: filename,
    lnum: 1,
    bol: 0,
    cnum: 0,
  })
}

///|
/// Generate TypeScript .d.ts content from MBTI AST
pub fn generate_dts(mbti : @mbti_ast.Mbti) -> String {
  let buf = StringBuilder::new()
  buf.write_string("// Generated from .mbti file - DO NOT EDIT\n\n")

  // Generate each signature
  for item in mbti.sigs {
    let (sig, _loc) = item
    let ts = generate_sig(sig)
    if ts.length() > 0 {
      buf.write_string(ts)
      buf.write_string("\n\n")
    }
  }
  buf.to_string().trim_space().to_string()
}

///|
fn generate_sig(sig : @mbti_ast.Sig) -> String {
  match sig {
    Func(func_sig) => generate_func_sig(func_sig)
    Type(type_sig) => generate_type_sig(type_sig)
    Alias(alias_sig) => generate_alias_sig(alias_sig)
    Trait(trait_sig) => generate_trait_sig(trait_sig)
    Impl(_) => "" // Skip impl signatures for now
    Const(const_sig) => generate_const_sig(const_sig)
    Value(value_sig) => generate_value_sig(value_sig)
  }
}

///|
fn generate_func_sig(func : @mbti_ast.FuncSig) -> String {
  let buf = StringBuilder::new()
  let func_name = to_camel_case(func.name.name)

  // Generate type parameters
  let type_params = generate_type_params(func.type_params)

  // Generate parameters
  let params = generate_params(func.params)

  // Generate return type
  let (ret_type, _err_type) = func.return_
  let return_ts = generate_type(ret_type)
  match func.type_name {
    Some(type_name) => {
      // Method
      let ts_type_name = type_name.name
      buf.write_string("// Method: ")
      buf.write_string(ts_type_name)
      buf.write_string("::")
      buf.write_string(func.name.name)
    }
    None => {
      // Standalone function
      buf.write_string("export function ")
      buf.write_string(func_name)
      buf.write_string(type_params)
      buf.write_string("(")
      buf.write_string(params)
      buf.write_string("): ")
      buf.write_string(return_ts)
      buf.write_string(";")
    }
  }
  buf.to_string()
}

///|
fn generate_type_sig(type_sig : @mbti_ast.TypeSig) -> String {
  let buf = StringBuilder::new()
  let name = type_sig.name.name
  let type_params = generate_type_params_no_constraints(type_sig.type_params)
  match type_sig.components {
    Abstract => {
      buf.write_string("export interface ")
      buf.write_string(name)
      buf.write_string(type_params)
      buf.write_string(" {\n  readonly __brand: \"")
      buf.write_string(name)
      buf.write_string("\";\n}")
    }
    Extern => {
      buf.write_string("export interface ")
      buf.write_string(name)
      buf.write_string(type_params)
      buf.write_string(" {\n  readonly __brand: \"")
      buf.write_string(name)
      buf.write_string("\";\n}")
    }
    Newtype(ty) => {
      buf.write_string("export type ")
      buf.write_string(name)
      buf.write_string(type_params)
      buf.write_string(" = ")
      buf.write_string(generate_type(ty))
      buf.write_string(";")
    }
    Variant(constrs) => generate_enum_type(buf, name, type_params, constrs)
    Record(fields) => generate_struct_type(buf, name, type_params, fields)
    TupleStruct(types) => {
      buf.write_string("export type ")
      buf.write_string(name)
      buf.write_string(type_params)
      buf.write_string(" = [")
      let types_arr = types.to_array()
      for i, ty in types_arr {
        if i > 0 {
          buf.write_string(", ")
        }
        buf.write_string(generate_type(ty))
      }
      buf.write_string("];")
    }
    Alias(ty) => {
      buf.write_string("export type ")
      buf.write_string(name)
      buf.write_string(type_params)
      buf.write_string(" = ")
      buf.write_string(generate_type(ty))
      buf.write_string(";")
    }
    Error(_) => {
      buf.write_string("export type ")
      buf.write_string(name)
      buf.write_string(" = Error;")
    }
  }
  buf.to_string()
}

///|
fn generate_enum_type(
  buf : StringBuilder,
  name : String,
  type_params : String,
  constrs : @list.List[@syntax.ConstrDecl],
) -> Unit {
  let constrs_arr = constrs.to_array()

  // Generate individual variant types
  for constr in constrs_arr {
    let variant_name = constr.name.name
    buf.write_string("export interface ")
    buf.write_string(name)
    buf.write_string("_")
    buf.write_string(variant_name)
    buf.write_string(type_params)
    buf.write_string(" { readonly $tag: \"")
    buf.write_string(variant_name)
    buf.write_string("\"")

    // Add payload fields if any
    match constr.args {
      Some(args) => {
        let args_arr = args.to_array()
        for i, arg in args_arr {
          buf.write_string("; readonly $")
          buf.write_string(i.to_string())
          buf.write_string(": ")
          buf.write_string(generate_type(arg.ty))
        }
      }
      None => ()
    }
    buf.write_string("; }\n")
  }

  // Generate union type
  buf.write_string("export type ")
  buf.write_string(name)
  buf.write_string(type_params)
  buf.write_string(" = ")
  for i, constr in constrs_arr {
    if i > 0 {
      buf.write_string(" | ")
    }
    buf.write_string(name)
    buf.write_string("_")
    buf.write_string(constr.name.name)
    buf.write_string(type_params)
  }
  buf.write_string(";\n\n")

  // Generate constructor object
  buf.write_string("export const ")
  buf.write_string(name)
  buf.write_string(" = {\n")
  for constr in constrs_arr {
    let variant_name = constr.name.name
    match constr.args {
      Some(args) => {
        // Tuple variant - constructor function
        let args_arr = args.to_array()
        buf.write_string("  ")
        buf.write_string(variant_name)
        buf.write_string("(")
        for i, arg in args_arr {
          if i > 0 {
            buf.write_string(", ")
          }
          buf.write_string("$")
          buf.write_string(i.to_string())
          buf.write_string(": ")
          buf.write_string(generate_type(arg.ty))
        }
        buf.write_string("): ")
        buf.write_string(name)
        buf.write_string("_")
        buf.write_string(variant_name)
        buf.write_string(" { return { $tag: \"")
        buf.write_string(variant_name)
        buf.write_string("\"")
        for i, _ in args_arr {
          buf.write_string(", $")
          buf.write_string(i.to_string())
        }
        buf.write_string(" }; },\n")
      }
      None => {
        // Unit variant - constant
        buf.write_string("  ")
        buf.write_string(variant_name)
        buf.write_string(": { $tag: \"")
        buf.write_string(variant_name)
        buf.write_string("\" } as ")
        buf.write_string(name)
        buf.write_string("_")
        buf.write_string(variant_name)
        buf.write_string(",\n")
      }
    }
  }

  // Generate type guards
  buf.write_string("\n")
  for constr in constrs_arr {
    let variant_name = constr.name.name
    buf.write_string("  is")
    buf.write_string(variant_name)
    buf.write_string("(value: ")
    buf.write_string(name)
    buf.write_string("): value is ")
    buf.write_string(name)
    buf.write_string("_")
    buf.write_string(variant_name)
    buf.write_string(" { return value.$tag === \"")
    buf.write_string(variant_name)
    buf.write_string("\"; },\n")
  }

  // Generate match function
  buf.write_string("\n  match<R>(value: ")
  buf.write_string(name)
  buf.write_string(", handlers: {\n")
  for constr in constrs_arr {
    let variant_name = constr.name.name
    buf.write_string("    ")
    buf.write_string(variant_name)
    buf.write_string(": (")
    match constr.args {
      Some(args) => {
        let args_arr = args.to_array()
        for i, arg in args_arr {
          if i > 0 {
            buf.write_string(", ")
          }
          buf.write_string("$")
          buf.write_string(i.to_string())
          buf.write_string(": ")
          buf.write_string(generate_type(arg.ty))
        }
      }
      None => ()
    }
    buf.write_string(") => R;\n")
  }
  buf.write_string("  }): R {\n    switch (value.$tag) {\n")
  for constr in constrs_arr {
    let variant_name = constr.name.name
    buf.write_string("      case \"")
    buf.write_string(variant_name)
    buf.write_string("\": return handlers.")
    buf.write_string(variant_name)
    buf.write_string("(")
    match constr.args {
      Some(args) => {
        let args_arr = args.to_array()
        for i, _ in args_arr {
          if i > 0 {
            buf.write_string(", ")
          }
          buf.write_string("(value as ")
          buf.write_string(name)
          buf.write_string("_")
          buf.write_string(variant_name)
          buf.write_string(").$")
          buf.write_string(i.to_string())
        }
      }
      None => ()
    }
    buf.write_string(");\n")
  }
  buf.write_string("    }\n  },\n} as const;")
}

///|
fn generate_struct_type(
  buf : StringBuilder,
  name : String,
  type_params : String,
  fields : @list.List[@syntax.FieldDecl],
) -> Unit {
  buf.write_string("export interface ")
  buf.write_string(name)
  buf.write_string(type_params)
  buf.write_string(" {\n")
  for field in fields {
    let field_name = field.name.label
    let ts_type = generate_type(field.ty)
    let is_readonly = if field.mut_ { "" } else { "readonly " }
    buf.write_string("  ")
    buf.write_string(is_readonly)
    buf.write_string(field_name)
    buf.write_string(": ")
    buf.write_string(ts_type)
    buf.write_string(";\n")
  }
  buf.write_string("}")
}

///|
fn generate_alias_sig(alias_sig : @mbti_ast.AliasSig) -> String {
  match alias_sig {
    TypeAlias(name~, type_params~, type_~, vis~) => {
      ignore(vis)
      let buf = StringBuilder::new()
      buf.write_string("export type ")
      buf.write_string(name.name)
      buf.write_string(generate_type_params_no_constraints(type_params))
      buf.write_string(" = ")
      buf.write_string(generate_type(type_))
      buf.write_string(";")
      buf.to_string()
    }
    TraitAlias(name~, trait_name~, vis~) => {
      ignore(vis)
      let buf = StringBuilder::new()
      buf.write_string("// Trait alias: ")
      buf.write_string(name.name)
      buf.write_string(" = ")
      buf.write_string(qualified_name_to_string(trait_name))
      buf.to_string()
    }
    FnAlias(name~, type_name~, loc~) => {
      ignore(loc)
      let buf = StringBuilder::new()
      buf.write_string("// Fn alias: ")
      buf.write_string(name.name)
      buf.write_string(" = ")
      buf.write_string(qualified_name_to_string(type_name))
      buf.to_string()
    }
  }
}

///|
fn generate_trait_sig(trait_sig : @mbti_ast.TraitSig) -> String {
  let buf = StringBuilder::new()
  buf.write_string("export interface ")
  buf.write_string(trait_sig.name.name)
  buf.write_string(" {\n")
  for m in trait_sig.methods {
    let params = generate_trait_method_params(m.params)
    let (ret_type, _) = m.return_
    buf.write_string("  ")
    buf.write_string(m.name.name)
    buf.write_string("(")
    buf.write_string(params)
    buf.write_string("): ")
    buf.write_string(generate_type(ret_type))
    buf.write_string(";\n")
  }
  buf.write_string("}")
  buf.to_string()
}

///|
fn generate_const_sig(const_sig : @mbti_ast.ConstSig) -> String {
  let buf = StringBuilder::new()
  buf.write_string("export const ")
  buf.write_string(const_sig.name.name)
  buf.write_string(": ")
  buf.write_string(generate_type(const_sig.type_))
  buf.write_string(";")
  buf.to_string()
}

///|
fn generate_value_sig(value_sig : @mbti_ast.ValueSig) -> String {
  let buf = StringBuilder::new()
  buf.write_string("export const ")
  buf.write_string(value_sig.name.name)
  buf.write_string(": ")
  buf.write_string(generate_type(value_sig.type_))
  buf.write_string(";")
  buf.to_string()
}

///|
fn generate_type(ty : @syntax.Type) -> String {
  match ty {
    Any(_) => "any"
    Arrow(args~, res~, err~, is_async~, loc~) => {
      ignore(err)
      ignore(loc)
      let buf = StringBuilder::new()
      if is_async {
        buf.write_string("Promise<")
        buf.write_string(generate_type(res))
        buf.write_string(">")
      } else {
        buf.write_string("(")
        let args_arr = args.to_array()
        for i, arg in args_arr {
          if i > 0 {
            buf.write_string(", ")
          }
          buf.write_string("arg")
          buf.write_string(i.to_string())
          buf.write_string(": ")
          buf.write_string(generate_type(arg))
        }
        buf.write_string(") => ")
        buf.write_string(generate_type(res))
      }
      buf.to_string()
    }
    Tuple(tys~, loc~) => {
      ignore(loc)
      let buf = StringBuilder::new()
      buf.write_string("[")
      let tys_arr = tys.to_array()
      for i, t in tys_arr {
        if i > 0 {
          buf.write_string(", ")
        }
        buf.write_string(generate_type(t))
      }
      buf.write_string("]")
      buf.to_string()
    }
    Name(constr_id~, tys~, loc~) => {
      ignore(loc)
      let name = long_ident_to_string(constr_id.id)
      let mapped = map_moonbit_type(name)
      let tys_arr = tys.to_array()
      if tys_arr.length() == 0 {
        mapped
      } else {
        let buf = StringBuilder::new()
        buf.write_string(mapped)
        buf.write_string("<")
        for i, t in tys_arr {
          if i > 0 {
            buf.write_string(", ")
          }
          buf.write_string(generate_type(t))
        }
        buf.write_string(">")
        buf.to_string()
      }
    }
    Option(ty~, loc~, question_loc~) => {
      ignore(loc)
      ignore(question_loc)
      let buf = StringBuilder::new()
      buf.write_string(generate_type(ty))
      buf.write_string(" | undefined")
      buf.to_string()
    }
    Object(constr_id) => long_ident_to_string(constr_id.id)
  }
}

///|
fn map_moonbit_type(name : String) -> String {
  match name {
    "String" => "string"
    "Int" | "UInt" | "Float" | "Double" | "Int64" | "UInt64" => "number"
    "Bool" => "boolean"
    "Unit" => "void"
    "Bytes" => "Uint8Array"
    "BigInt" => "bigint"
    "Array" => "Array"
    "Map" => "Map"
    "Json" => "any"
    _ => name
  }
}

///|
fn generate_params(params : @list.List[@mbti_ast.Parameter]) -> String {
  let buf = StringBuilder::new()
  let params_arr = params.to_array()
  let mut pos_index = 0
  for i, param in params_arr {
    if i > 0 {
      buf.write_string(", ")
    }
    match param {
      Positional(ty) => {
        buf.write_string("arg")
        buf.write_string(pos_index.to_string())
        buf.write_string(": ")
        buf.write_string(generate_type(ty))
        pos_index += 1
      }
      Labelled(label, ty) => {
        buf.write_string(label.name)
        buf.write_string(": ")
        buf.write_string(generate_type(ty))
      }
      Autofill(label, ty) => {
        buf.write_string(label.name)
        buf.write_string("?: ")
        buf.write_string(generate_type(ty))
      }
      OptionalDefault(label, ty) => {
        buf.write_string(label.name)
        buf.write_string("?: ")
        buf.write_string(generate_type(ty))
      }
      OptionalOption(label, ty) => {
        buf.write_string(label.name)
        buf.write_string("?: ")
        buf.write_string(generate_type(ty))
      }
    }
  }
  buf.to_string()
}

///|
fn generate_trait_method_params(
  params : @list.List[@mbti_ast.TraitMethodParameter],
) -> String {
  let buf = StringBuilder::new()
  let params_arr = params.to_array()
  let mut pos_index = 0
  for i, param in params_arr {
    if i > 0 {
      buf.write_string(", ")
    }
    match param {
      Positional(ty) => {
        buf.write_string("arg")
        buf.write_string(pos_index.to_string())
        buf.write_string(": ")
        buf.write_string(generate_type(ty))
        pos_index += 1
      }
      Labelled(label, ty) => {
        buf.write_string(label.name)
        buf.write_string(": ")
        buf.write_string(generate_type(ty))
      }
    }
  }
  buf.to_string()
}

///|
fn generate_type_params(
  params : @list.List[@mbti_ast.TypeParamWithConstraints],
) -> String {
  let params_arr = params.to_array()
  if params_arr.length() == 0 {
    return ""
  }
  let buf = StringBuilder::new()
  buf.write_string("<")
  for i, param in params_arr {
    if i > 0 {
      buf.write_string(", ")
    }
    buf.write_string(param.name.name)
  }
  buf.write_string(">")
  buf.to_string()
}

///|
fn generate_type_params_no_constraints(
  params : @list.List[@mbti_ast.TypeParamNoConstraints],
) -> String {
  let params_arr = params.to_array()
  if params_arr.length() == 0 {
    return ""
  }
  let buf = StringBuilder::new()
  buf.write_string("<")
  for i, param in params_arr {
    if i > 0 {
      buf.write_string(", ")
    }
    match param {
      Name(name) => buf.write_string(name.name)
      Underscore(_) => buf.write_string("_")
    }
  }
  buf.write_string(">")
  buf.to_string()
}

///|
fn long_ident_to_string(id : @syntax.LongIdent) -> String {
  match id {
    Ident(name~) => name
    Dot(pkg~, id~) => "\{pkg}.\{id}"
  }
}

///|
fn qualified_name_to_string(qn : @mbti_ast.QualifiedName) -> String {
  qualified_ident_to_string(qn.name)
}

///|
fn qualified_ident_to_string(qi : @mbti_ast.QualifiedIdent) -> String {
  match qi {
    Ident(name~) => name
    Dot(pkg~, id~) => "\{pkg}.\{id}"
  }
}

///|
fn to_camel_case(s : String) -> String {
  // Convert snake_case to camelCase
  let buf = StringBuilder::new()
  let mut next_upper = false
  for c in s {
    if c == '_' {
      next_upper = true
    } else if next_upper {
      buf.write_char(char_to_upper(c))
      next_upper = false
    } else {
      buf.write_char(c)
    }
  }
  buf.to_string()
}

///|
fn char_to_upper(c : Char) -> Char {
  let code = c.to_int()
  if code >= 97 && code <= 122 {
    // 'a' to 'z'
    (code - 32).unsafe_to_char()
  } else {
    c
  }
}
