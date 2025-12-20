// Lexer for .mbti files

export type TokenType =
  | "PACKAGE"
  | "IMPORT"
  | "PUB"
  | "PUB_ALL" // pub(all)
  | "PRIV"
  | "FN"
  | "ASYNC"
  | "TYPE"
  | "STRUCT"
  | "ENUM"
  | "SUBERROR"
  | "IMPL"
  | "FOR"
  | "MUT"
  | "NORAISE"
  | "RAISE"
  | "SELF"
  | "IDENT"
  | "STRING"
  | "LPAREN"
  | "RPAREN"
  | "LBRACE"
  | "RBRACE"
  | "LBRACKET"
  | "RBRACKET"
  | "COLON"
  | "DOUBLE_COLON"
  | "COMMA"
  | "ARROW"
  | "QUESTION"
  | "HASH"
  | "NEWLINE"
  | "COMMENT"
  | "EOF";

export interface Token {
  type: TokenType;
  value: string;
  line: number;
  column: number;
}

const KEYWORDS: Record<string, TokenType> = {
  package: "PACKAGE",
  import: "IMPORT",
  pub: "PUB",
  priv: "PRIV",
  fn: "FN",
  async: "ASYNC",
  type: "TYPE",
  struct: "STRUCT",
  enum: "ENUM",
  suberror: "SUBERROR",
  impl: "IMPL",
  for: "FOR",
  mut: "MUT",
  noraise: "NORAISE",
  raise: "RAISE",
  Self: "SELF",
};

export class Lexer {
  private input: string;
  private pos: number = 0;
  private line: number = 1;
  private column: number = 1;

  constructor(input: string) {
    this.input = input;
  }

  private peek(offset = 0): string {
    return this.input[this.pos + offset] ?? "";
  }

  private advance(): string {
    const ch = this.input[this.pos];
    this.pos++;
    if (ch === "\n") {
      this.line++;
      this.column = 1;
    } else {
      this.column++;
    }
    return ch;
  }

  private skipWhitespace(): void {
    while (this.pos < this.input.length) {
      const ch = this.peek();
      if (ch === " " || ch === "\t" || ch === "\r") {
        this.advance();
      } else {
        break;
      }
    }
  }

  private readString(): string {
    let result = "";
    this.advance(); // skip opening quote
    while (this.pos < this.input.length) {
      const ch = this.peek();
      if (ch === '"') {
        this.advance();
        break;
      }
      if (ch === "\\") {
        this.advance();
        const escaped = this.advance();
        result += escaped;
      } else {
        result += this.advance();
      }
    }
    return result;
  }

  private readIdent(): string {
    let result = "";
    while (this.pos < this.input.length) {
      const ch = this.peek();
      if (/[a-zA-Z0-9_]/.test(ch)) {
        result += this.advance();
      } else {
        break;
      }
    }
    return result;
  }

  private readComment(): string {
    let result = "";
    // Skip //
    this.advance();
    this.advance();
    while (this.pos < this.input.length) {
      const ch = this.peek();
      if (ch === "\n") {
        break;
      }
      result += this.advance();
    }
    return result.trim();
  }

  tokenize(): Token[] {
    const tokens: Token[] = [];

    while (this.pos < this.input.length) {
      this.skipWhitespace();

      if (this.pos >= this.input.length) break;

      const line = this.line;
      const column = this.column;
      const ch = this.peek();

      // Check for pub(all)
      if (
        ch === "p" &&
        this.input.slice(this.pos, this.pos + 8) === "pub(all)"
      ) {
        for (let i = 0; i < 8; i++) this.advance();
        tokens.push({ type: "PUB_ALL", value: "pub(all)", line, column });
        continue;
      }

      // Newline
      if (ch === "\n") {
        this.advance();
        tokens.push({ type: "NEWLINE", value: "\n", line, column });
        continue;
      }

      // Comment
      if (ch === "/" && this.peek(1) === "/") {
        const comment = this.readComment();
        tokens.push({ type: "COMMENT", value: comment, line, column });
        continue;
      }

      // String
      if (ch === '"') {
        const str = this.readString();
        tokens.push({ type: "STRING", value: str, line, column });
        continue;
      }

      // Arrow
      if (ch === "-" && this.peek(1) === ">") {
        this.advance();
        this.advance();
        tokens.push({ type: "ARROW", value: "->", line, column });
        continue;
      }

      // Double colon
      if (ch === ":" && this.peek(1) === ":") {
        this.advance();
        this.advance();
        tokens.push({ type: "DOUBLE_COLON", value: "::", line, column });
        continue;
      }

      // Single character tokens
      const singleCharTokens: Record<string, TokenType> = {
        "(": "LPAREN",
        ")": "RPAREN",
        "{": "LBRACE",
        "}": "RBRACE",
        "[": "LBRACKET",
        "]": "RBRACKET",
        ":": "COLON",
        ",": "COMMA",
        "?": "QUESTION",
        "#": "HASH",
      };

      if (singleCharTokens[ch]) {
        this.advance();
        tokens.push({ type: singleCharTokens[ch], value: ch, line, column });
        continue;
      }

      // Identifier or keyword (including @package.Type format)
      if (/[a-zA-Z_@]/.test(ch)) {
        let ident = "";
        if (ch === "@") {
          ident += this.advance();
          // Read package path (e.g., @core.Any)
          while (this.pos < this.input.length) {
            const c = this.peek();
            if (/[a-zA-Z0-9_.]/.test(c)) {
              ident += this.advance();
            } else {
              break;
            }
          }
          tokens.push({ type: "IDENT", value: ident, line, column });
          continue;
        }
        ident += this.readIdent();
        const keyword = KEYWORDS[ident];
        if (keyword) {
          tokens.push({ type: keyword, value: ident, line, column });
        } else {
          tokens.push({ type: "IDENT", value: ident, line, column });
        }
        continue;
      }

      // Skip unknown characters
      this.advance();
    }

    tokens.push({ type: "EOF", value: "", line: this.line, column: this.column });
    return tokens;
  }
}
