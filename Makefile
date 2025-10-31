
ver ?= v1.37.0

clone:
	git clone --branch $(ver) --recurse-submodules \
	  https://github.com/VictoriaMetrics/VictoriaLogs.git VictoriaLogs_$(ver)

diff:
	mkdir -p patches/VictoriaLogs_$(ver)/ && \
	cd VictoriaLogs_$(ver) && \
	git add -N . && \
	git diff --name-only | while read file; do \
		mkdir -p "../patches/VictoriaLogs_$(ver)/$$(dirname $$file)"; \
		git diff "$$file" > "../patches/VictoriaLogs_$(ver)/$$file.patch"; \
	done

patch:
	cd VictoriaLogs_$(ver) && \
	git reset --hard && \
	find ../patches/VictoriaLogs_$(ver) -name '*.patch' | while read patch; do \
		git apply "$$patch"; \
	done

build:
	cd VictoriaLogs_$(ver) && \
	make victoria-logs-linux-amd64-prod

docker_build:
	cd VictoriaLogs_$(ver) && \
	docker build \
	    --platform linux/amd64 \
		--build-arg src_binary=victoria-logs-linux-amd64-prod \
		--build-arg base_image=alpine:3.22.2 \
		--label "org.opencontainers.image.source=https://github.com/VictoriaMetrics/VictoriaMetrics" \
		--label "org.opencontainers.image.documentation=https://docs.victoriametrics.com/" \
		--label "org.opencontainers.image.title=victoria-logs" \
		--label "org.opencontainers.image.vendor=VictoriaMetrics" \
		--label "org.opencontainers.image.version=$(ver)" \
		--label "org.opencontainers.image.created=2025-10-30T06:13:15Z" \
		--tag victoriametrics/victoria-logs:$(ver)-avx2 \
		-f app/victoria-logs/deployment/Dockerfile bin

docker_push:
	docker tag $$(docker inspect --format='{{.Id}}' victoriametrics/victoria-logs:v1.36.1-avx2) ahfuzhang/victoria-logs:$(ver)-avx2 && \
	docker push docker.io/ahfuzhang/victoria-logs:$(ver)-avx2
