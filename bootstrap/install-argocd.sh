#!/usr/bin/env bash
set -euo pipefail

echo "==> Creating argocd namespace (idempotent)"
kubectl apply -f "$(dirname "$0")/../argocd/namespace.yaml"

echo "==> Installing ArgoCD (idempotent)"
kubectl apply -n argocd -f "$(dirname "$0")/../argocd/install.yaml"

echo "==> Waiting for ArgoCD server to be Ready"
kubectl rollout status deploy/argocd-server -n argocd --timeout=10m

echo "==> Applying root App-of-Apps"
kubectl apply -f "$(dirname "$0")/../argocd/root-app.yaml"

echo "==> Done. ArgoCD will now reconcile cluster state from Git."