# Kustomizaiton bases for commn services

They can be created also from Helm with from_helm script.

## Redpanda

Created with script and then adjusted:

```
HELM_REPO_NAME="redpanda" \
HELM_REPO_URL="https://charts.redpanda.com/" \
HELM_CHART_NAME="redpanda/redpanda" \
HELM_CHART_VERSION="3.0.10" \
K8S_NAMESPACE="redpanda" \
./from_helm.sh \
--set image.tag=v23.1.6 \
--set tls.enabled=false \
--set external.enabled=false \
--set statefulset.replicas=1 \
--set post_install_job.enabled=false \
--set console.enabled=true \
--set config.cluster.auto_create_topics_enabled=true \
--set config.cluster.delete_retention_ms=5min
```

## Cert-manager

```
curl -L https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml >> cert-manager.yaml
```
