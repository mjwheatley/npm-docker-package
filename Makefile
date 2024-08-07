SHELL:=/bin/bash

.PHONY: image
image:
	arch="x86_64"; \
	docker build --build-arg ARCH=$$arch --build-arg NODE_AUTH_TOKEN=${NODE_AUTH_TOKEN} -t npm-docker-package . --platform linux/$$arch
