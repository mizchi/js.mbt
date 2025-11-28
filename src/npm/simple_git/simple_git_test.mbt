///|
/// simple-git bindings tests

///|
test "simpleGit constructor" {
  let git = @simple_git.simpleGit()
  inspect(git.to_any() |> @js.is_nullish |> not, content="true")
}

///|
test "simpleGit with base_dir" {
  let git = @simple_git.simpleGit(base_dir=".")
  inspect(git.to_any() |> @js.is_nullish |> not, content="true")
}

///|
async test "git status" {
  let git = @simple_git.simpleGit(base_dir=".")
  let status = git.status()
  // Should have a current branch
  inspect(status.current().length() > 0, content="true")
}

///|
async test "git status properties" {
  let git = @simple_git.simpleGit(base_dir=".")
  let status = git.status()
  // isClean returns boolean
  let _ = status.isClean()
  // ahead/behind return integers
  let _ = status.ahead()
  let _ = status.behind()
  // arrays
  let _ = status.modified()
  let _ = status.staged()
  let _ = status.notAdded()
  ()
}

///|
async test "git log" {
  let git = @simple_git.simpleGit(base_dir=".")
  let log = git.log(max_count=5)
  // Should have at least one commit
  inspect(log.total() > 0, content="true")
}

///|
async test "git log latest" {
  let git = @simple_git.simpleGit(base_dir=".")
  let log = git.log(max_count=1)
  let latest = log.latest()
  inspect(latest |> @js.is_nullish |> not, content="true")
}

///|
async test "git branch" {
  let git = @simple_git.simpleGit(base_dir=".")
  let branch = git.branch()
  // Should have current branch name
  inspect(branch.current().length() > 0, content="true")
  // Should have at least one branch
  inspect(branch.all().length() > 0, content="true")
}

///|
async test "git branchLocal" {
  let git = @simple_git.simpleGit(base_dir=".")
  let branch = git.branchLocal()
  inspect(branch.current().length() > 0, content="true")
}

///|
async test "git diff" {
  let git = @simple_git.simpleGit(base_dir=".")
  // Just check it doesn't throw
  let _ = git.diff()
  ()
}

///|
async test "git diffSummary" {
  let git = @simple_git.simpleGit(base_dir=".")
  let diff = git.diffSummary()
  // properties should be accessible
  let _ = diff.insertions()
  let _ = diff.deletions()
  let _ = diff.changed()
  ()
}

///|
async test "git getRemotes" {
  let git = @simple_git.simpleGit(base_dir=".")
  let remotes = git.getRemotes()
  // Should return array (may be empty if no remotes)
  inspect(remotes |> @js.is_nullish |> not, content="true")
}

///|
async test "git tags" {
  let git = @simple_git.simpleGit(base_dir=".")
  let tags = git.tags()
  // Should return object (may have no tags)
  inspect(tags |> @js.is_nullish |> not, content="true")
}

///|
async test "git raw" {
  let git = @simple_git.simpleGit(base_dir=".")
  let result = git.raw(["rev-parse", "--abbrev-ref", "HEAD"])
  // Should return current branch name
  inspect(result.length() > 0, content="true")
}

///|
async test "git revparse HEAD" {
  let git = @simple_git.simpleGit(base_dir=".")
  let sha = git.getHeadSha()
  // SHA should be 40 characters
  inspect(sha.length() >= 40, content="true")
}

///|
async test "git show" {
  let git = @simple_git.simpleGit(base_dir=".")
  let show = git.show()
  // Should show commit info
  inspect(show.length() > 0, content="true")
}
