# Random bash

Here's random useful bash stuff:

## Check if program is installed

Checks if `$1` is installed

```bash
#!/usr/bin/env bash
command_exists() { type "$1" &> /dev/null; }

if command_exists "$1"; then
    echo "$1 installed"
else
    echo "$1 not installed"
    exit 1
fi
```

### Check which package manager is installed

```bash
#!/usr/bin/env bash
command_exists() { type "$1" &> /dev/null; }

if command_exists "apt-get"; then
    PM="apt-get"
elif command_exists "yum"; then
    PM="yum"
elif command_exists "pacman"; then
    PM="pacman"
elif command_exists "zypper"; then
    PM="zypper"
elif command_exists "emerge"; then
    PM="emerge"
elif command_exists "apk"; then
    PM="apk"
else
    >&2 echo "Unsupported: unknown package manager"
    exit 1
fi

echo "Package manager: ${PM}"
```

## Check if root

This exits with and error message if it's run as root.

```bash
#!/usr/bin/env bash
if [ $(whoami) != "root" ]; then
    >&2 echo Rerun as non-root user
    exit 1
fi
```

## Output to stderr

```bash
#!/usr/bin/env bash
# Put `>&2` at beginning or end of line to output to stderr
>&2 echo "This goes to stderr"
echo "This goes to stdout"
```