redpanda:
	helm repo add redpanda https://charts.redpanda.com/
	helm repo update
	helm template redpanda redpanda/redpanda \
	--namespace redpanda --create-namespace \
	--set tls.enabled=false \
	--set statefulset.replicas=1 \
	--set image.tag=v23.1.6 \
	--set external.enabled=false \
	--output-dir redpanda

	mkdir -p redpanda/console

	cd redpanda/redpanda && \
	find templates/console -name '*.yaml' -exec mv -n {} ../console \; && \
	find charts/console/templates -name '*.yaml' -exec mv -n {} ../console \;

	cd redpanda/redpanda && \
	find . -name '*.yaml' -exec mv -n {} .. \;

	echo "Remove empty dirs"
	find . -depth -type d -empty -exec rmdir {} \;

cert-manager:
	helm repo add jetstack https://charts.jetstack.io
	helm repo update
	helm template cert-manager jetstack/cert-manager \
	--namespace cert-manager --create-namespace \
	--set installCRDs=true \
	--output-dir cert-manager
	
	cd cert-manager && \
	find . -name '*.yaml' -exec mv -n {} . \; && \
	find . -depth -type d -empty -exec rmdir {} \;

