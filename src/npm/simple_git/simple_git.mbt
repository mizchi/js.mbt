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
pub extern "js" fn SimpleGit::as_any(self : SimpleGit) -> @nostd.Any =
  #| (x) => x

///|
/// Git status result
#external
pub type StatusResult

///|
pub extern "js" fn StatusResult::as_any(self : StatusResult) -> @nostd.Any =
  #| (x) => x

///|
/// Git log result
#external
pub type LogResult

///|
pub extern "js" fn LogResult::as_any(self : LogResult) -> @nostd.Any =
  #| (x) => x

///|
/// Git branch summary
#external
pub type BranchSummary

///|
pub extern "js" fn BranchSummary::as_any(self : BranchSummary) -> @nostd.Any =
  #| (x) => x

///|
/// Git diff result
#external
pub type DiffResult

///|
pub extern "js" fn DiffResult::as_any(self : DiffResult) -> @nostd.Any =
  #| (x) => x

///|
/// Git fetch result
#external
pub type FetchResult

///|
pub extern "js" fn FetchResult::as_any(self : FetchResult) -> @nostd.Any =
  #| (x) => x

///|
/// Git pull result
#external
pub type PullResult

///|
pub extern "js" fn PullResult::as_any(self : PullResult) -> @nostd.Any =
  #| (x) => x

///|
/// Commit result
#external
pub type CommitResult

///|
pub extern "js" fn CommitResult::as_any(self : CommitResult) -> @nostd.Any =
  #| (x) => x

///| Constructor FFI

///|
extern "js" fn ffi_simple_git() -> SimpleGit =
  #| () => require('simple-git')()

///|
extern "js" fn ffi_simple_git_with_path(base_dir : String) -> SimpleGit =
  #| (base_dir) => require('simple-git')(base_dir)

///|
extern "js" fn ffi_simple_git_with_options(options : @nostd.Any) -> SimpleGit =
  #| (options) => require('simple-git')(options)

///| Constructor

///|
/// Create a SimpleGit instance
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
  let options = @nostd.Object::new()
  if base_dir is Some(v) {
    options["baseDir"] = @nostd.any(v)
  }
  if binary is Some(v) {
    options["binary"] = @nostd.any(v)
  }
  if maxConcurrentProcesses is Some(v) {
    options["maxConcurrentProcesses"] = @nostd.any(v)
  }
  if trimmed is Some(v) {
    options["trimmed"] = @nostd.any(v)
  }
  ffi_simple_git_with_options(options)
}

///| Init/Clone FFI

///|
extern "js" fn ffi_init(git : SimpleGit, bare : Bool) -> @nostd.Promise[Unit] =
  #| (git, bare) => git.init(bare)

///|
extern "js" fn ffi_clone(
  git : SimpleGit,
  repo_path : String,
  local_path : String,
) -> @nostd.Promise[String] =
  #| (git, repo_path, local_path) => git.clone(repo_path, local_path)

///|
extern "js" fn ffi_clone_with_options(
  git : SimpleGit,
  repo_path : String,
  local_path : String,
  options : @nostd.Any,
) -> @nostd.Promise[String] =
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
    ffi_clone_with_options(self, repo_path, local_path, @nostd.any(options)).wait()
  }
}

///| Add/Commit FFI

///|
extern "js" fn ffi_add(
  git : SimpleGit,
  files : @nostd.Any,
) -> @nostd.Promise[Unit] =
  #| (git, files) => git.add(files)

///|
extern "js" fn ffi_commit(
  git : SimpleGit,
  message : String,
  files : @nostd.Any,
  options : @nostd.Any,
) -> @nostd.Promise[CommitResult] =
  #| (git, message, files, options) => git.commit(message, files, options)

///|
extern "js" fn ffi_commit_simple(
  git : SimpleGit,
  message : String,
) -> @nostd.Promise[CommitResult] =
  #| (git, message) => git.commit(message)

///| Add/Commit Methods

///|
/// Add files to staging area
pub async fn SimpleGit::add(self : SimpleGit, files : Array[String]) -> Unit {
  ffi_add(self, @nostd.any(files)).wait()
}

///|
/// Add single file to staging area
pub async fn SimpleGit::addFile(self : SimpleGit, file : String) -> Unit {
  ffi_add(self, @nostd.any(file)).wait()
}

///|
/// Add all files to staging area
pub async fn SimpleGit::addAll(self : SimpleGit) -> Unit {
  ffi_add(self, @nostd.any(".")).wait()
}

///|
/// Commit staged changes
pub async fn SimpleGit::commit(
  self : SimpleGit,
  message : String,
  files? : Array[String],
  author? : String,
) -> CommitResult {
  if files is None && author is None {
    ffi_commit_simple(self, message).wait()
  } else {
    let file_arr : @nostd.Any = match files {
      Some(f) => @nostd.any(f)
      None => {
        let empty : Array[String] = []
        @nostd.any(empty)
      }
    }
    let opts = @nostd.Object::new()
    if author is Some(a) {
      opts["--author"] = @nostd.any(a)
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
) -> @nostd.Promise[Unit] =
  #| (git, remote, branch) => git.push(remote, branch)

///|
extern "js" fn ffi_push_with_options(
  git : SimpleGit,
  remote : String,
  branch : String,
  options : @nostd.Any,
) -> @nostd.Promise[Unit] =
  #| (git, remote, branch, options) => git.push(remote, branch, options)

///|
extern "js" fn ffi_push_default(git : SimpleGit) -> @nostd.Promise[Unit] =
  #| (git) => git.push()

///|
extern "js" fn ffi_pull(
  git : SimpleGit,
  remote : String,
  branch : String,
) -> @nostd.Promise[PullResult] =
  #| (git, remote, branch) => git.pull(remote, branch)

///|
extern "js" fn ffi_pull_default(git : SimpleGit) -> @nostd.Promise[PullResult] =
  #| (git) => git.pull()

///|
extern "js" fn ffi_fetch(
  git : SimpleGit,
  remote : String,
  branch : String,
) -> @nostd.Promise[FetchResult] =
  #| (git, remote, branch) => git.fetch(remote, branch)

///|
extern "js" fn ffi_fetch_default(
  git : SimpleGit,
) -> @nostd.Promise[FetchResult] =
  #| (git) => git.fetch()

///| Push/Pull/Fetch Methods

///|
/// Push to remote
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
    ffi_push_with_options(self, r, b, @nostd.any(options)).wait()
  }
}

///|
/// Pull from remote
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
extern "js" fn ffi_status(git : SimpleGit) -> @nostd.Promise[StatusResult] =
  #| (git) => git.status()

///| Status Methods

///|
/// Get repository status
pub async fn SimpleGit::status(self : SimpleGit) -> StatusResult {
  ffi_status(self).wait()
}

///| StatusResult accessors

///|
extern "js" fn ffi_status_current(status : StatusResult) -> String =
  #| (status) => status.current || ''

///|
extern "js" fn ffi_status_tracking(status : StatusResult) -> String =
  #| (status) => status.tracking || ''

///|
extern "js" fn ffi_status_is_clean(status : StatusResult) -> Bool =
  #| (status) => status.isClean()

///|
extern "js" fn ffi_status_not_added(status : StatusResult) -> @nostd.Any =
  #| (status) => status.not_added

///|
extern "js" fn ffi_status_modified(status : StatusResult) -> @nostd.Any =
  #| (status) => status.modified

///|
extern "js" fn ffi_status_staged(status : StatusResult) -> @nostd.Any =
  #| (status) => status.staged

///|
extern "js" fn ffi_status_deleted(status : StatusResult) -> @nostd.Any =
  #| (status) => status.deleted

///|
extern "js" fn ffi_status_created(status : StatusResult) -> @nostd.Any =
  #| (status) => status.created

///|
extern "js" fn ffi_status_conflicted(status : StatusResult) -> @nostd.Any =
  #| (status) => status.conflicted

///|
extern "js" fn ffi_status_ahead(status : StatusResult) -> Int =
  #| (status) => status.ahead

///|
extern "js" fn ffi_status_behind(status : StatusResult) -> Int =
  #| (status) => status.behind

///| StatusResult Methods

///|
/// Get current branch name
pub fn StatusResult::current(self : StatusResult) -> String {
  ffi_status_current(self)
}

///|
/// Get tracking branch name
pub fn StatusResult::tracking(self : StatusResult) -> String {
  ffi_status_tracking(self)
}

///|
/// Check if working directory is clean
pub fn StatusResult::isClean(self : StatusResult) -> Bool {
  ffi_status_is_clean(self)
}

///|
/// Get untracked files
pub fn StatusResult::notAdded(self : StatusResult) -> Array[String] {
  @nostd.identity(ffi_status_not_added(self))
}

///|
/// Get modified files
pub fn StatusResult::modified(self : StatusResult) -> Array[String] {
  @nostd.identity(ffi_status_modified(self))
}

///|
/// Get staged files
pub fn StatusResult::staged(self : StatusResult) -> Array[String] {
  @nostd.identity(ffi_status_staged(self))
}

///|
/// Get deleted files
pub fn StatusResult::deleted(self : StatusResult) -> Array[String] {
  @nostd.identity(ffi_status_deleted(self))
}

///|
/// Get created files
pub fn StatusResult::created(self : StatusResult) -> Array[String] {
  @nostd.identity(ffi_status_created(self))
}

///|
/// Get conflicted files
pub fn StatusResult::conflicted(self : StatusResult) -> Array[String] {
  @nostd.identity(ffi_status_conflicted(self))
}

///|
/// Get commits ahead of tracking branch
pub fn StatusResult::ahead(self : StatusResult) -> Int {
  ffi_status_ahead(self)
}

///|
/// Get commits behind tracking branch
pub fn StatusResult::behind(self : StatusResult) -> Int {
  ffi_status_behind(self)
}

///| Log FFI

///|
extern "js" fn ffi_log(git : SimpleGit) -> @nostd.Promise[LogResult] =
  #| (git) => git.log()

///|
extern "js" fn ffi_log_with_options(
  git : SimpleGit,
  options : @nostd.Any,
) -> @nostd.Promise[LogResult] =
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
    let options = @nostd.Object::new()
    if max_count is Some(n) {
      options["maxCount"] = @nostd.any(n)
    }
    if from is Some(f) {
      options["from"] = @nostd.any(f)
    }
    if to is Some(t) {
      options["to"] = @nostd.any(t)
    }
    if file is Some(f) {
      options["file"] = @nostd.any(f)
    }
    ffi_log_with_options(self, options).wait()
  }
}

///| LogResult accessors

///|
extern "js" fn ffi_log_all(log : LogResult) -> @nostd.Any =
  #| (log) => log.all

///|
extern "js" fn ffi_log_latest(log : LogResult) -> @nostd.Any =
  #| (log) => log.latest

///|
extern "js" fn ffi_log_total(log : LogResult) -> Int =
  #| (log) => log.total

///| LogResult Methods

///|
/// Get all commits
pub fn LogResult::all(self : LogResult) -> @nostd.Any {
  ffi_log_all(self)
}

///|
/// Get latest commit
pub fn LogResult::latest(self : LogResult) -> @nostd.Any {
  ffi_log_latest(self)
}

///|
/// Get total number of commits
pub fn LogResult::total(self : LogResult) -> Int {
  ffi_log_total(self)
}

///| Branch FFI

///|
extern "js" fn ffi_branch(git : SimpleGit) -> @nostd.Promise[BranchSummary] =
  #| (git) => git.branch()

///|
extern "js" fn ffi_branch_local(
  git : SimpleGit,
) -> @nostd.Promise[BranchSummary] =
  #| (git) => git.branchLocal()

///|
extern "js" fn ffi_checkout(
  git : SimpleGit,
  branch : String,
) -> @nostd.Promise[Unit] =
  #| (git, branch) => git.checkout(branch)

///|
extern "js" fn ffi_checkout_branch(
  git : SimpleGit,
  branch : String,
  start_point : String,
) -> @nostd.Promise[Unit] =
  #| (git, branch, start_point) => git.checkoutBranch(branch, start_point)

///|
extern "js" fn ffi_checkout_local_branch(
  git : SimpleGit,
  branch : String,
) -> @nostd.Promise[Unit] =
  #| (git, branch) => git.checkoutLocalBranch(branch)

///|
extern "js" fn ffi_delete_local_branch(
  git : SimpleGit,
  branch : String,
  force : Bool,
) -> @nostd.Promise[Unit] =
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
extern "js" fn ffi_branch_all(branch : BranchSummary) -> @nostd.Any =
  #| (branch) => branch.all

///|
extern "js" fn ffi_branch_branches(branch : BranchSummary) -> @nostd.Any =
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
  @nostd.identity(ffi_branch_all(self))
}

///|
/// Get branches object
pub fn BranchSummary::branches(self : BranchSummary) -> @nostd.Any {
  ffi_branch_branches(self)
}

///| Diff FFI

///|
extern "js" fn ffi_diff(git : SimpleGit) -> @nostd.Promise[String] =
  #| (git) => git.diff()

///|
extern "js" fn ffi_diff_with_options(
  git : SimpleGit,
  options : @nostd.Any,
) -> @nostd.Promise[String] =
  #| (git, options) => git.diff(options)

///|
extern "js" fn ffi_diff_summary(git : SimpleGit) -> @nostd.Promise[DiffResult] =
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
    ffi_diff_with_options(self, @nostd.any(options)).wait()
  }
}

///|
/// Get diff summary
pub async fn SimpleGit::diffSummary(self : SimpleGit) -> DiffResult {
  ffi_diff_summary(self).wait()
}

///| DiffResult accessors

///|
extern "js" fn ffi_diff_result_files(diff : DiffResult) -> @nostd.Any =
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
pub fn DiffResult::files(self : DiffResult) -> @nostd.Any {
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
extern "js" fn ffi_merge(
  git : SimpleGit,
  from : String,
) -> @nostd.Promise[Unit] =
  #| (git, from) => git.merge([from])

///|
extern "js" fn ffi_rebase(
  git : SimpleGit,
  options : @nostd.Any,
) -> @nostd.Promise[Unit] =
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
  ffi_rebase(self, @nostd.any([upstream])).wait()
}

///| Stash FFI

///|
extern "js" fn ffi_stash(git : SimpleGit) -> @nostd.Promise[Unit] =
  #| (git) => git.stash()

///|
extern "js" fn ffi_stash_list(git : SimpleGit) -> @nostd.Promise[@nostd.Any] =
  #| (git) => git.stashList()

///|
extern "js" fn ffi_stash_pop(git : SimpleGit) -> @nostd.Promise[Unit] =
  #| (git) => git.stash(['pop'])

///| Stash Methods

///|
/// Stash changes
pub async fn SimpleGit::stash(self : SimpleGit) -> Unit {
  ffi_stash(self).wait()
}

///|
/// List stashes
pub async fn SimpleGit::stashList(self : SimpleGit) -> @nostd.Any {
  ffi_stash_list(self).wait()
}

///|
/// Pop latest stash
pub async fn SimpleGit::stashPop(self : SimpleGit) -> Unit {
  ffi_stash_pop(self).wait()
}

///| Tag FFI

///|
extern "js" fn ffi_tags(git : SimpleGit) -> @nostd.Promise[@nostd.Any] =
  #| (git) => git.tags()

///|
extern "js" fn ffi_add_tag(
  git : SimpleGit,
  name : String,
) -> @nostd.Promise[Unit] =
  #| (git, name) => git.addTag(name)

///|
extern "js" fn ffi_add_annotated_tag(
  git : SimpleGit,
  name : String,
  message : String,
) -> @nostd.Promise[Unit] =
  #| (git, name, message) => git.addAnnotatedTag(name, message)

///| Tag Methods

///|
/// List tags
pub async fn SimpleGit::tags(self : SimpleGit) -> @nostd.Any {
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
) -> @nostd.Promise[@nostd.Any] =
  #| (git, verbose) => git.getRemotes(verbose)

///|
extern "js" fn ffi_add_remote(
  git : SimpleGit,
  name : String,
  url : String,
) -> @nostd.Promise[Unit] =
  #| (git, name, url) => git.addRemote(name, url)

///|
extern "js" fn ffi_remove_remote(
  git : SimpleGit,
  name : String,
) -> @nostd.Promise[Unit] =
  #| (git, name) => git.removeRemote(name)

///| Remote Methods

///|
/// Get remotes
pub async fn SimpleGit::getRemotes(
  self : SimpleGit,
  verbose? : Bool = false,
) -> @nostd.Any {
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
  commands : @nostd.Any,
) -> @nostd.Promise[String] =
  #| (git, commands) => git.raw(commands)

///| Raw Methods

///|
/// Execute raw git command
pub async fn SimpleGit::raw(
  self : SimpleGit,
  commands : Array[String],
) -> String {
  ffi_raw(self, @nostd.any(commands)).wait()
}

///| CommitResult accessors

///|
extern "js" fn ffi_commit_result_commit(result : CommitResult) -> String =
  #| (result) => result.commit

///|
extern "js" fn ffi_commit_result_branch(result : CommitResult) -> String =
  #| (result) => result.branch

///|
extern "js" fn ffi_commit_result_summary(result : CommitResult) -> @nostd.Any =
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
pub fn CommitResult::summary(self : CommitResult) -> @nostd.Any {
  ffi_commit_result_summary(self)
}

///| Checkout options

///|
extern "js" fn ffi_checkout_with_options(
  git : SimpleGit,
  options : @nostd.Any,
) -> @nostd.Promise[Unit] =
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
  ffi_checkout_with_options(self, @nostd.any(options)).wait()
}

///| Reset FFI

///|
extern "js" fn ffi_reset(
  git : SimpleGit,
  mode : String,
) -> @nostd.Promise[Unit] =
  #| (git, mode) => git.reset([mode])

///|
extern "js" fn ffi_reset_to(
  git : SimpleGit,
  mode : String,
  commit : String,
) -> @nostd.Promise[Unit] =
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
  options : @nostd.Any,
) -> @nostd.Promise[String] =
  #| (git, options) => git.revparse(options)

///| Rev-parse Methods

///|
/// Get the SHA of a revision
pub async fn SimpleGit::revparse(self : SimpleGit, revision : String) -> String {
  ffi_rev_parse(self, @nostd.any([revision])).wait()
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
  options : @nostd.Any,
) -> @nostd.Promise[String] =
  #| (git, options) => git.show(options)

///| Show Methods

///|
/// Show commit details
pub async fn SimpleGit::show(
  self : SimpleGit,
  commit? : String = "HEAD",
) -> String {
  ffi_show(self, @nostd.any([commit])).wait()
}
