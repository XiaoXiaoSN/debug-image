.PHONY: update-version

update-version:
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		alpine:3 sh -c 'apk add --no-cache -q curl grep jq && ./versions.sh Dockerfile'

