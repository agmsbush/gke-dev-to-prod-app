# gke-dev-to-prod-app

## Overview

This is an example dev-to-prod workflow for an containerized Kubernetes application.

The workflow consists of two repositories in GitHub:
- gke-dev-to-prod-app
- gke-dev-to-prod-env

The workflow is as follows:
- Developer develops code locally on a feature branch for `gke-dev-to-prod-app`.

- TODO: Developer will use Skaffold  in dev mode with development Kubernetes environment (minikube, KIND, remote GKE, k3s, etc.).

- Developer pushes feature branch code to remote.

- Developer opens a PR to master branch.

- Cloud Build triggers a build to run unit tests, with results updated in PR.

- Approver will review PR and merge into master.

- Cloud Build triggers a build to build and tag a Docker image, push it to Container Registry, update Kustomize resources with new image tags and render the YAML for prod.

- Cloud Build will then update the `gke-dev-to-prod-env` repo with the rendered YAML in a new candidate branch.

- Approver will review PR and merge into master. 

- Cloud Build triggers a build to use gke-deploy to apply rendered YAML to prod environment.