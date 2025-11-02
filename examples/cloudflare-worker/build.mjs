import path from "node:path";
import fs from "node:fs";

// Fix seed
const generated_code_path = path.join(import.meta.dirname, "..", "..", "target", "js", "release", "build", "examples", "cfw", "cfw.js");
const patched = fs.readFileSync(generated_code_path, "utf-8").replace(
  "moonbitlang$core$builtin$$random_seed()",
  "123456789"
);

fs.writeFileSync(
  path.join(import.meta.dirname, "__patched.js"),
  patched
);