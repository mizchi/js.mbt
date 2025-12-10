///|
/// Tests for minimatch bindings

///|
test "minimatch basic matching" {
  inspect(minimatch("bar.foo", "*.foo"), content="true")
  inspect(minimatch("bar.foo", "*.bar"), content="false")
  inspect(minimatch("bar.foo", "bar.*"), content="true")
  inspect(minimatch("foo/bar.js", "**/*.js"), content="true")
}

///|
test "minimatch with brace expansion" {
  inspect(minimatch("foo.js", "*.{js,ts}"), content="true")
  inspect(minimatch("foo.ts", "*.{js,ts}"), content="true")
  inspect(minimatch("foo.css", "*.{js,ts}"), content="false")
}

///|
test "minimatch with dot option" {
  // Without dot option, dotfiles don't match
  inspect(minimatch(".gitignore", "*"), content="false")
  // With dot option, dotfiles match
  let opts = MinimatchOptions::{ ..MinimatchOptions::default(), dot: true }
  inspect(minimatch_with_options(".gitignore", "*", opts), content="true")
}

///|
test "minimatch with matchBase option" {
  // Without matchBase, pattern must match full path
  inspect(minimatch("/foo/bar/baz.js", "*.js"), content="false")
  // With matchBase, pattern matches basename
  let opts = MinimatchOptions::{
    ..MinimatchOptions::default(),
    match_base: true,
  }
  inspect(
    minimatch_with_options("/foo/bar/baz.js", "*.js", opts),
    content="true",
  )
}

///|
test "minimatch with nocase option" {
  inspect(minimatch("FOO.JS", "*.js"), content="false")
  let opts = MinimatchOptions::{ ..MinimatchOptions::default(), nocase: true }
  inspect(minimatch_with_options("FOO.JS", "*.js", opts), content="true")
}

///|
test "match_list filters array" {
  let files = ["foo.js", "bar.ts", "baz.js", "qux.css"]
  let result = match_list(files, "*.js")
  inspect(result.length(), content="2")
  inspect(result[0], content="foo.js")
  inspect(result[1], content="baz.js")
}

///|
test "escape and unescape" {
  let pattern = "foo[bar]*.js"
  let escaped = escape(pattern)
  inspect(escaped.contains("\\[") || escaped.contains("[[]"), content="true")
  // Unescape should restore it
  let unescaped = unescape(escaped)
  inspect(unescaped, content="foo[bar]*.js")
}

///|
test "make_re creates regex" {
  let re = make_re("*.js")
  inspect(re is Some(_), content="true")
}

///|
test "Minimatch class" {
  let mm = Minimatch::new("*.js")
  inspect(mm.pattern(), content="*.js")
  inspect(mm.match_("foo.js"), content="true")
  inspect(mm.match_("foo.ts"), content="false")
  inspect(mm.has_magic(), content="true")
}

///|
test "Minimatch without magic" {
  let mm = Minimatch::new("foo.js")
  inspect(mm.has_magic(), content="false")
}

///|
test "Minimatch negate pattern" {
  let mm = Minimatch::new("!*.js")
  inspect(mm.negate(), content="true")
}

///|
test "Minimatch comment pattern" {
  let mm = Minimatch::new("#comment")
  inspect(mm.comment(), content="true")
}

///|
test "has_magic static function" {
  inspect(has_magic("*.js"), content="true")
  inspect(has_magic("foo.js"), content="false")
  inspect(has_magic("**/*.ts"), content="true")
  inspect(has_magic("foo/bar.js"), content="false")
}

///|
test "globstar matching" {
  inspect(minimatch("a/b/c/d.js", "**/*.js"), content="true")
  inspect(minimatch("d.js", "**/*.js"), content="true")
  inspect(minimatch("a/b/c/d.ts", "**/*.js"), content="false")
}

///|
test "negation pattern" {
  // Without flipNegate: !*.ts matches foo.js (it's negated, so "not matching *.ts" means true)
  inspect(minimatch("foo.js", "!*.ts"), content="true")
  // With flipNegate: the result is flipped
  let opts = MinimatchOptions::{
    ..MinimatchOptions::default(),
    flip_negate: true,
  }
  inspect(minimatch_with_options("foo.js", "!*.ts", opts), content="false")
}
