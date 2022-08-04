# basic info
PROJECT_NAME := virtu-api
REPO_DIR := virtu-openapi-spec
REPO_URL := git@bitbucket.org:crearex/virtu-openapi-spec.git

# directories
SPEC_DIR := ./spec/
SPEC_FILE := openapi.yaml
DIST_DIR := dist/

# server libs to create
SERVERS := php_symfony

# client libs to generate
CLIENTS := php javascript typescript-axios typescript-node

.PHONY: clean clone

clean:
	@if [ -d "$(DIST_DIR)" ]; then \
		rm -rf $(DIST_DIR); \
		echo "Distribution directory $(DIST_DIR) deleted. \\n"; \
	fi;
	
clone:
	@git clone ${REPO_URL} .

pull:
	@echo "$(REPO_DIR)"; \
	@if [ ! -d "$(REPO_DIR)" ]; then \
		echo "Adding submodule $(REPO_URL)"; \
		git submodule add --force $(REPO_URL); \
	fi; \
	@echo "Updating submodule. \\n" && cd $(REPO_DIR) && git pull && cd ..

createDevToolConfig: 
	# @rm config.json; \
	# echo "\"{\"specs\": [{\"file\": \"" > config.json && \
	# echo "$(SPEC_DIR)/${SPEC_FILE}\"," > config.json && \
	# echo "\"enabled\": true,\"vFolders\": [],\"context\": {\"public\": true,"version": "1.0.0"}}]} " > config.json
 

install: clone
	@npm install

merge: install
	@openapi-dev-tool merge -c config.json -o $(DIST_DIR) -v

serve: install 
	@openapi-dev-tool serve -c config.json

generate: merge
	@openapi-generator-cli generate
