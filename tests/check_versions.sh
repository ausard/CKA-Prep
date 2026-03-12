#!/usr/bin/env bash
# tests/check_versions.sh - Verify version consistency across provisioning scripts
set -euo pipefail

FAILED=0
CHECKS=0

pass() { CHECKS=$((CHECKS + 1)); echo "  PASS: $1"; }
fail() { CHECKS=$((CHECKS + 1)); FAILED=$((FAILED + 1)); echo "  FAIL: $1"; }

# ──────────────────────────────────────────────
# 1. Kubernetes version must match across files
# ──────────────────────────────────────────────
echo "=== Kubernetes version consistency ==="

MASTER_KUBE=$(grep -oP '^KUBE_VERSION=\K[0-9.]+' master.sh || true)
WORKER_KUBE=$(grep -oP '^KUBE_VERSION=\K[0-9.]+' worker.sh || true)
MINIKUBE_KUBE=$(grep -oP 'kubernetes-version=v\K[0-9.]+' minikube.sh || true)

if [ -z "$MASTER_KUBE" ]; then
  fail "Could not extract KUBE_VERSION from master.sh"
else
  pass "master.sh KUBE_VERSION=$MASTER_KUBE"
fi

if [ -z "$WORKER_KUBE" ]; then
  fail "Could not extract KUBE_VERSION from worker.sh"
else
  pass "worker.sh KUBE_VERSION=$WORKER_KUBE"
fi

if [ -z "$MINIKUBE_KUBE" ]; then
  fail "Could not extract kubernetes-version from minikube.sh"
else
  pass "minikube.sh kubernetes-version=$MINIKUBE_KUBE"
fi

if [ -n "$MASTER_KUBE" ] && [ -n "$WORKER_KUBE" ]; then
  if [ "$MASTER_KUBE" = "$WORKER_KUBE" ]; then
    pass "master.sh and worker.sh KUBE_VERSION match ($MASTER_KUBE)"
  else
    fail "KUBE_VERSION mismatch: master.sh=$MASTER_KUBE vs worker.sh=$WORKER_KUBE"
  fi
fi

if [ -n "$MASTER_KUBE" ] && [ -n "$MINIKUBE_KUBE" ]; then
  if [ "$MASTER_KUBE" = "$MINIKUBE_KUBE" ]; then
    pass "master.sh and minikube.sh Kubernetes versions match ($MASTER_KUBE)"
  else
    fail "Kubernetes version mismatch: master.sh=$MASTER_KUBE vs minikube.sh=$MINIKUBE_KUBE"
  fi
fi

# ──────────────────────────────────────────────
# 2. containerd version must match across files
# ──────────────────────────────────────────────
echo ""
echo "=== containerd version consistency ==="

MASTER_CTD=$(grep -oP '^CONTAINERD_VERSION=\K[0-9.]+' master.sh || true)
WORKER_CTD=$(grep -oP '^CONTAINERD_VERSION=\K[0-9.]+' worker.sh || true)

if [ -z "$MASTER_CTD" ]; then
  fail "Could not extract CONTAINERD_VERSION from master.sh"
else
  pass "master.sh CONTAINERD_VERSION=$MASTER_CTD"
fi

if [ -z "$WORKER_CTD" ]; then
  fail "Could not extract CONTAINERD_VERSION from worker.sh"
else
  pass "worker.sh CONTAINERD_VERSION=$WORKER_CTD"
fi

if [ -n "$MASTER_CTD" ] && [ -n "$WORKER_CTD" ]; then
  if [ "$MASTER_CTD" = "$WORKER_CTD" ]; then
    pass "master.sh and worker.sh CONTAINERD_VERSION match ($MASTER_CTD)"
  else
    fail "CONTAINERD_VERSION mismatch: master.sh=$MASTER_CTD vs worker.sh=$WORKER_CTD"
  fi
fi

# ──────────────────────────────────────────────
# 3. Version strings are not empty / look valid
# ──────────────────────────────────────────────
echo ""
echo "=== Version format validation ==="

validate_semver() {
  local name="$1" value="$2"
  if [[ "$value" =~ ^v?[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
    pass "$name ($value) is valid semver"
  else
    fail "$name ($value) does not look like valid semver"
  fi
}

[ -n "$MASTER_KUBE" ]    && validate_semver "KUBE_VERSION"      "$MASTER_KUBE"
[ -n "$MASTER_CTD" ]     && validate_semver "CONTAINERD_VERSION" "$MASTER_CTD"

ETCDCTL_VER=$(grep -oP '^ETCDCTL_VERSION=\K[v0-9.]+' master.sh || true)
[ -n "$ETCDCTL_VER" ]    && validate_semver "ETCDCTL_VERSION"    "$ETCDCTL_VER"

CRIO_VER=$(grep -oP '^CRIO_VERSION=\K[0-9.]+' bootstrap.sh || true)
[ -n "$CRIO_VER" ]       && validate_semver "CRIO_VERSION"       "$CRIO_VER"

# ──────────────────────────────────────────────
# 4. Key files exist
# ──────────────────────────────────────────────
echo ""
echo "=== Required files exist ==="

for f in master.sh worker.sh minikube.sh bootstrap.sh containerd.sh cri-o.sh kmaster.sh Vagrantfile pod.yaml; do
  if [ -f "$f" ]; then
    pass "$f exists"
  else
    fail "$f is missing"
  fi
done

# ──────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────
echo ""
echo "======================================="
echo "  Total checks: $CHECKS"
echo "  Passed:       $((CHECKS - FAILED))"
echo "  Failed:       $FAILED"
echo "======================================="

if [ "$FAILED" -gt 0 ]; then
  echo "::error::$FAILED version consistency check(s) failed"
  exit 1
fi

echo "All version consistency checks passed!"
