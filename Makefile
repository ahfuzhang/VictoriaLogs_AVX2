
clone_v1.36.1:
	git clone --branch v1.36.1 --recurse-submodules \
	  https://github.com/VictoriaMetrics/VictoriaLogs.git VictoriaLogs_v1.36.1

diff_v1.36.1:
	mkdir -p patches/VictoriaLogs_v1.36.1/ && \
	cd VictoriaLogs_v1.36.1 && \
	git add -N . && \
	git diff --name-only | while read file; do \
		mkdir -p "../patches/VictoriaLogs_v1.36.1/$$(dirname $$file)"; \
		git diff "$$file" > "../patches/VictoriaLogs_v1.36.1/$$file.patch"; \
	done

patch_v1.36.1:
	cd VictoriaLogs_v1.36.1 && \
	git reset --hard && \
	find ../patches/VictoriaLogs_v1.36.1 -name '*.patch' | while read patch; do \
		git apply "$$patch"; \
	done

build_v1.36.1:
	cd VictoriaLogs_v1.36.1 && \
	make victoria-logs-linux-amd64-prod

docker_build_v1.36.1:
	cd VictoriaLogs_v1.36.1 && \
	docker build \
	    --platform linux/amd64 \
		--build-arg src_binary=victoria-logs-linux-amd64-prod \
		--build-arg base_image=alpine:3.22.2 \
		--label "org.opencontainers.image.source=https://github.com/VictoriaMetrics/VictoriaMetrics" \
		--label "org.opencontainers.image.documentation=https://docs.victoriametrics.com/" \
		--label "org.opencontainers.image.title=victoria-logs" \
		--label "org.opencontainers.image.vendor=VictoriaMetrics" \
		--label "org.opencontainers.image.version=v1.36.1" \
		--label "org.opencontainers.image.created=2025-10-30T06:13:15Z" \
		--tag victoriametrics/victoria-logs:v1.36.1-avx2 \
		-f app/victoria-logs/deployment/Dockerfile bin

docker_push_v1.36.1:
	docker tag $$(docker inspect --format='{{.Id}}' victoriametrics/victoria-logs:v1.36.1-avx2) ahfuzhang/victoria-logs:v1.36.1-avx2 && \
	docker push docker.io/ahfuzhang/victoria-logs:v1.36.1-avx2
