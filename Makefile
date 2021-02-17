APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`

.PHONY: docker-dev-local
docker-dev-local:
	docker build --build-arg MIX_ENV=dev --build-arg BUILD=$(BUILD) \
		-t $(APP_NAME):$(APP_VSN) .

.PHONY: docker-dev
docker-dev:
	docker build --build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		--build-arg SECRET_KEY_BASE=${SECRET_KEY_BASE} \
		--build-arg BUILD=$(BUILD) \
		-t ${AWS_ECR_URL}:latest .

.PHONY: docker-prod-local
docker-prod-local:
	docker build --build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		--build-arg SECRET_KEY_BASE=${SECRET_KEY_BASE} \
		--build-arg BUILD=$(BUILD) \
		-t $(APP_NAME):$(APP_VSN) .

.PHONY: docker-prod
docker-prod:
	docker build --build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		--build-arg SECRET_KEY_BASE=${SECRET_KEY_BASE} \
		--build-arg BUILD=$(BUILD) \
		-t ${AWS_ECR_URL}:$(APP_VSN) \
		-t ${AWS_ECR_URL}:latest .

.PHONY: push-dev
push-dev:
	docker push ${AWS_ECR_URL}:latest
