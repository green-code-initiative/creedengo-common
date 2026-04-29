# Creedengo — User Guide

- [Creedengo — User Guide](#creedengo--user-guide)
  - [Introduction](#introduction)
    - [What is creedengo?](#what-is-creedengo)
    - [Who is this guide for?](#who-is-this-guide-for)
    - [Prerequisites](#prerequisites)
  - [Installing creedengo plugins on SonarQube](#installing-creedengo-plugins-on-sonarqube)
    - [Method 1 — Via the SonarQube Marketplace (recommended)](#method-1--via-the-sonarqube-marketplace-recommended)
    - [Method 2 — Via manual upload (air-gapped instances)](#method-2--via-manual-upload-air-gapped-instances)
    - [Verifying the installation](#verifying-the-installation)
  - [Creating a creedengo Quality Profile (via inheritance)](#creating-a-creedengo-quality-profile-via-inheritance)
    - [Why use inheritance?](#why-use-inheritance)
    - [Step-by-step: extend an existing profile](#step-by-step-extend-an-existing-profile)
    - [Activate eco-design rules in bulk](#activate-eco-design-rules-in-bulk)
    - [Assign the profile to your projects](#assign-the-profile-to-your-projects)
  - [Smooth update process (non-breaking rollout)](#smooth-update-process-non-breaking-rollout)
    - [Principles](#principles)
    - [Step 0 — Baseline: observe without any impact](#step-0--baseline-observe-without-any-impact)
    - [Step 1 — Internal severity promotion process](#step-1--internal-severity-promotion-process)
    - [Step 2 — Tiered Quality Profiles and Quality Gates](#step-2--tiered-quality-profiles-and-quality-gates)
    - [Updating the plugin version](#updating-the-plugin-version)
  - [Observability of eco-design metrics](#observability-of-eco-design-metrics)
    - [Browsing issues via the SonarQube UI](#browsing-issues-via-the-sonarqube-ui)
    - [Tracking the trend over time](#tracking-the-trend-over-time)
    - [Querying metrics via the SonarQube API](#querying-metrics-via-the-sonarqube-api)
      - [List all open eco-design issues (across all projects)](#list-all-open-eco-design-issues-across-all-projects)
      - [List eco-design issues for a specific project](#list-eco-design-issues-for-a-specific-project)
      - [Count open eco-design issues per project (aggregated)](#count-open-eco-design-issues-per-project-aggregated)
      - [List eco-design issues on new code only](#list-eco-design-issues-on-new-code-only)

---

## Introduction

### What is creedengo?

**Creedengo** is an open-source collection of SonarQube plugins that bring eco-design rules to your static analysis pipeline. These rules help development teams identify and reduce the environmental footprint of their code (CPU usage, memory allocation, unnecessary network calls, inefficient algorithms, etc.).

Creedengo rules are available for multiple languages: Java, Python, PHP, JavaScript/TypeScript, C#, Android, iOS and more.

All creedengo rules are tagged `creedengo` and `eco-design` inside SonarQube, making them easy to filter and track separately from standard quality rules.

> For the full list of available repositories and language plugins, see: <https://github.com/orgs/green-code-initiative/repositories?type=all>

### Who is this guide for?

This guide targets:

- **SonarQube administrators** who need to install and configure creedengo plugins
- **Tech leads / DevOps engineers** who want to integrate eco-design rules into their CI/CD pipelines progressively
- **Engineering managers** who need visibility on eco-design metrics across projects

> If you are a **developer** looking to contribute a new rule or set up a local development environment, please refer to [starter-pack.md](starter-pack.md) and [HOWTO.md](HOWTO.md) instead.

### Prerequisites

| Requirement | Details |
|---|---|
| SonarQube instance | Community Edition or higher, version 9.x / 10.x |
| Admin access | `Administer` global permission on SonarQube |
| Internet access | Required for Marketplace installation (Method 1 only) |

---

## Installing creedengo plugins on SonarQube

### Method 1 — Via the SonarQube Marketplace (recommended)

This is the easiest method and works for any SonarQube instance with outbound internet access.

1. Log in to SonarQube as an administrator.
2. Go to **Administration** → **Marketplace**.
3. In the search bar, type `creedengo`.
4. Locate the plugin for the language you need (e.g., `creedengo-java`) and click **Install**.
5. Repeat for each language plugin you want to enable.
6. Once all desired plugins are installed, click **Restart Server** when prompted.

> SonarQube must be restarted for the plugins to be loaded. Plan a maintenance window if needed.

After the restart, the new rules are available immediately in the **Rules** catalog.

### Method 2 — Via manual upload (air-gapped instances)

For SonarQube instances that cannot reach the internet, you can install plugins manually by dropping JAR files directly into the SonarQube extensions directory.

1. On a machine with internet access, download the latest plugin JAR(s) from the GitHub Releases page of the desired plugin.
   - Example for Java: <https://github.com/green-code-initiative/creedengo-java/releases>
2. Copy the downloaded `.jar` file(s) to the SonarQube server, inside the `extensions/plugins/` directory.
   ```
   $SONARQUBE_HOME/extensions/plugins/creedengo-java-<version>.jar
   ```
3. Restart the SonarQube server:
   ```sh
   # Example with systemd
   sudo systemctl restart sonarqube

   # Example with the bundled start script
   $SONARQUBE_HOME/bin/<OS>/sonar.sh restart
   ```

> Do **not** install multiple versions of the same plugin simultaneously. Remove the old JAR before adding the new one.

### Verifying the installation

After the server restarts, verify that the plugins loaded correctly:

1. Go to **Administration** → **Marketplace** → **Installed** tab.
2. Confirm that the creedengo plugin(s) appear with the expected version number.

You can also verify that the rules are available:

1. Go to **Rules**.
2. In the **Tag** filter, select `creedengo` or `eco-design`.
3. The list should display all creedengo rules for each installed language plugin.

---

## Creating a creedengo Quality Profile (via inheritance)

### Why use inheritance?

SonarQube Quality Profiles support **inheritance**: a child profile extends a parent profile and automatically inherits any future rule activations done in the parent.

Using inheritance for creedengo is the **recommended approach** because:

- Your team still benefits from all standard rules defined in the parent profile (e.g., *Sonar Way* or your own quality profile).
- Sonar Way rule updates from SonarQube upgrades are automatically inherited — you do not need to recreate your profile.
- Creedengo-specific rules are managed independently in the child profile, making it easy to activate or deactivate them without affecting the base configuration.
- but you won't be able to disable inherited rules immediately if you want a clean slate.

But if you prefer, you can use the **Copy** method to create a standalone profile. The downside is that you will need to manually replicate any future updates from the parent profile. The only advantage is that you can deactivate inherited rules immediately if you want a clean slate.

### Step-by-step: extend an existing profile

1. Go to **Quality Profiles**.
2. Select the language you want to configure (e.g., **Java**).
3. Find the profile you want to extend as a parent (typically **Sonar Way**).
4. Click the burger icon next to the profile and choose "extend".
5. Name the new profile , for example:
   ```
   parentname + "-" + "creedengo" + "-" + language
   ```
6. Click **Extend**.

The new profile now inherits all rules from parent and is ready to receive creedengo-specific rules.

### Activate eco-design rules in bulk

Once the child profile is created:

1. Go to **Quality Profiles** → select your new profile.
2. Click **Activate More Rules**.
3. In the **Tag** filter, type and select `creedengo` or `eco-design`.
4. The list shows all available creedengo rules for this language.
5. Click **Bulk Activate** (top right of the rules list) to activate all displayed rules → confirm.

All eco-design rules are now activated in your profile.

> You can review each rule individually later and deactivate specific ones that are not relevant to your codebase (e.g., mobile-specific rules on a backend project).

### Assign the profile to your projects

You have two options:

**Option A — Set as default for the language**

This applies the profile to all projects of that language that do not have a specific profile assigned.

1. Go to **Quality Profiles** → select your new profile.
2. Click the burger icon → **Set as Default**.

> Use this option carefully in production: it will affect all projects without a specific profile override.

**Option B — Assign to specific projects (recommended for progressive rollout)**

1. Go to **Quality Profiles** → select your new profile.
2. Click **Projects** tab.
3. Click **Add Project** and select the project(s) you want to apply the profile to.

This allows you to roll out eco-design analysis project by project, at your own pace.

---

## Smooth update process (non-breaking rollout)

### Principles

All creedengo rules ship with a **Minor** severity by default. In a standard SonarQube Quality Gate, Minor issues do not trigger a build failure — they are reported as informational findings. This means that simply installing the plugin and activating the rules **will not break any existing pipeline**.

The gradual rollout strategy therefore does not rely on SonarQube's warning/error gate mechanics, but on two complementary levers:

1. **Rule severity promotion** — an internal team decision process to identify which creedengo rules are relevant and should be promoted to a higher severity (Major, Critical, Blocker), making them progressively blocking through the Quality Gate.
2. **Tiered Quality Profiles and Quality Gates** — creating profiles and gates of increasing strictness, and migrating projects to them as fixes are applied.

### Step 0 — Baseline: observe without any impact

After assigning the creedengo Quality Profile to a project (see [Creating a creedengo Quality Profile](#creating-a-creedengo-quality-profile-via-inheritance)), trigger a first analysis.

1. Run a standard SonarQube scan on the project.
2. Go to the project's **Issues** page and filter by **Tag: creedengo** or **Tag: eco-design**.
3. Review the findings — all issues appear as Minor and do not affect the Quality Gate status.
4. Record the total count per rule. This is your **baseline** and will guide the severity promotion decisions.

> At this stage, no pipeline is broken and no developer is forced to fix anything. The goal is visibility only.

### Step 1 — Internal severity promotion process

Transforming creedengo findings into blocking violations requires a deliberate decision within your organisation. The recommended process:

1. **Review the baseline** with the engineering team and, if applicable, a green-code champion or sustainability lead.
2. **Select a first set of rules** to promote — prioritise rules that are:
   - Easy to fix (low remediation cost)
   - High-impact (related to loops, I/O, or network usage)
   - Already well understood by the teams
3. **Change the severity** of selected rules inside your new Quality Profile:
   - Go to **Quality Profiles** → select your new profile.
   - Find the rule → click the severity badge → change it to **Major**, **Critical**, or **Blocker**.
4. **Communicate the change** to development teams before the next analysis cycle, so they can address violations proactively.
5. **Iterate** — repeat this process quarterly (or at your own cadence) to extend coverage progressively.

> Do not promote all rules at once. A phased approach reduces friction and gives teams time to build eco-design habits.

### Step 2 — Tiered Quality Profiles and Quality Gates

A complementary approach is to define **multiple tiers** of Quality Profiles and Quality Gates with increasing strictness, and to migrate projects from one tier to the next as their eco-design debt is reduced.

**Example tier structure:**

| Tier | Quality Profile | Quality Gate | Description |
|---|---|---|---|
| Tier 0 | `creedengo-java` (all Minor) | Standard gate | Observe only, no eco-design blocking |
| Tier 1 | `creedengo-java-tier1` (a few Major rules) | Gate with `Major issues > 0` on new code | Basic enforcement on new code |
| Tier 2 | `creedengo-java-tier2` (more Major + some Critical) | Gate with `Major + Critical > 0` on new code | Stricter enforcement on new code |
| Tier 3 | `creedengo-java-tier3` (full promotion) | Gate enforcing overall issue count | Full eco-design compliance |

**How to implement:**

1. Create a new Quality Profile as a copy of the previous tier (see [Step-by-step: extend an existing profile](#step-by-step-extend-an-existing-profile)).
2. In the new profile, promote the severity of the additional rules selected in the internal process.
3. Create (or clone) a corresponding Quality Gate with stricter conditions on those higher-severity issues.
4. Assign the new profile and gate to projects that have cleared their Tier N debt.

> Projects move through tiers at their own pace. A project that has no Major eco-design issues can be moved to Tier 1; once its Tier 1 debt is cleared, it moves to Tier 2, and so on.

### Updating the plugin version

When a new version of a creedengo plugin is released, it may introduce new rules. These new rules arrive with Minor severity and are therefore non-blocking by default.

1. Install the new plugin version (see [Installing creedengo plugins](#installing-creedengo-plugins-on-sonarqube)).
2. In each of your new Quality Profiles, bulk activate the new `eco-design` rules — they appear as `Inactive` after a plugin upgrade.
3. Include the new rules in your next internal severity promotion review before promoting any of them to Major or above.

> New rules should always go through the same internal review process before becoming blocking. Never promote a rule you have not yet measured the impact of.

---

## Observability of eco-design metrics

### Browsing issues via the SonarQube UI

The most direct way to see all eco-design violations is through the **Issues** view:

1. Go to **Issues** (top navigation bar).
2. In the left-hand filter panel, scroll to **Tag** and select `creedengo` or `eco-design`.
3. Use additional filters to refine:
   - **Project**: narrow to a specific project or portfolio
   - **Language**: filter by language (Java, Python, etc.)
   - **Severity**: focus on Blocker / Critical issues first
   - **Status**: filter by Open, Confirmed, etc.
4. The resulting list shows all open eco-design violations across your SonarQube instance.

To view eco-design issues for a **single project**:

1. Open the project from the **Projects** page.
2. Go to the **Issues** tab.
3. Apply the **Tag: creedengo** or **Tag: eco-design** filter.

### Tracking the trend over time

For each project, SonarQube tracks metric history on every analysis. To view the eco-design trend:

1. Open a project.
2. Go to the **Activity** tab.
3. In the **Measures** section, add the metric **Issues**.
4. The graph shows how the total number of issues evolved over time — including eco-design issues.

Use this view during sprint reviews or quarterly eco-design reviews to demonstrate progress (or identify regressions).

### Querying metrics via the SonarQube API

The SonarQube REST API allows you to extract eco-design metrics programmatically for integration into external dashboards (Grafana, Power BI, custom reports, etc.).

**Base URL**: `http://<SONARQUBE_HOST>/api`

**Authentication**: use a user token (generate one from `My Account → Security → Generate Tokens`).

#### List all open eco-design issues (across all projects)

```sh
curl -u <YOUR_TOKEN>: \
  "http://<SONARQUBE_HOST>/api/issues/search?tags=eco-design&statuses=OPEN&ps=500"
```

#### List eco-design issues for a specific project

```sh
curl -u <YOUR_TOKEN>: \
  "http://<SONARQUBE_HOST>/api/issues/search?tags=eco-design&componentKeys=<PROJECT_KEY>&statuses=OPEN&ps=500"
```

#### Count open eco-design issues per project (aggregated)

```sh
curl -u <YOUR_TOKEN>: \
  "http://<SONARQUBE_HOST>/api/issues/search?tags=eco-design&statuses=OPEN&ps=0&facets=projects"
```

The `facets=projects` parameter returns a breakdown of issue counts by project in the response.

#### List eco-design issues on new code only

```sh
curl -u <YOUR_TOKEN>: \
  "http://<SONARQUBE_HOST>/api/issues/search?tags=eco-design&statuses=OPEN&sinceLeakPeriod=true&componentKeys=<PROJECT_KEY>"
```

> **Pagination**: the API returns a maximum of 500 results per page (`ps=500`). For large codebases, use the `p` parameter to paginate: `&p=2`, `&p=3`, etc. Check the `total` field in the response to know the full count.

**Response example (excerpt)**:

```json
{
  "total": 42,
  "issues": [
    {
      "key": "AXz...",
      "rule": "creedengo-java:EC1",
      "severity": "MINOR",
      "component": "my-project:src/main/java/MyClass.java",
      "line": 34,
      "message": "Avoid using System.out.println in production code",
      "tags": ["eco-design"],
      "status": "OPEN"
    }
  ]
}
```

> For the full API reference, see the built-in documentation of your SonarQube instance at: `http://<SONARQUBE_HOST>/web_api`
