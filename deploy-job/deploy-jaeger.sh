#!/bin/bash

# Deploy script for train-ticket using k8s-with-jaeger manifests
# This deployment uses MongoDB per service and includes Jaeger tracing

# Get the namespace from command line argument or set to "train-ticket" if not provided
namespace=${1:-train-ticket}

echo "=== Train-Ticket Deployment (k8s-with-jaeger) ==="
echo "Namespace: $namespace"
echo "Current working directory: $(pwd)"

# Utility function to wait for all pods in a namespace to be ready
function wait_for_pods_ready {
  local ns=$1
  local timeout=${2:-600}  # Default 10 minute timeout
  local start_time=$(date +%s)

  echo "Waiting for all pods in namespace '$ns' to be ready (timeout: ${timeout}s)..."

  while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [ $elapsed -ge $timeout ]; then
      echo "Timeout waiting for pods to be ready after ${timeout}s"
      kubectl get pods -n "$ns"
      return 1
    fi

    # Check the 'READY' column for pods that are not fully ready
    non_ready_pods=$(kubectl get pods -n "$ns" --no-headers 2>/dev/null | awk '{split($2,a,"/"); if (a[1] != a[2]) print $1}' | wc -l)

    if [ "$non_ready_pods" -eq 0 ]; then
      total_pods=$(kubectl get pods -n "$ns" --no-headers 2>/dev/null | wc -l)
      if [ "$total_pods" -gt 0 ]; then
        echo "All $total_pods pods in namespace '$ns' are ready."
        return 0
      fi
    fi

    echo "  $non_ready_pods pod(s) not ready yet. Elapsed: ${elapsed}s..."
    sleep 10
  done
}

# Step 1: Deploy MongoDB instances and Jaeger
function deploy_infrastructure {
  echo ""
  echo "=== Step 1/3: Deploying MongoDB and Jaeger infrastructure ==="

  if [ ! -f "deployment/kubernetes-manifests/k8s-with-jaeger/ts-deployment-part1.yml" ]; then
    echo "Error: ts-deployment-part1.yml not found"
    exit 1
  fi

  kubectl apply -f deployment/kubernetes-manifests/k8s-with-jaeger/ts-deployment-part1.yml -n "$namespace"

  echo "Waiting for MongoDB and Jaeger pods to be ready..."
  wait_for_pods_ready "$namespace" 120
}

# Step 2: Deploy all train-ticket services
function deploy_services {
  echo ""
  echo "=== Step 2/3: Deploying Train-Ticket services ==="

  if [ ! -f "deployment/kubernetes-manifests/k8s-with-jaeger/ts-deployment-part2.yml" ]; then
    echo "Error: ts-deployment-part2.yml not found"
    exit 1
  fi

  kubectl apply -f deployment/kubernetes-manifests/k8s-with-jaeger/ts-deployment-part2.yml -n "$namespace"

  echo "Waiting for service pods to be ready..."
  wait_for_pods_ready "$namespace" 900
}

# Step 3: Deploy UI dashboard
function deploy_ui {
  echo ""
  echo "=== Step 3/3: Deploying UI Dashboard ==="

  if [ ! -f "deployment/kubernetes-manifests/k8s-with-jaeger/ts-deployment-part3.yml" ]; then
    echo "Error: ts-deployment-part3.yml not found"
    exit 1
  fi

  kubectl apply -f deployment/kubernetes-manifests/k8s-with-jaeger/ts-deployment-part3.yml -n "$namespace"

  echo "Waiting for UI pod to be ready..."
  wait_for_pods_ready "$namespace" 900
}

# Main execution
echo ""
echo "Starting deployment..."

deploy_infrastructure
deploy_services
deploy_ui

echo ""
echo "=== Deployment Complete ==="
echo "Train-Ticket UI: Access via ts-ui-dashboard service"
echo "Jaeger UI: http://<NodeIP>:32688"
kubectl get pods -n "$namespace" | head -20
echo "..."
echo "Total pods: $(kubectl get pods -n "$namespace" --no-headers | wc -l)"
