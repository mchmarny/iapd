VERSION  :=$(shell cat .version)
REPO     :=$(shell git config --get remote.origin.url | cut -d: -f2 | cut -d. -f1)
USER     :=$(shell echo $(REPO) | cut -d/ -f1)
NAME     :=$(shell echo $(REPO) | cut -d/ -f2)
PROJECT  :=$(shell gcloud config get-value project)
REGION   :="us-west1"
IMAGE    :="$(REGION)-docker.pkg.dev/$(PROJECT)/$(NAME)/app"

all: help

.PHONY: info
info: ## Prints all variables
	@echo "project:  $(PROJECT)"
	@echo "region:   $(REGION)"
	@echo "repo:     $(REPO)"
	@echo "user:     $(USER)"
	@echo "name:     $(NAME)"
	@echo "image:    $(IMAGE)"
	@echo "version:  $(VERSION)"
	
.PHONY: repo
repo: ## Updates the go modules and vendors all dependancies 
	gcloud artifacts repositories create $(NAME) \
		--repository-format docker \
		--location $(REGION)
		
.PHONY: tidy
tidy: ## Updates the go modules and vendors all dependancies 
	go mod tidy
	go mod vendor

.PHONY: upgrade
upgrade: ## Upgrades all dependancies 
	go get -d -u ./...
	go mod tidy
	go mod vendor

.PHONY: test
test: tidy ## Runs unit tests
	go test -count=1 -race -covermode=atomic -coverprofile=cover.out ./...


.PHONY: lint
lint: ## Lints the entire project using go 
	golangci-lint -c .golangci.yaml run

.PHONY: app
app: ## Runs the application locally
	go run internal/cmd/app/main.go

.PHONY: image
image: tidy lint ## Builds the docker image
	KO_DOCKER_REPO="$(IMAGE)" \
	GOFLAGS="-ldflags=-X=main.version=$(VERSION)" \
	ko build internal/cmd/app/main.go --image-refs .digest --bare --tags $(VERSION),latest

.PHONY: vulncheck
vulncheck: ## Checks for soource vulnerabilities
	govulncheck -test ./...

.PHONY: init
init: ## Initializes all dependancies
	terraform -chdir=./deployment/demo init

.PHONY: deployment
deployment: ## Applies Terraform deployment
	terraform -chdir=./deployment/demo apply -auto-approve

.PHONY: tag
tag: ## Creates release tag 
	git tag -s -m "version bump to $(VERSION)" $(VERSION)
	git push origin $(VERSION)

.PHONY: tagless
tagless: ## Delete the current release tag 
	git tag -d $(VERSION)
	git push --delete origin $(VERSION)

.PHONY: clean
clean: ## Cleans bin and temp directories
	go clean
	rm -fr ./vendor
	rm -fr ./bin

.PHONY: help
help: ## Display available commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk \
		'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
