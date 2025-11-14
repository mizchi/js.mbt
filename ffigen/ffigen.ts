/// WIP
import ts from "typescript";
const implTemplate = (name: string) => `
impl Js for ${name} with to_js(self) {
  self |> unsafe_cast
}
`;

// convert to Moonbit structs and functions
function toMoonbitCode(node: ts.Node, scope: string, depth = 0): string {
  // const indent = ' '.repeat(depth * 2);
  if (ts.isSourceFile(node)) {
    return node.statements
      .map((stmt) => toMoonbitCode(stmt, scope, depth + 1))
      .join("\n");
  }
  if (ts.isFunctionTypeNode(node)) {
    let out: string = "(";
    for (const params of node.parameters) {
      if (params.type) {
        out += toMoonbitCode(params.type, scope, depth + 1);
      }
    }
    out += ") -> " + toMoonbitCode(node.type, scope, depth + 1);
    return out;
  }

  switch (node.kind) {
    case ts.SyntaxKind.NumberKeyword:
      return "Double";
    case ts.SyntaxKind.StringKeyword:
      return "String";
    case ts.SyntaxKind.BooleanKeyword:
      return "Bool";
    // default:
    //   return node.getText(); // Assume it's a user-defined type
  }
  if (ts.isTypeReferenceNode(node)) {
    return node.typeName.getText();
  }

  if (ts.isIdentifier(node)) {
    return node.text;
  }

  if (ts.isPropertySignature(node)) {
    const paramName = (node.name as ts.Identifier).text;
    const paramType = node.type
      ? toMoonbitCode(node.type, scope, depth + 1)
      : "Any";
    const isOptional = !!node.questionToken;
    return `${paramName}: ${paramType}${isOptional ? "?" : ""}`;
  }
  // class => struct
  if (ts.isClassDeclaration(node)) {
    let out = "";
    const className = node.name?.text || "AnonymousClass";
    out += `///|\nstruct ${className} {\n`;
    let constructorNode: ts.ConstructorDeclaration | null = null;
    const methods: ts.MethodDeclaration[] = [];
    for (const member of node.members) {
      if (ts.isConstructorDeclaration(member)) {
        constructorNode = member;
      } else if (ts.isMethodDeclaration(member) && member.type && member.name) {
        methods.push(member);
      } else if (
        ts.isPropertyDeclaration(member) &&
        member.type &&
        member.name
      ) {
        const propName = (member.name as ts.Identifier).text;
        const propType = toMoonbitCode(member.type, scope, depth + 1);
        out += `  ${propName}: ${propType}\n`;
      }
    }
    out += `}\n`;
    for (const member of methods) {
      const methodName = (member.name as ts.Identifier).text;
      const returnType = member.type
        ? toMoonbitCode(member.type, scope, depth + 1)
        : "Val";
      const params = member.parameters
        .map((param) => {
          const paramName = (param.name as ts.Identifier).text;
          const paramType = param.type
            ? toMoonbitCode(param.type, scope, depth + 1)
            : "Any";
          return `${paramName}: ${paramType}`;
        })
        .join(", ");
      const keys = member.parameters
        .map((param) => {
          // return
          const paramName = (param.name as ts.Identifier).text;
          return `${paramName}`;
        })
        .join(", ");
      out += `fn ${className}::${methodName}(self: Self, ${params}) -> ${returnType} {\n`;
      out += `  self.to_js().call_method("${methodName}", [${keys}]) |> unsafe_cast`;
      out += `\n}\n`;
    }

    out += implTemplate(node.name?.text || "AnonymousClass");
    // Constructor::new
    if (constructorNode) {
      const params = constructorNode.parameters
        .map((param) => {
          const paramName = (param.name as ts.Identifier).text;
          const paramType = param.type
            ? toMoonbitCode(param.type, scope, depth + 1)
            : "Any";
          return `${paramName}: ${paramType}`;
        })
        .join(", ");
      const keys = constructorNode.parameters
        .map((param) => {
          const paramName = (param.name as ts.Identifier).text;
          return `${paramName}`;
        })
        .join(", ");
      out += `extern "js" fn ${className}::new(${params}) -> ${node.name?.text || "AnonymousClass"} =\n`;
      out += `  #|(${keys}) => new ${scope}${node.name?.text || "AnonymousClass"}(${keys})\n`;
      out += `\n`;
    }
    return out;
  } else if (ts.isTypeAliasDeclaration(node)) {
    // type T = {...}
    let typeName = node.name.text;
    if (ts.isTypeLiteralNode(node.type)) {
      let out = "";
      out += `///|\nstruct ${typeName} {\n`;
      for (const member of node.type.members) {
        if (ts.isPropertySignature(member) && member.type && member.name) {
          out += "  " + toMoonbitCode(member, scope, depth + 1) + "\n";
        }
      }
      out += `}\n`;
      out += implTemplate(node.name.text);
      return out;
    } else {
      console.log("fallback", ts.SyntaxKind[node.type.kind]);
      return `///|\n#external\ntype ${node.name.text}\n`;
    }
  } else if (ts.isInterfaceDeclaration(node)) {
    // interface => struct
    let out = "";
    out += `///|\nstruct ${node.name.text} {\n`;
    for (const member of node.members) {
      if (ts.isPropertySignature(member) && member.type && member.name) {
        out += "  " + toMoonbitCode(member, scope, depth + 1) + "\n";
      }
    }
    out += `}\n`;
    out += implTemplate(node.name.text);
    return out;
  } else if (ts.isFunctionDeclaration(node)) {
    let out: string = "";
    const funcName = node.name?.text || "anonymous";
    const params = node.parameters
      .map((param) => {
        const paramName = (param.name as ts.Identifier).text;
        const paramType = param.type
          ? toMoonbitCode(param.type, scope, depth + 1)
          : "Any";
        return `${paramName}: ${paramType}`;
      })
      .join(", ");
    const keys = node.parameters
      .map((param) => {
        const paramName = (param.name as ts.Identifier).text;
        return `${paramName}`;
      })
      .join(", ");

    const returnType = node.type
      ? toMoonbitCode(node.type, scope, depth + 1)
      : "Unit";
    out += `extern "js" fn ${funcName}(${params}) -> ${returnType} =\n`;
    out += `  #|(${keys}) => ${scope}${funcName}(${keys})\n`;
    out += `\n`;
    return out;
  } else if (ts.isVariableStatement(node)) {
    let out = "";
    for (const decl of node.declarationList.declarations) {
      if (ts.isVariableDeclaration(decl) && decl.type && decl.name) {
        const varName = (decl.name as ts.Identifier).text;
        out += `#external\npub type ${varName}\n\n`;
        if (decl.type && ts.isTypeLiteralNode(decl.type)) {
          for (const member of decl.type.members) {
            if (
              ts.isMethodSignature(member) &&
              member.name &&
              member.name.getText() === "new"
            ) {
              const methodParams = member.parameters
                .map((param) => {
                  const paramName = (param.name as ts.Identifier).text;
                  const paramType = param.type
                    ? toMoonbitCode(param.type, scope, depth + 1)
                    : "Any";
                  return `${paramName}: ${paramType}`;
                })
                .join(", ");
              const keys = member.parameters
                .map((param) => {
                  const paramName = (param.name as ts.Identifier).text;
                  return `${paramName}`;
                })
                .join(", ");
              out += `extern "js" fn ${varName}::new(${methodParams}) -> ${varName} =\n`;
              out += `  #|(${keys}) => new ${scope}${varName}(${keys})\n`;
              out += `\n`;
              return out;
            }
            if (ts.isConstructSignatureDeclaration(member)) {
              // Handle construct signature if needed
              const methodParams = member.parameters
                .map((param) => {
                  const paramName = (param.name as ts.Identifier).text;
                  const paramType = param.type
                    ? toMoonbitCode(param.type, scope, depth + 1)
                    : "Any";
                  return `${paramName}: ${paramType}`;
                })
                .join(", ");
              const keys = member.parameters
                .map((param) => {
                  const paramName = (param.name as ts.Identifier).text;
                  return `${paramName}`;
                })
                .join(", ");
              out += `extern "js" fn ${varName}::new(${methodParams}) -> ${varName} =\n`;
              out += `  #|(${keys}) => new ${scope}${varName}(${keys})\n`;
              out += `\n`;
              return out;
            }
            // console.log(member);
          }
        }
      }
    }
    return out;
  } else {
    return `// Unknown node : ${ts.SyntaxKind[node.kind]}\n`;
  }
  // ts.forEachChild(node, child => parseSourceFile(child, depth + 1));
}

const content = `
export interface Point {
  x: number;
  y: number;
}

export function distance(p1: Point, p2: Point): number;

export type Value = {
  value: string;
  opt?: number;
  f: (x: number) => boolean;
}

export class MyClass {
  value: string;
  constructor(name: string);
  greet(): string;
}

declare var XSLTProcessor: {
  prototype: XSLTProcessor;
  new(): XSLTProcessor;
};
`;

const parsed = ts.createSourceFile(
  "testfile.d.ts",
  content,
  ts.ScriptTarget.Latest,
  /*setParentNodes */ true,
  ts.ScriptKind.TS,
);

{
  // const moduleScope = 'require("test_module").';
  const isModule = content.includes("export ");
  const moduleScope = isModule ? 'require("test_module").' : "";
  const out = toMoonbitCode(parsed, moduleScope);
  console.log(out);
}
