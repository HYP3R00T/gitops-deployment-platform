# Developer Setup

This repository uses a **devcontainer-based development environment** as the default way to work on the project.

The goal is not convenience alone, but **environmental consistency**.

## Why devcontainers

This project spans multiple concerns. In such setups, subtle differences in local environments (OS, shell, package versions) often become a source of friction that is unrelated to the actual work being done.

Devcontainers were chosen to address this directly.

By defining the development environment as code, the project ensures that:

- The same tools and versions are used across machines
- Setup steps are explicit and repeatable
- Onboarding does not require tribal knowledge
- Local development closely mirrors CI expectations

In other words, the environment becomes part of the system, not an external assumption.

## Why not rely on local setup alone

While it is possible to configure everything manually on a local machine, that approach does not scale well as the project grows or as contributors change.

Manual setup tends to drift over time, even with good documentation. Devcontainers reduce that drift by making the environment **executable documentation**.

If the devcontainer builds, the environment is valid.

## Using the devcontainer

Using the devcontainer is recommended but not strictly required.

Contributors who choose not to use it are expected to match the same tool versions and behaviors defined by the repository configuration. The devcontainer exists to make that expectation easy to meet.
