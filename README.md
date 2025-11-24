# **Automation Onboarding Platform**

### **Self-Service Ephemeral Sandbox Environments for Dev Teams**

This project is a fully automated *“on-demand sandbox environment generator”* built inside a homelab.
It automatically provisions isolated development environments whenever a new project branch is pushed, using Terraform, Docker, and a self-hosted GitHub Actions runner.

It’s designed to solve a common startup problem:

> **Spinning up new dev/test environments is slow, inconsistent, and manual.**
> Engineers waste hours provisioning infrastructure, debugging configs, and cleaning up old environments.

This platform makes environments **instant, consistent, disposable, and automated**.

---

# **✨ What This System Does**

### 1. Creates a full sandbox environment from a single GitHub branch

When a developer creates a branch like:

```
project/feature-analytics
```

GitHub Actions automatically:

* derives the environment name
* builds the sample app container
* provisions a sandbox using Terraform
* launches:

  * `sandbox-feature-analytics` Docker network
  * `db-feature-analytics` Postgres container
  * `app-feature-analytics` Go application container
* exposes the application on a dynamic host port
* prints the URL in the GitHub Actions logs

### 2. Each sandbox is fully isolated

Every environment gets its own:

* App container
* Database container
* Custom Docker network
* Environment variables
* Unique runtime port

No conflicts. No collisions. No waiting.

### 3. Runs entirely on a **self-hosted GitHub Actions runner**

The entire flow runs inside a:

* Vagrant + VMware Fusion ARM64 VM
* Self-managed CI/CD runner
* With Docker + Terraform installed

This closely mirrors how platform engineering teams operate internal infrastructure.

### 4. Clean teardown workflow (manual or future-automated)

Each environment can be removed with:

```bash
terraform destroy -auto-approve -var="env_name=<env>"
```

A nightly or branch-deletion cleanup pipeline can be added easily.

---

# ** System Architecture**

```
GitHub Branch Push (project/*)
            │
            ▼
GitHub Actions Workflow (Provision Sandbox)
            │
Self-Hosted Runner (Ubuntu ARM64 VM)
            │
            ▼
Terraform (Docker Provider)
            │
            ▼
Docker Engine
 ├─ sandbox-<env> network
 ├─ db-<env> (Postgres)
 └─ app-<env> (Go API)
```

---

# ** Project Structure**

```
automation-onboarding/
│
├── app/                     # Go HTTP service (sample app)
│   ├── main.go
│   └── go.mod
│
├── docker/
│   └── Dockerfile           # Multi-stage build for app container
│
├── infra/
│   └── terraform/           # Terraform IaC for ephemeral envs
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── .github/
│   └── workflows/
│       ├── provision-env.yml     # Spins up sandbox envs on branch push
│       └── selfhosted-test.yml   # Confirms self-hosted runner is working
│
└── README.md
```

---

# ** How It Works (Step-By-Step)**

## **1. Developer creates a new branch**

```
git checkout -b project/new-feature
git push -u origin project/new-feature
```

## **2. GitHub Actions triggers automatically**

Matched by:

```yaml
on:
  push:
    branches:
      - 'project/*'
```

## **3. Workflow runs on the self-hosted runner**

This VM contains:

* Docker
* Terraform
* The sample Go build
* The entire Terraform provisioning toolchain

## **4. Terraform provisions the sandbox**

Terraform creates:

* Docker network: `sandbox-<env>`
* Database container: `db-<env>`
* Application container: `app-<env>`

Example:

```
sandbox-new-feature
├── app-new-feature
└── db-new-feature
```

## **5. Workflow extracts the host port and prints the URL**

GitHub Actions uses Docker inspect to determine the assigned host port, then outputs:

```
Sandbox Name: project-new-feature
App Running At: http://localhost:32770
```

## **6. Developer can immediately use the environment**

Inside the homelab VM:

```bash
curl http://localhost:32770
```

→

```
Hello from sandbox environment: project-new-feature
```

---

# ** Local Testing**

Inside the VM:

### **Build app**

```bash
docker build -t sandbox-app:local -f docker/Dockerfile .
```

### **Run app**

```bash
docker run -d -p 8080:8080 --name api-test sandbox-app:local
curl http://localhost:8080
```

---

# ** Manual Teardown**

From the Terraform directory:

```bash
cd infra/terraform
terraform destroy -auto-approve -var="env_name=<your-env>"
```

Example:

```bash
terraform destroy -auto-approve -var="env_name=project-new-feature"
```

---

# ** Technologies Used**

* **GitHub Actions (Self-Hosted Runner)**
* **Terraform (Docker Provider)**
* **Docker Engine**
* **Go (sample app)**
* **Ubuntu ARM64**
* **Vagrant + VMware Fusion homelab**

This stack models a real startup DevOps setup, where ephemeral environments are a key part of productivity.

---

# ** Why This Project Matters (Portfolio Narrative)**

This project demonstrates:

* Infrastructure-as-Code design
* Ephemeral environment provisioning
* CI/CD automation
* GitOps workflow patterns
* Terraform state management
* Container orchestration
* Self-hosted runner operation
* DevOps debugging + platform engineering skills
* Homelab → production-simulated workflow

This is production-level platform automation — just running on your own hardware.

---

# ** Future Enhancements**

* [ ] Auto-teardown on branch deletion
* [ ] Slack notifications with sandbox URLs
* [ ] TTL-based cleanup (24h auto-destroy)
* [ ] Add labeling/tagging for better metadata
* [ ] Add test suites to confirm app health
* [ ] Add load testing or synthetic checks
* [ ] Add a small UI dashboard for active sandboxes

---

# **🧑‍💻 Author**

**Desiree’ Weston**
Cloud & DevOps Engineer
Building AI + Cloud projects, sharing the journey, and documenting everything in my homelab.


