///|
/// simple-git bindings for MoonBit
/// https://github.com/steveukx/git-js
///
/// A lightweight interface for running git commands.

///| Types

///|
/// SimpleGit instance
#external
pub type SimpleGit

///|
pub fn SimpleGit::as_any(self : SimpleGit) -> @core.Any = "%identity"

///|
/// Git status result
///
/// Contains information about the working directory status:
/// - `current`: Current branch name
/// - `tracking`: Tracking branch name
/// - `not_added`: Untracked files
/// - `modified`: Modified files
/// - `staged`: Staged files
/// - `deleted`: Deleted files
/// - `created`: Created files
/// - `conflicted`: Conflicted files
/// - `ahead`: Commits ahead of tracking branch
/// - `behind`: Commits behind tracking branch
pub(all) struct StatusResult {
  current : String
  tracking : String
  not_added : Array[String]
  modified : Array[String]
  staged : Array[String]
  deleted : Array[String]
  created : Array[String]
  conflicted : Array[String]
  ahead : Int
  behind : Int
}

///|
pub fn StatusResult::as_any(self : StatusResult) -> @core.Any = "%identity"

///|
/// Git log result
#external
pub type LogResult

///|
pub fn LogResult::as_any(self : LogResult) -> @core.Any = "%identity"

///|
/// Git branch summary
#external
pub type BranchSummary

///|
pub fn BranchSummary::as_any(self : BranchSummary) -> @core.Any = "%identity"

///|
/// Git diff result
#external
pub type DiffResult

///|
pub fn DiffResult::as_any(self : DiffResult) -> @core.Any = "%identity"

///|
/// Git fetch result
#external
pub type FetchResult

///|
pub fn FetchResult::as_any(self : FetchResult) -> @core.Any = "%identity"

///|
/// Git pull result
#external
pub type PullResult

///|
pub fn PullResult::as_any(self : PullResult) -> @core.Any = "%identity"

///|
/// Commit result
#external
pub type CommitResult

///|
pub fn CommitResult::as_any(self : CommitResult) -> @core.Any = "%identity"

///| Constructor FFI

///|
extern "js" fn ffi_simple_git() -> SimpleGit =
  #| () => require('simple-git')()

///|
extern "js" fn ffi_simple_git_with_path(base_dir : String) -> SimpleGit =
  #| (base_dir) => require('simple-git')(base_dir)

///|
extern "js" fn ffi_simple_git_with_options(options : @core.Any) -> SimpleGit =
  #| (options) => require('simple-git')(options)

///| Constructor

///|
/// Create a SimpleGit instance
///
/// # Options
/// - `base_dir`: Base directory for git operations
/// - `binary`: Path to git binary (default: "git")
/// - `maxConcurrentProcesses`: Maximum number of concurrent git processes
/// - `trimmed`: Remove trailing whitespace from output
///
/// @example
/// ```moonbit
/// let git = @simple_git.simpleGit(base_dir="/path/to/repo")
/// ```
pub fn simpleGit(
  base_dir? : String,
  binary? : String,
  maxConcurrentProcesses? : Int,
  trimmed? : Bool,
) -> SimpleGit {
  if base_dir is None &&
    binary is None &&
    maxConcurrentProcesses is None &&
    trimmed is None {
    return ffi_simple_git()
  }
  if base_dir is Some(dir) &&
    binary is None &&
    maxConcurrentProcesses is None &&
    trimmed is None {
    return ffi_simple_git_with_path(dir)
  }
  let options = @core.new_object()
  if base_dir is Some(v) {
    options["baseDir"] = @core.any(v)
  }
  if binary is Some(v) {
    options["binary"] = @core.any(v)
  }
  if maxConcurrentProcesses is Some(v) {
    options["maxConcurrentProcesses"] = @core.any(v)
  }
  if trimmed is Some(v) {
    options["trimmed"] = @core.any(v)
  }
  ffi_simple_git_with_options(options)
}

///| Init/Clone FFI

///|
extern "js" fn ffi_init(git : SimpleGit, bare : Bool) -> @core.Promise[Unit] =
  #| (git, bare) => git.init(bare)

///|
extern "js" fn ffi_clone(
  git : SimpleGit,
  repo_path : String,
  local_path : String,
) -> @core.Promise[String] =
  #| (git, repo_path, local_path) => git.clone(repo_path, local_path)

///|
extern "js" fn ffi_clone_with_options(
  git : SimpleGit,
  repo_path : String,
  local_path : String,
  options : @core.Any,
) -> @core.Promise[String] =
  #| (git, repo_path, local_path, options) => git.clone(repo_path, local_path, options)

///| Init/Clone Methods

///|
/// Initialize a new repository
pub async fn SimpleGit::init(self : SimpleGit, bare? : Bool = false) -> Unit {
  ffi_init(self, bare).wait()
}

///|
/// Clone a repository
pub async fn SimpleGit::clone(
  self : SimpleGit,
  repo_path : String,
  local_path : String,
  branch? : String,
  depth? : Int,
) -> String {
  if branch is None && depth is None {
    ffi_clone(self, repo_path, local_path).wait()
  } else {
    let options : Array[String] = []
    if branch is Some(b) {
      options.push("--branch")
      options.push(b)
    }
    if depth is Some(d) {
      options.push("--depth")
      options.push(d.to_string())
    }
    ffi_clone_with_options(self, repo_path, local_path, @core.any(options)).wait()
  }
}

///| Add/Commit FFI

///|
extern "js" fn ffi_add(
  git : SimpleGit,
  files : @core.Any,
) -> @core.Promise[Unit] =
  #| (git, files) => git.add(files)

///|
extern "js" fn ffi_commit(
  git : SimpleGit,
  message : String,
  files : @core.Any,
  options : @core.Any,
) -> @core.Promise[CommitResult] =
  #| (git, message, files, options) => git.commit(message, files, options)

///|
extern "js" fn ffi_commit_simple(
  git : SimpleGit,
  message : String,
) -> @core.Promise[CommitResult] =
  #| (git, message) => git.commit(message)

///| Add/Commit Methods

///|
/// Add files to staging area
pub async fn SimpleGit::add(self : SimpleGit, files : Array[String]) -> Unit {
  ffi_add(self, @core.any(files)).wait()
}

///|
/// Add single file to staging area
pub async fn SimpleGit::addFile(self : SimpleGit, file : String) -> Unit {
  ffi_add(self, @core.any(file)).wait()
}

///|
/// Add all files to staging area
pub async fn SimpleGit::addAll(self : SimpleGit) -> Unit {
  ffi_add(self, @core.any(".")).wait()
}

///|
/// Commit staged changes
///
/// # Parameters
/// - `message`: Commit message
/// - `files`: Optional list of files to commit
/// - `author`: Optional author override (format: "Name <email>")
///
/// @example
/// ```moonbit
/// let result = git.commit("feat: add new feature").wait()
///
/// let result = git
///   .commit("fix: bug", files=["file.txt"], author="John <john@example.com>")
///   .wait()
/// ```
pub async fn SimpleGit::commit(
  self : SimpleGit,
  message : String,
  files? : Array[String],
  author? : String,
) -> CommitResult {
  if files is None && author is None {
    ffi_commit_simple(self, message).wait()
  } else {
    let file_arr : @core.Any = match files {
      Some(f) => @core.any(f)
      None => {
        let empty : Array[String] = []
        @core.any(empty)
      }
    }
    let opts = @core.new_object()
    if author is Some(a) {
      opts["--author"] = @core.any(a)
    }
    ffi_commit(self, message, file_arr, opts).wait()
  }
}

///| Push/Pull/Fetch FFI

///|
extern "js" fn ffi_push(
  git : SimpleGit,
  remote : String,
  branch : String,
) -> @core.Promise[Unit] =
  #| (git, remote, branch) => git.push(remote, branch)

///|
extern "js" fn ffi_push_with_options(
  git : SimpleGit,
  remote : String,
  branch : String,
  options : @core.Any,
) -> @core.Promise[Unit] =
  #| (git, remote, branch, options) => git.push(remote, branch, options)

///|
extern "js" fn ffi_push_default(git : SimpleGit) -> @core.Promise[Unit] =
  #| (git) => git.push()

///|
extern "js" fn ffi_pull(
  git : SimpleGit,
  remote : String,
  branch : String,
) -> @core.Promise[PullResult] =
  #| (git, remote, branch) => git.pull(remote, branch)

///|
extern "js" fn ffi_pull_default(git : SimpleGit) -> @core.Promise[PullResult] =
  #| (git) => git.pull()

///|
extern "js" fn ffi_fetch(
  git : SimpleGit,
  remote : String,
  branch : String,
) -> @core.Promise[FetchResult] =
  #| (git, remote, branch) => git.fetch(remote, branch)

///|
extern "js" fn ffi_fetch_default(git : SimpleGit) -> @core.Promise[FetchResult] =
  #| (git) => git.fetch()

///| Push/Pull/Fetch Methods

///|
/// Push to remote
///
/// # Options
/// - `remote`: Remote name (default: "origin")
/// - `branch`: Branch name
/// - `set_upstream`: Set upstream tracking (-u flag)
/// - `force`: Force push (--force flag)
/// - `tags`: Push tags (--tags flag)
///
/// @example
/// ```moonbit
/// git.push().wait()  // Push current branch to origin
/// git.push(remote="origin", branch="main", set_upstream=true).wait()
/// ```
pub async fn SimpleGit::push(
  self : SimpleGit,
  remote? : String,
  branch? : String,
  set_upstream? : Bool,
  force? : Bool,
  tags? : Bool,
) -> Unit {
  if set_upstream is None && force is None && tags is None {
    match (remote, branch) {
      (Some(r), Some(b)) => ffi_push(self, r, b).wait()
      _ => ffi_push_default(self).wait()
    }
  } else {
    let r = remote.unwrap_or("origin")
    let b = branch.unwrap_or("")
    let options : Array[String] = []
    if set_upstream == Some(true) {
      options.push("-u")
    }
    if force == Some(true) {
      options.push("--force")
    }
    if tags == Some(true) {
      options.push("--tags")
    }
    ffi_push_with_options(self, r, b, @core.any(options)).wait()
  }
}

///|
/// Pull from remote
///
/// # Options
/// - `remote`: Remote name (default: "origin")
/// - `branch`: Branch name (default: current branch)
///
/// @example
/// ```moonbit
/// let result = git.pull().wait()
///
/// let result = git.pull(remote="origin", branch="main").wait()
/// ```
pub async fn SimpleGit::pull(
  self : SimpleGit,
  remote? : String,
  branch? : String,
) -> PullResult {
  match (remote, branch) {
    (Some(r), Some(b)) => ffi_pull(self, r, b).wait()
    _ => ffi_pull_default(self).wait()
  }
}

///|
/// Fetch from remote
pub async fn SimpleGit::fetch(
  self : SimpleGit,
  remote? : String,
  branch? : String,
) -> FetchResult {
  match (remote, branch) {
    (Some(r), Some(b)) => ffi_fetch(self, r, b).wait()
    _ => ffi_fetch_default(self).wait()
  }
}

///| Status FFI

///|
extern "js" fn ffi_status(git : SimpleGit) -> @core.Promise[StatusResult] =
  #| (git) => git.status()

///| Status Methods

///|
/// Get repository status
pub async fn SimpleGit::status(self : SimpleGit) -> StatusResult {
  ffi_status(self).wait()
}

///| StatusResult accessors

///| StatusResult isClean FFI

///|
/// Check if working directory is clean (calls JavaScript isClean() method)
pub extern "js" fn status_is_clean_method(status : StatusResult) -> Bool =
  #| (status) => status.isClean()

///| StatusResult Methods

///|
/// Get current branch name
pub fn StatusResult::current(self : StatusResult) -> String {
  self.current
}

///|
/// Get tracking branch name
pub fn StatusResult::tracking(self : StatusResult) -> String {
  self.tracking
}

///|
/// Check if working directory is clean
pub fn StatusResult::isClean(self : StatusResult) -> Bool {
  status_is_clean_method(self)
}

///|
/// Get untracked files
pub fn StatusResult::notAdded(self : StatusResult) -> Array[String] {
  self.not_added
}

///|
/// Get modified files
pub fn StatusResult::modified(self : StatusResult) -> Array[String] {
  self.modified
}

///|
/// Get staged files
pub fn StatusResult::staged(self : StatusResult) -> Array[String] {
  self.staged
}

///|
/// Get deleted files
pub fn StatusResult::deleted(self : StatusResult) -> Array[String] {
  self.deleted
}

///|
/// Get created files
pub fn StatusResult::created(self : StatusResult) -> Array[String] {
  self.created
}

///|
/// Get conflicted files
pub fn StatusResult::conflicted(self : StatusResult) -> Array[String] {
  self.conflicted
}

///|
/// Get commits ahead of tracking branch
pub fn StatusResult::ahead(self : StatusResult) -> Int {
  self.ahead
}

///|
/// Get commits behind tracking branch
pub fn StatusResult::behind(self : StatusResult) -> Int {
  self.behind
}

///| Log FFI

///|
extern "js" fn ffi_log(git : SimpleGit) -> @core.Promise[LogResult] =
  #| (git) => git.log()

///|
extern "js" fn ffi_log_with_options(
  git : SimpleGit,
  options : @core.Any,
) -> @core.Promise[LogResult] =
  #| (git, options) => git.log(options)

///| Log Methods

///|
/// Get commit log
pub async fn SimpleGit::log(
  self : SimpleGit,
  max_count? : Int,
  from? : String,
  to? : String,
  file? : String,
) -> LogResult {
  if max_count is None && from is None && to is None && file is None {
    ffi_log(self).wait()
  } else {
    let options = @core.new_object()
    if max_count is Some(n) {
      options["maxCount"] = @core.any(n)
    }
    if from is Some(f) {
      options["from"] = @core.any(f)
    }
    if to is Some(t) {
      options["to"] = @core.any(t)
    }
    if file is Some(f) {
      options["file"] = @core.any(f)
    }
    ffi_log_with_options(self, options).wait()
  }
}

///| LogResult accessors

///|
extern "js" fn ffi_log_all(log : LogResult) -> @core.Any =
  #| (log) => log.all

///|
extern "js" fn ffi_log_latest(log : LogResult) -> @core.Any =
  #| (log) => log.latest

///|
extern "js" fn ffi_log_total(log : LogResult) -> Int =
  #| (log) => log.total

///| LogResult Methods

///|
/// Get all commits
pub fn LogResult::all(self : LogResult) -> @core.Any {
  ffi_log_all(self)
}

///|
/// Get latest commit
pub fn LogResult::latest(self : LogResult) -> @core.Any {
  ffi_log_latest(self)
}

///|
/// Get total number of commits
pub fn LogResult::total(self : LogResult) -> Int {
  ffi_log_total(self)
}

///| Branch FFI

///|
extern "js" fn ffi_branch(git : SimpleGit) -> @core.Promise[BranchSummary] =
  #| (git) => git.branch()

///|
extern "js" fn ffi_branch_local(
  git : SimpleGit,
) -> @core.Promise[BranchSummary] =
  #| (git) => git.branchLocal()

///|
extern "js" fn ffi_checkout(
  git : SimpleGit,
  branch : String,
) -> @core.Promise[Unit] =
  #| (git, branch) => git.checkout(branch)

///|
extern "js" fn ffi_checkout_branch(
  git : SimpleGit,
  branch : String,
  start_point : String,
) -> @core.Promise[Unit] =
  #| (git, branch, start_point) => git.checkoutBranch(branch, start_point)

///|
extern "js" fn ffi_checkout_local_branch(
  git : SimpleGit,
  branch : String,
) -> @core.Promise[Unit] =
  #| (git, branch) => git.checkoutLocalBranch(branch)

///|
extern "js" fn ffi_delete_local_branch(
  git : SimpleGit,
  branch : String,
  force : Bool,
) -> @core.Promise[Unit] =
  #| (git, branch, force) => git.deleteLocalBranch(branch, force)

///| Branch Methods

///|
/// Get branch summary (all branches)
pub async fn SimpleGit::branch(self : SimpleGit) -> BranchSummary {
  ffi_branch(self).wait()
}

///|
/// Get local branch summary
pub async fn SimpleGit::branchLocal(self : SimpleGit) -> BranchSummary {
  ffi_branch_local(self).wait()
}

///|
/// Checkout a branch or revision
pub async fn SimpleGit::checkout(self : SimpleGit, branch : String) -> Unit {
  ffi_checkout(self, branch).wait()
}

///|
/// Create and checkout a new branch from start point
pub async fn SimpleGit::checkoutBranch(
  self : SimpleGit,
  branch : String,
  start_point : String,
) -> Unit {
  ffi_checkout_branch(self, branch, start_point).wait()
}

///|
/// Create and checkout a new local branch
pub async fn SimpleGit::checkoutLocalBranch(
  self : SimpleGit,
  branch : String,
) -> Unit {
  ffi_checkout_local_branch(self, branch).wait()
}

///|
/// Delete a local branch
pub async fn SimpleGit::deleteLocalBranch(
  self : SimpleGit,
  branch : String,
  force? : Bool = false,
) -> Unit {
  ffi_delete_local_branch(self, branch, force).wait()
}

///| BranchSummary accessors

///|
extern "js" fn ffi_branch_current(branch : BranchSummary) -> String =
  #| (branch) => branch.current

///|
extern "js" fn ffi_branch_all(branch : BranchSummary) -> @core.Any =
  #| (branch) => branch.all

///|
extern "js" fn ffi_branch_branches(branch : BranchSummary) -> @core.Any =
  #| (branch) => branch.branches

///| BranchSummary Methods

///|
/// Get current branch name
pub fn BranchSummary::current(self : BranchSummary) -> String {
  ffi_branch_current(self)
}

///|
/// Get all branch names
pub fn BranchSummary::all(self : BranchSummary) -> Array[String] {
  @core.identity(ffi_branch_all(self))
}

///|
/// Get branches object
pub fn BranchSummary::branches(self : BranchSummary) -> @core.Any {
  ffi_branch_branches(self)
}

///| Diff FFI

///|
extern "js" fn ffi_diff(git : SimpleGit) -> @core.Promise[String] =
  #| (git) => git.diff()

///|
extern "js" fn ffi_diff_with_options(
  git : SimpleGit,
  options : @core.Any,
) -> @core.Promise[String] =
  #| (git, options) => git.diff(options)

///|
extern "js" fn ffi_diff_summary(git : SimpleGit) -> @core.Promise[DiffResult] =
  #| (git) => git.diffSummary()

///| Diff Methods

///|
/// Get diff output as string
pub async fn SimpleGit::diff(
  self : SimpleGit,
  staged? : Bool,
  nameOnly? : Bool,
) -> String {
  if staged is None && nameOnly is None {
    ffi_diff(self).wait()
  } else {
    let options : Array[String] = []
    if staged == Some(true) {
      options.push("--staged")
    }
    if nameOnly == Some(true) {
      options.push("--name-only")
    }
    ffi_diff_with_options(self, @core.any(options)).wait()
  }
}

///|
/// Get diff summary
pub async fn SimpleGit::diffSummary(self : SimpleGit) -> DiffResult {
  ffi_diff_summary(self).wait()
}

///| DiffResult accessors

///|
extern "js" fn ffi_diff_result_files(diff : DiffResult) -> @core.Any =
  #| (diff) => diff.files

///|
extern "js" fn ffi_diff_result_insertions(diff : DiffResult) -> Int =
  #| (diff) => diff.insertions

///|
extern "js" fn ffi_diff_result_deletions(diff : DiffResult) -> Int =
  #| (diff) => diff.deletions

///|
extern "js" fn ffi_diff_result_changed(diff : DiffResult) -> Int =
  #| (diff) => diff.changed

///| DiffResult Methods

///|
/// Get changed files
pub fn DiffResult::files(self : DiffResult) -> @core.Any {
  ffi_diff_result_files(self)
}

///|
/// Get total insertions
pub fn DiffResult::insertions(self : DiffResult) -> Int {
  ffi_diff_result_insertions(self)
}

///|
/// Get total deletions
pub fn DiffResult::deletions(self : DiffResult) -> Int {
  ffi_diff_result_deletions(self)
}

///|
/// Get number of changed files
pub fn DiffResult::changed(self : DiffResult) -> Int {
  ffi_diff_result_changed(self)
}

///| Merge/Rebase FFI

///|
extern "js" fn ffi_merge(git : SimpleGit, from : String) -> @core.Promise[Unit] =
  #| (git, from) => git.merge([from])

///|
extern "js" fn ffi_rebase(
  git : SimpleGit,
  options : @core.Any,
) -> @core.Promise[Unit] =
  #| (git, options) => git.rebase(options)

///| Merge/Rebase Methods

///|
/// Merge a branch into current branch
pub async fn SimpleGit::merge(self : SimpleGit, from : String) -> Unit {
  ffi_merge(self, from).wait()
}

///|
/// Rebase current branch
pub async fn SimpleGit::rebase(self : SimpleGit, upstream : String) -> Unit {
  ffi_rebase(self, @core.any([upstream])).wait()
}

///| Stash FFI

///|
extern "js" fn ffi_stash(git : SimpleGit) -> @core.Promise[Unit] =
  #| (git) => git.stash()

///|
extern "js" fn ffi_stash_list(git : SimpleGit) -> @core.Promise[@core.Any] =
  #| (git) => git.stashList()

///|
extern "js" fn ffi_stash_pop(git : SimpleGit) -> @core.Promise[Unit] =
  #| (git) => git.stash(['pop'])

///| Stash Methods

///|
/// Stash changes
pub async fn SimpleGit::stash(self : SimpleGit) -> Unit {
  ffi_stash(self).wait()
}

///|
/// List stashes
pub async fn SimpleGit::stashList(self : SimpleGit) -> @core.Any {
  ffi_stash_list(self).wait()
}

///|
/// Pop latest stash
pub async fn SimpleGit::stashPop(self : SimpleGit) -> Unit {
  ffi_stash_pop(self).wait()
}

///| Tag FFI

///|
extern "js" fn ffi_tags(git : SimpleGit) -> @core.Promise[@core.Any] =
  #| (git) => git.tags()

///|
extern "js" fn ffi_add_tag(
  git : SimpleGit,
  name : String,
) -> @core.Promise[Unit] =
  #| (git, name) => git.addTag(name)

///|
extern "js" fn ffi_add_annotated_tag(
  git : SimpleGit,
  name : String,
  message : String,
) -> @core.Promise[Unit] =
  #| (git, name, message) => git.addAnnotatedTag(name, message)

///| Tag Methods

///|
/// List tags
pub async fn SimpleGit::tags(self : SimpleGit) -> @core.Any {
  ffi_tags(self).wait()
}

///|
/// Add a lightweight tag
pub async fn SimpleGit::addTag(self : SimpleGit, name : String) -> Unit {
  ffi_add_tag(self, name).wait()
}

///|
/// Add an annotated tag
pub async fn SimpleGit::addAnnotatedTag(
  self : SimpleGit,
  name : String,
  message : String,
) -> Unit {
  ffi_add_annotated_tag(self, name, message).wait()
}

///| Remote FFI

///|
extern "js" fn ffi_get_remotes(
  git : SimpleGit,
  verbose : Bool,
) -> @core.Promise[@core.Any] =
  #| (git, verbose) => git.getRemotes(verbose)

///|
extern "js" fn ffi_add_remote(
  git : SimpleGit,
  name : String,
  url : String,
) -> @core.Promise[Unit] =
  #| (git, name, url) => git.addRemote(name, url)

///|
extern "js" fn ffi_remove_remote(
  git : SimpleGit,
  name : String,
) -> @core.Promise[Unit] =
  #| (git, name) => git.removeRemote(name)

///| Remote Methods

///|
/// Get remotes
pub async fn SimpleGit::getRemotes(
  self : SimpleGit,
  verbose? : Bool = false,
) -> @core.Any {
  ffi_get_remotes(self, verbose).wait()
}

///|
/// Add a remote
pub async fn SimpleGit::addRemote(
  self : SimpleGit,
  name : String,
  url : String,
) -> Unit {
  ffi_add_remote(self, name, url).wait()
}

///|
/// Remove a remote
pub async fn SimpleGit::removeRemote(self : SimpleGit, name : String) -> Unit {
  ffi_remove_remote(self, name).wait()
}

///| Raw FFI

///|
extern "js" fn ffi_raw(
  git : SimpleGit,
  commands : @core.Any,
) -> @core.Promise[String] =
  #| (git, commands) => git.raw(commands)

///| Raw Methods

///|
/// Execute raw git command
pub async fn SimpleGit::raw(
  self : SimpleGit,
  commands : Array[String],
) -> String {
  ffi_raw(self, @core.any(commands)).wait()
}

///| CommitResult accessors

///|
extern "js" fn ffi_commit_result_commit(result : CommitResult) -> String =
  #| (result) => result.commit

///|
extern "js" fn ffi_commit_result_branch(result : CommitResult) -> String =
  #| (result) => result.branch

///|
extern "js" fn ffi_commit_result_summary(result : CommitResult) -> @core.Any =
  #| (result) => result.summary

///| CommitResult Methods

///|
/// Get commit hash
pub fn CommitResult::commit(self : CommitResult) -> String {
  ffi_commit_result_commit(self)
}

///|
/// Get branch name
pub fn CommitResult::branch(self : CommitResult) -> String {
  ffi_commit_result_branch(self)
}

///|
/// Get commit summary
pub fn CommitResult::summary(self : CommitResult) -> @core.Any {
  ffi_commit_result_summary(self)
}

///| Checkout options

///|
extern "js" fn ffi_checkout_with_options(
  git : SimpleGit,
  options : @core.Any,
) -> @core.Promise[Unit] =
  #| (git, options) => git.checkout(options)

///|
/// Checkout with options (e.g., checkout files)
pub async fn SimpleGit::checkoutFile(
  self : SimpleGit,
  file : String,
  commit? : String,
) -> Unit {
  let options : Array[String] = []
  if commit is Some(c) {
    options.push(c)
  }
  options.push("--")
  options.push(file)
  ffi_checkout_with_options(self, @core.any(options)).wait()
}

///| Reset FFI

///|
extern "js" fn ffi_reset(git : SimpleGit, mode : String) -> @core.Promise[Unit] =
  #| (git, mode) => git.reset([mode])

///|
extern "js" fn ffi_reset_to(
  git : SimpleGit,
  mode : String,
  commit : String,
) -> @core.Promise[Unit] =
  #| (git, mode, commit) => git.reset([mode, commit])

///| Reset Methods

///|
/// Reset HEAD (soft, mixed, or hard)
pub async fn SimpleGit::reset(
  self : SimpleGit,
  mode? : String = "--mixed",
  commit? : String,
) -> Unit {
  if commit is Some(c) {
    ffi_reset_to(self, mode, c).wait()
  } else {
    ffi_reset(self, mode).wait()
  }
}

///| Rev-parse FFI

///|
extern "js" fn ffi_rev_parse(
  git : SimpleGit,
  options : @core.Any,
) -> @core.Promise[String] =
  #| (git, options) => git.revparse(options)

///| Rev-parse Methods

///|
/// Get the SHA of a revision
pub async fn SimpleGit::revparse(self : SimpleGit, revision : String) -> String {
  ffi_rev_parse(self, @core.any([revision])).wait()
}

///|
/// Get current HEAD SHA
pub async fn SimpleGit::getHeadSha(self : SimpleGit) -> String {
  self.revparse("HEAD")
}

///| Show FFI

///|
extern "js" fn ffi_show(
  git : SimpleGit,
  options : @core.Any,
) -> @core.Promise[String] =
  #| (git, options) => git.show(options)

///| Show Methods

///|
/// Show commit details
pub async fn SimpleGit::show(
  self : SimpleGit,
  commit? : String = "HEAD",
) -> String {
  ffi_show(self, @core.any([commit])).wait()
}
