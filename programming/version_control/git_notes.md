# Git Notes

## Inspection

`git diff`

See file changes locally.

`git diff my_file`

See changes for `my_file`.

`git log`

See all commit history.

`git log -p my_file`

See commit history for a file.

`git blame my_file`

See who changed what and when in `my_file`.

`git relog`

Show a log of changes to the local repository's `HEAD`. Good for finding lost work.

## Undoing

`git reset --hard HEAD`

Discard Staged and unstaged changes since the most recent commit.

`git reset --hard CommitA`

Discard staged and unstaged changes since `CommitA`.

`--hard`

Specifies that both the staged and unstaged changes are discarded.

`git checkout my_commit`

Discard unstaged changes since `my_commit`.

`git revert my_commit`

Undo the effects of changes in `my_commit`. `revert` makes a new commit when it undoes the changes and is safer for collaborative projects.

`git clean -n`

Delete untracked filed in the local working directory.

`-n` for a dry run where nothing is actually deleted.

`-f` to actually remove the files.

`-d` to remove untracked directories.

## Tidying

`git commit --amend`

Add your staged changes to the most recent commit. If nothing is staged, you can edit the most recent commit message.
