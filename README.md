# gke-dev-to-prod-app

## Overview

This is an example dev-to-prod workflow for an containerized Kubernetes application.

The workflow consists of three repositories in GitHub:

- gke-dev-to-prod-blueprints
    - *Owned by: Platform*
        - Kubernetes base resource manifests
        - Kustomization for production Kubernetes manifests

- gke-dev-to-prod-app
    - *Owned by: Developers*
        - Python Flask app
        - Unit tests

    - *Supplied by: Platform, Owned by: Developers*
        - Procfile with Flask entrypoint
        - Kustomization pointing to upstream blueprint K8s yaml
        - Skaffold config for Kubernetes deployment, with profiles for dev and prod
        - Cloud Build config for Test Runners
        - Cloud Build config for Continuous Integration

- gke-dev-to-prod-env
    - *Owned by: Platform*
        - Cloud Build for Deployment
        - Hydrated/Rendered Kubernetes Manifests in candidate branches
        - Hydrated/Rendered and Applied Kubernetes Manifests in master branch


The workflow is as follows:

### Development

- Developer develops code locally on a feature branch for `gke-dev-to-prod-app`.

- Developers can run `skaffold dev -p dev` to iteratively develop their app with a dev Kubernetes environment.

- Developers can utilize Cloud Code in IDE to access dev service in dev Kubernetes environment.

- Developer pushes feature branch code to remote.

- Developer opens a PR to master branch.

- Cloud Build triggers a build to run unit tests, with results updated in PR.

### Code Review

- Owner or approver will review PR and merge into master.

### Continuous Integration

- Cloud Build triggers a build to build and tag a Docker image using Buildpacks, push it to Container Registry, and render the Kubernetes YAML for deployment.

- Cloud Build will then update the `gke-dev-to-prod-env` repo with the rendered Kubernetes YAML in a new candidate branch.

### Deployment 

- Owner or approver will open and review PR from candidate branch and merge into master. 

- Cloud Build triggers a build to use `gke-deploy` to apply rendered YAML to prod environment.

## Tools 

- GitHub
- Secrets Manager
- Cloud Code
- Skaffold
- Cloud Native Buildpacks
- Kustomize
- Cloud Build
- GKE

## TODO

- Add .gcloudignore file to limit what triggers builds
