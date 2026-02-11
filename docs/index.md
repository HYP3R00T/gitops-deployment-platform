# GitOps Deployment Platform

**A platform-agnostic delivery system for safe, observable, and deterministic software deployment.**

This project is building the architectural patterns of modern platform engineering: **GitOps reconciliation, immutable infrastructure, and automated recovery**. It serves as a reference implementation for how systems should be deployed and managed, regardless of the underlying cloud provider or tooling.

???+ info "Target Vision"
    The system is designed to deploy, fail, and recover deterministically without manual intervention.

## 🗺️ Documentation Map

The documentation is organized by domain, separating _interface_ from _implementation_.

### 1. Developer Experience (DX)

_For contributors and engineers setting up the local environment._

- **What's inside:** Setup guides for the reproducible local toolchain, containerized development environments, and workflow automation.
- **Go here if:** You want to run this project locally with zero configuration drift.

### 2. Platform & Infrastructure

_For DevOps and Cloud Engineers._

- **What's inside:** Infrastructure as Code (IaC) modules, state management, and local Kubernetes environment. GitOps reconciliation and cloud deployment in progress.
- **Go here if:** You want to understand how infrastructure is provisioned and managed.

### 3. Service Specifications

_For Application Developers._

- **What's inside:** Specifications for the **Backend API Service** (providing health checks and metadata) and the **Frontend Web Service** (displaying platform status).
- **Go here if:** You want to understand the workload contracts and service interfaces.

### 4. Thinking & Journey

_For Engineering Managers and Interviewers._

- **What's inside:** The narrative history. Architecture Decision Records (ADRs), project objectives, and development philosophy.
- **Go here if:** You want to understand the _decisions_ and _trade-offs_ behind the architecture.

## 📖 Key Concepts

- [Core Objectives](thinking/core-objectives.md) — The three foundational pillars of this project
- [Safe-to-Fail Narrative](thinking/safe-to-fail-narrative.md) — How the system handles failure gracefully
- [Architecture](platform/architecture.md) — The architectural patterns being implemented
- [Intentional Constraints](thinking/constraints.md) — What this project deliberately does NOT include
