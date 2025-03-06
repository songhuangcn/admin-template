KUBE = kubectl -n admin-template

status:
		$(KUBE) get all

apply:
		$(KUBE) apply -k base

replace:
		$(KUBE) replace --force -k base

delete:
		$(KUBE) delete -k base

encode:
		kubeseal --format=yaml --cert=base/config/sealed-secret.crt < base/app-secret.yaml > base/app-sealed-secret.yaml
		kubeseal --format=yaml --cert=base/config/sealed-secret.crt < base/docker-secret.yaml > base/docker-sealed-secret.yaml

decode:
		kubeseal --format=yaml --recovery-unseal --recovery-private-key base/config/sealed-secret.key -f base/app-sealed-secret.yaml > base/decode-app-secret.yaml
		kubeseal --format=yaml --recovery-unseal --recovery-private-key base/config/sealed-secret.key -f base/docker-sealed-secret.yaml > base/decode-docker-secret.yaml
