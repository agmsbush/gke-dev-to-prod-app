#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

read -p 'GitHub Token: ' token

echo -n "${token}" > .app-github-api-token || true

read -p 'GitHub Username: ' username

export GITHUB_USERNAME="${username}"

cat <<EOF > hub
github.com:
  - protocol: https
    user: ${GITHUB_USERNAME}
    oauth_token: $(cat .app-github-api-token)
EOF

HUB_CONFIG="${PWD}/hub"

gcloud kms keyrings create gke-flask-app --location=global || true

gcloud kms keys create github --location=global --keyring=gke-flask-app --purpose=encryption || true

gcloud kms encrypt \
   --plaintext-file "${HUB_CONFIG}" \
   --ciphertext-file hub.enc \
   --location=global \
   --keyring=gke-flask-app \
   --key=github 

PROJECT_ID=$(gcloud config get-value core/project)

gsutil mb gs://${PROJECT_ID}-gke-flask-app || true 

gsutil cp hub.enc gs://${PROJECT_ID}-gke-flask-app || true

PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format='value(projectNumber)')

gcloud kms keys add-iam-policy-binding github \
  --location=global \
  --keyring=gke-flask-app \
  --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
  --role=roles/cloudkms.cryptoKeyEncrypterDecrypter || true

rm hub && rm hub.enc && rm .app-github-api-token