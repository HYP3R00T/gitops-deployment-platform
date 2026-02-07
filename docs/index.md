# GitOps Deployment Platform

**A platform-agnostic delivery system for safe, observable, and deterministic software deployment.**

This project demonstrates the architectural patterns of modern platform engineering: **GitOps reconciliation, immutable infrastructure, and automated recovery**. It serves as a reference implementation for how systems should be deployed and managed, regardless of the underlying cloud provider or tooling.

> **Core Philosophy:** "The system must deploy, fail, and recover deterministically without manual intervention."

## What is This Project?

The **GitOps Deployment Platform** is a high-signal engineering project that treats **deployment infrastructure as the primary product**. Rather than focusing on application features, this project demonstrates advanced **DevOps and Automation** competencies through a production-grade, "safe-to-fail" environment.

The goal is to showcase **engineering judgment** over simple tool usage, moving code from a developer's machine to the cloud through a series of automated, governed guardrails.

### Core Objectives

This project is built on three foundational pillars:

- **Operational Governance:** Establishing a "sacred" main branch where no code enters without passing pre-commit hooks, conventional commit validation, and automated CI gating.
- **Declarative Infrastructure:** Ensuring that 100% of the cloud environment is defined as code in modular, version-controlled configurations.
- **GitOps Delivery:** Using reconciliation controllers to sync cluster state with Git, enabling automated rollouts and—more importantly—**automated rollbacks** when the system detects an unhealthy state.

## The "Safe-to-Fail" Narrative

Unlike standard portfolio projects that only show a "happy path," this system is designed to handle failure gracefully. A key demonstration objective is a **controlled failure scenario**:

1. A developer pushes a commit that intentionally breaks a service health check.
2. The CI/CD pipeline builds the image and updates the GitOps manifest.
3. The reconciliation controller detects the unhealthy deployment and automatically halts or reverts the change.
4. The system restores itself to the last known-good state without manual intervention.

This demonstrates that the platform doesn't just deploy—it **validates, reacts, and recovers**.

## 🗺️ Documentation Map

The documentation is organized by domain, separating *interface* from *implementation*.

### 1. Developer Experience (DX)

*For contributors and engineers setting up the local environment.*

- **What's inside:** Setup guides for the reproducible local toolchain, containerized development environments, and branching standards.
- **Go here if:** You want to run this project locally with zero configuration drift.

### 2. Platform & Infrastructure

*For DevOps and Cloud Engineers.*

- **What's inside:** The core delivery machinery. Details on **Infrastructure as Code (IaC)** design, **GitOps** reconciliation strategies, and **CI pipeline** architecture.
- **Go here if:** You want to understand how the platform provisions resources and syncs state from Git.

### 3. Service Specifications

*For Application Developers.*

- **What's inside:** Specifications for the **Backend Service** (acting as a deployment probe) and the **Frontend Service** (acting as the operational status surface).
- **Go here if:** You want to understand the workloads and health contracts required by the platform.

### 4. Thinking & Journey

*For Engineering Managers and Interviewers.*

- **What's inside:** The narrative history. Architecture Decision Records (ADRs), iterative journey logs, and post-mortem analysis of failures.
- **Go here if:** You want to understand the *decisions* and *trade-offs* behind the architecture.

## 🏗️ System Architecture (Target Patterns)

The platform implements the following architectural patterns, designed to be swappable and portable:

| Category | Tools & Standards | Objective |
| -------- | ----------------- | --------- |
| **Cloud Platform** | AWS (EKS, VPC, IAM, CloudWatch) | Demonstrate enterprise-grade cloud resource management. |
| **Infrastructure** | Terraform, modular IaC patterns | Remove manual provisioning in favor of code-driven state. |
| **Automation** | GitHub Actions, Argo CD | Enable zero-touch deployment with automated reconciliation. |
| **Runtime** | Managed Kubernetes (EKS) | Leverage standard APIs for portability and stability. |
| **Artifacts** | Docker, Container Registry | Build immutable, versioned deployment units. |
| **Tooling** | `uv`, `mise`, Python 3.14+ | Ensure high-performance, modern toolchains for consistency. |
| **Governance** | Pre-commit, Commitizen, Dependabot | Shift-left quality checks and maintain supply chain security. |
| **Observability** | Health checks, semantic metadata | Allow the platform to validate its own deployment state. |

## 🛡️ Intentional Constraints

This project defines success by what it **refuses** to do. To maintain sharp focus on DevOps maturity, the following are intentionally excluded:

### What the Platform Does NOT Include

- **No Imperative Deployments:** Direct cluster manipulation (e.g., `kubectl apply`) is forbidden in CI/CD. All changes flow through GitOps reconciliation.
- **No Persistent Databases:** The services are stateless to focus on deployment mechanics, not application complexity.
- **No User Authentication:** No "product" features are built to avoid distracting from the infrastructure narrative.
- **No Complex Frontends:** The UI exists solely as an **operational status surface** to visualize version metadata and health.
- **No Hidden Dependencies:** All tools and versions are pinned and explicit in version-controlled manifests.
- **No Vendor Lock-in (Logic):** While specific providers are used (AWS, Terraform, Argo CD), the architectural *patterns* remain portable.

## 🚀 Status

- **Current Phase:** Scaffolding & Foundation (Iteration 0-1)
- **Next Milestone:** GitOps Pipeline Integration (Iteration 2)

*Everything in this project is designed to be understandable, reproducible, and disposable. That is not a limitation—it is the core design goal.*
