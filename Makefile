# basic info
PROJECT_NAME := virtu-api
REPO_URL := git@bitbucket.org:crearex/virtu-openapi-spec.git

# directories
SPEC_DIR := ./spec/
SPEC_FILE := openapi.yaml
DIST_DIR := ./dist/

# server libs to create
SERVERS := php_symfony

# client libs to generate
CLIENTS := php javascript typescript-axios typescript-node

.PHONY: clean

clean:
	@rm -rf $(DIST_DIR) && \	
	@echo "Deleted destination directory ${DIST_DIR} \n";

clone: clean
	@git clone ${REPO_URL} .

createDevToolConfig: 
	# @rm config.json; \
	# echo "\"{\"specs\": [{\"file\": \"" > config.json && \
	# echo "${SPEC_DIR}/${SPEC_FILE}\"," > config.json && \
	# echo "\"enabled\": true,\"vFolders\": [],\"context\": {\"public\": true,"version": "1.0.0"}}]} " > config.json
 

install: clone
	@npm install

merge: install
	@openapi-dev-tool merge -c config.json -o ${DIST_DIR} -v

serve: install 
	@openapi-dev-tool serve -c config.json

generate: merge
	@openapi-cli generate
