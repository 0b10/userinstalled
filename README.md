# userinstalled

A zsh plugin to backup (DNF) user installed packages (names).

e.g.

```sh
userinstalled help
userinstalled edit  # edit the config file
userinstalled backup  # dnf repoquery --userinstalled > target.txt
userinstalled restore # sudo dnf install $packages
```

## Motivations

Simplicity, ease-of-use. Typing:

```
dnf repoquery --userinstalled --queryformat %{name} | grep -vE "pkg1|pkg2|pkg3" > /foo/bar/baz.txt
```

...everytime you want to backup your installed package names, is a lot more work than simply: `userinstalled`

## Features

- Backup all user installed package names to a designated file
- Restore all backed up package names
- Ignore a package, or packages

## Install

### Zplugin

For turbo mode:

```sh
zplugin ice lucid wait
zplugin light 0b10/userinstalled
```

Without turbo mode:

```sh
zplugin light 0b10/userinstalled
```
