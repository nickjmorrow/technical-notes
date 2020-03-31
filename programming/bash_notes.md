# Bash Notes

## Renaming

### Removing spaces

```bash
for f in */ *; do
      mv "$f" "${f// /_}";
done
```

`for f in */ *;` captures all files in the current directory with a space in them.

`do mv "$f" "${f// /_}";` moves (renames) all files from what they were to what they were but with spaces replaced by `_`.

Alternatively, to test:

```bash
for f in */ *; do
      echo `echo "${f// /_}"`; done
```

This `echo`s the output of `echo "${f// /_}"`, so you can check what each file will be renamed to.

### Lowercase

```bash
for f in $( ls -p | grep / -v); do
      mv "$f" `echo "$f" | tr 'A-Z' 'a-z'`; done
```

### Find all files that contain text in filename

```bash
find . -name '*.h' -o -name '*.cpp'
```

### Find all files with extension that contain name in filename

```bash
find . -name '*.jpg' -o -name '*.png' -print | grep Robert
```

### Find all files that contain text

```bash
grep -rnw '/path/to/somewhere/' -e 'pattern'
```

```bash
grep -ril "text-to-find-here" /
```

grep flags
`-r` or `-R` is recursive
`-n` is line number
`-w` stands for match the whole word
`-l` can be added to just give the file name of matching files

`for f in $(ls -p | grep / -v)` looks for all contents in the current directory, with directories formatted to have a `/` at the end because of the `-p`. We then use `grep / -v` to return the complement of all return values that contain a `/`, so all files.

`` `echo "$f" | tr 'A-Z' 'a-z'` `` replaces all capital letters with lowercase letters.
