# Keyboard Shortcut Design

## Company Guidelines

- microsoft guidelines
  - use a shortcut with CTRL for actions that represent large-scale effects. CTRL+S to save the current documnt
  - use the SHIFT + key combination for actions that extend or complement the actions of the standard shortcut key
- apple guidelines
  - prefer Shift as a secondary modifier when a shortcut complements another shortcut
  - use the Option key as a modifier sparingly
  - avoid creating a new shortcut by adding a modifier to an existing unrelated shortcut

## General Wisdom

- use standard keyboard shortcuts whenever possible
- when creating a keyboar shortcut, use:
  - CTRL modifier at first
  - CTRL + shift modifier when CTRL is already used
  - CTRL + alt modifier when CTRL + shift is already used

## System Design

- write out all common actions in the program (e.g. VSCode) that are likely to have heavily used shortcuts
- look at shortcuts of other programs to get a sense of what is "universal" across all programs
- ensure the shortcuts of VSCode match the universal shortcuts
- outside of uninversal shortcuts, start grouping actions together and analyzing whether the set of shortcuts makes sense.
  - are we using SHIFT when the action is similar to another action and can be thought of as a modifier? e.g. SAVE vs SAVE AS
  - do the actions associated with CTRL or CMD all feel the same? are they all "significant changes"?
  - do the letter keys trigger similar behavior when different modifier keys (CMD, OPTION) are used?
  - do more common shortcuts have shorter signatures than less common shortcuts?

[Keyboard shortcuts creation](https://blog.prototypr.io/keyboard-shortcuts-creation-d5ae2663fdea)
