# GitOps Deployment Platform

**A platform-agnostic delivery system for safe, observable, and deterministic software deployment.**

This project demonstrates the architectural patterns of modern platform engineering: **GitOps reconciliation, immutable infrastructure, and automated recovery**. It serves as a reference implementation for how systems should be deployed and managed, regardless of the underlying cloud provider or tooling.

> **Core Philosophy:** "The system must deploy, fail, and recover deterministically without manual intervention."

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

## 📖 Key Concepts

- [Core Objectives](../thinking/core-objectives.md) — The three foundational pillars of this project
- [Safe-to-Fail Narrative](../thinking/safe-to-fail-narrative.md) — How the system handles failure gracefully
- [Architecture](../platform/architecture.md) — The architectural patterns being implemented
- [Intentional Constraints](../thinking/constraints.md) — What this project deliberately does NOT include
