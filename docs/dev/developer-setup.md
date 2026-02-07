# Developer Setup

This repository uses devcontainer technology ([why?](../thinking/devcontainer.md)) to provide a consistent development environment across all contributors. This document explains the rationale behind using devcontainers, how to get started with them, and the prerequisites for using them effectively.

The goal is not convenience alone, but **environmental consistency**.

## Pre-requsites for using the devcontainer

- [Docker](https://docs.docker.com/)
- [Visual Studio Code](https://code.visualstudio.com/)
      - [Remote Development Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
- [Git](https://git-scm.com/)

## Getting Started with the DevContainer

- Create a `fork` of this repository in GitHub.
- Clone your fork locally.
- Open the cloned repository in Visual Studio Code.
- When prompted, choose to "Reopen in Container".
- The devcontainer will build and set up the environment. This may take a few minutes on the first run.
- Once the devcontainer is running, you can work on the project as you normally would.

## Getting Started with local setup

While using the devcontainer is recommended, you can also set up your local environment manually. However, you must ensure that your local setup matches the configurations defined in the repository (e.g., Node.js version, package versions).
Refer to the `devcontainer.json` and any related configuration files for the specific versions and tools required.
