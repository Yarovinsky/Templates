# Product Definition

## Product Overview

**Product Name:** TaskFlow — Team Task Management API

**Tagline:** A simple, reliable REST API for managing tasks and projects within a team.

**Problem Statement:**
Teams working across multiple tools lose track of who owns what, when things are due, and what the current status of a task is. A lightweight, well-structured task management API gives teams a single source of truth that integrates easily with any frontend or automation tooling.

**Vision:**
A RESTful backend service that allows users to register, authenticate, create and manage tasks, organise them into projects, and assign them to team members — all enforced through rigorous validation and covered by a comprehensive automated test suite.

---

## Target Users

| Persona | Description |
|---------|-------------|
| **The Developer** | Builds integrations against the API, writes client-side tooling, needs predictable response shapes and clear error messages. |
| **The Team Lead** | Creates projects, assigns tasks to team members, tracks progress via status updates. |
| **The Team Member** | Receives assigned tasks, updates task status, adds comments and attachments. |

---

## Core Features (MVP)

| # | Feature | Priority |
|---|---------|----------|
| 1 | User registration and authentication (JWT) | 🔴 MVP |
| 2 | User login and token refresh | 🔴 MVP |
| 3 | Task creation with title, description, due date, and priority | 🔴 MVP |
| 4 | Task listing with filtering (status, assignee, due date) | 🔴 MVP |
| 5 | Task update (status, description, priority, due date) | 🔴 MVP |
| 6 | Task deletion (soft delete — archived, not purged) | 🔴 MVP |
| 7 | Project creation and task grouping under a project | 🟡 MVP+ |
| 8 | Task assignment to a team member | 🟡 MVP+ |
| 9 | Comment thread on a task | 🟢 Post-MVP |
| 10 | File attachment on a task | 🟢 Post-MVP |
| 11 | Activity audit log per task | 🟢 Post-MVP |
| 12 | Email notifications on assignment or due-date approach | 🟢 Post-MVP |

---

## User Stories (Backlog Seed)

> These are high-level stories. Each is expanded into a full story file in `stories/`.

1. **As a new user**, I want to register with my email and password, so that I can create a TaskFlow account.
2. **As a registered user**, I want to log in and receive a JWT, so that I can make authenticated API calls.
3. **As a team member**, I want to create a task with a title, description, and due date, so that I can track a piece of work.
4. **As a team member**, I want to list my tasks filtered by status, so that I can see what is in progress or overdue.
5. **As a team member**, I want to update the status of a task (Todo → In Progress → Done), so that the team knows where things stand.
6. **As a team member**, I want to delete (archive) a task I own, so that my task list stays clean.

---

## Out of Scope (Never Implement Unless a Story Explicitly Adds It)

- ❌ Real-time push notifications (WebSockets)
- ❌ OAuth / social login (Google, GitHub, etc.)
- ❌ Billing or subscription management
- ❌ File storage integration (S3 or equivalent)
- ❌ Mobile clients or frontend UI
- ❌ Multi-tenancy / organisation isolation at the database level
- ❌ Calendar or time-tracking integrations

---

## Acceptance Criteria (Production-Ready)

The system is considered production-ready when all of the following are met:

1. All MVP endpoints return correct HTTP status codes under all documented scenarios.
2. All inputs are validated; invalid inputs return structured `422` error responses.
3. Authentication is enforced on all protected routes; unauthenticated requests return `401`.
4. Authorisation is enforced; users cannot read or mutate tasks they do not own (returns `403`).
5. Test suite passes with zero failures and zero skipped tests.

---

## API Response Conventions

All error responses follow this shape:

```json
{
  "error": "Human-readable summary",
  "details": [
    { "field": "email", "message": "Must be a valid email address" }
  ]
}
```

Success responses return the resource object directly (no wrapper envelope).
