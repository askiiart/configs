# devcontainer settings

## Base settings

```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the
// README at: https://github.com/devcontainers/templates/tree/main/src/cpp
{
  "name": "askiiart <language>",
  // Or use a Dockerfile or Docker Compose file. More info: https://containers.dev/guide/dockerfile
  "image": "mcr.microsoft.com/devcontainers/<language>:1-1-bookworm",
  "customizations": {
    "vscode": {
      "extensions": [
        // Themes
        "kokoscript.loopytheme",
        "freebroccolo.theme-atom-one-dark",
        "BeardedBear.beardedtheme",
        // End themes
        "AdrienTecher.just-cant-git-enough",
        "codezombiech.gitignore",
        "DavidAnson.vscode-markdownlint",
        "dzhavat.git-cheatsheet",
        "eamodio.gitlens",
        "GitHub.copilot",
        "GitHub.copilot-labs",
        "GitHub.vscode-pull-request-github",
        "Gruntfuggly.todo-tree",
        "IJustDev.gitea-vscode",
        "mhutchie.git-graph",
        "VisualStudioExptTeam.intellicode-api-usage-examples",
        "VisualStudioExptTeam.vscodeintellicode",
        "wayou.vscode-todo-highlight",
        "yzhang.markdown-all-in-one",
      ]
    }
  },
  "mounts": [
    "source=${localEnv:HOME}/.zshrc,target=/etc/zsh/zshrc,type=bind,consistency=cached",
    "source=${localEnv:HOME}/.zkbd,target=/home/vscode/.zkbd,type=bind,consistency=cached",
    "source=${localEnv:HOME}/.oh-my-zsh,target=/home/vscode/.oh-my-zsh,type=bind,consistency=cached"
  ]
  // Features to add to the dev container. More info: https://containers.dev/features.
  // "features": {},
  // Use 'forwardPorts' to make a list of ports inside the container available locally.
  // "forwardPorts": [],
  // Use 'postCreateCommand' to run commands after the container is created.
  // "postCreateCommand": "gcc -v",
  // Configure tool-specific properties.
  // "customizations": {},
  // Uncomment to connect as root instead. More info: https://aka.ms/dev-containers-non-root.
  // "remoteUser": "root"
}
```

## C++

Extensions:

```json
        "danielpinto8zz6.c-cpp-compile-run",
        "ms-vscode.cmake-tools",
        "ms-vscode.cpptools",
        "ms-vscode.cpptools-extension-pack",
        "ms-vscode.cpptools-themes",
        "twxs.cmake",
```

## Rust

Extensions:

```json
        "rust-lang.rust-analyzer",
        "serayuzgur.crates"
```
