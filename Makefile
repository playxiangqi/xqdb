APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `grep 'version:' mix.exs | cut -d '"' -f2`
BUILD ?= `git rev-parse --short HEAD`

.PHONY: build-dev-local
build-dev-local:
	docker build --build-arg MIX_ENV=dev -t $(APP_NAME):$(APP_VSN) .

.PHONY: build-dev
build-dev:
	docker build --build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		-t ${AWS_ECR_URL}:latest .

.PHONY: build-prod-local
build-prod-local:
	docker build --build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		--build-arg SECRET_KEY_BASE=${SECRET_KEY_BASE} \
		--build-arg DATABASE_URL=${DATABASE_URL} \
		-t $(APP_NAME):$(APP_VSN) .

.PHONY: build-prod
build-prod:
	docker build --build-arg APP_VSN=$(APP_VSN) \
		--build-arg MIX_ENV=prod \
		-t ${AWS_ECR_URL}:$(APP_VSN)-$(BUILD) \
		-t ${AWS_ECR_URL}:latest .

.PHONY: push-dev
push-dev:
	docker push ${AWS_ECR_URL}:latest
