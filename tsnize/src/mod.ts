// tsnize - MoonBit .mbti to TypeScript .d.ts generator

export { Lexer, type Token, type TokenType } from "./lexer.ts";
export { Parser } from "./parser.ts";
export { Generator, type GeneratorOptions } from "./generator.ts";
export {
  generateEnumConverter,
  generateEnumModule,
  type EnumConverterOptions,
} from "./enum-converter.ts";
export type * from "./types.ts";

import { Lexer } from "./lexer.ts";
import { Parser } from "./parser.ts";
import { Generator, type GeneratorOptions } from "./generator.ts";
import type { MbtiFile } from "./types.ts";

/**
 * Parse .mbti content into an AST
 */
export function parse(content: string): MbtiFile {
  const lexer = new Lexer(content);
  const tokens = lexer.tokenize();
  const parser = new Parser(tokens);
  return parser.parse();
}

/**
 * Generate TypeScript .d.ts from .mbti content
 */
export function generate(
  content: string,
  options?: Partial<GeneratorOptions>
): string {
  const ast = parse(content);
  const generator = new Generator(options);
  return generator.generate(ast);
}

/**
 * Generate TypeScript .d.ts from parsed MbtiFile
 */
export function generateFromAst(
  ast: MbtiFile,
  options?: Partial<GeneratorOptions>
): string {
  const generator = new Generator(options);
  return generator.generate(ast);
}
