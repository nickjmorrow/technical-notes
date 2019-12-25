# Git Branching

[Learn Git Branching](https://learngitbranching.js.org)

## Relative Refs

To chck out the commit above master (move HEAD to above master)

`git checkout master^`

To move head to the node before it:

`git checkout HEAD^`

Move the number of commits back with `~`. This moves the head up the branch.

`git checkout HEAD~4`

## Branch forcing

Use relative refs to move branches around. You can directly reassign a branch to a commit with the `-f` option.

`git branch -f master HEAD~3`

`git branch -f bugFix C2`

This moves the master branch to three parents behind `HEAD`.

## Git Reset

`git reset` reverts changes by moving a branch reference backwards in time to an older commit. This is like rewriting history.

`git reset HEAD~1` moves the branch to the previous commit.

While this works locally, it doesn't work for rewriting history on a remote branch that others are using.

`git revert HEAD` creates a brand new commit that introduces changes. Those changes just happen to exactly remove the previous commit's changes. Now you can push your new changes to others.

## Cherry pick

`git cherry-pick C2 C4` can be used to move commits to the current branch.

## Interactive rebase

`git rebase -i` is just reebasing with the interactive option

## Reordering commits

`git rebase -i` to reorder the commits and put the one you want to change on top

`commit --amend` to make a slight remodification

`git rebase -i` to reorder the commits back to how they were

Then move master to the updated part of the tree.

## Tagging commits

`git tag v1 C1`

If you leave the commit off, git will just use whatever `HEAD` is at.

`git tag v1`

## Traversing tree

Check out commit directly above HEAD

`git checkout HEAD~`

Check out merge commit to the right of HEAD

`git checkout HEAD^2`

Check out commit two commits above HEAD

`git checkout HEAD~2`

These can be chained like:

`git checkout HEAD^2~2`
