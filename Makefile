IMAGE := alpine/fio
APP:="app/deploy-openesb.sh"

deploy-topology-spacewalk:
	bash scripts/deploy-topology-spacewalk.sh

deploy-topology:
	bash scripts/deploy-topology.sh

deploy-libvirt:
	bash scripts/deploy-libvirt.sh

deploy-vagrant:
	bash scripts/deploy-vagrant.sh
	
push-image:
	docker push $(IMAGE)
.PHONY: deploy-openesb deploy-dashboard push-image
