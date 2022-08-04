# basic info
PROJECT_NAME := virtu-api

# directories
DIST_DIR := dist/

# repository information
REPO_DIR := virtu-openapi-spec
REPO_URL := git@bitbucket.org:crearex/virtu-openapi-spec.git


# server libs to create
SERVERS := php_symfony

# client libs to generate
CLIENTS := php javascript typescript-axios typescript-node

.PHONY: clean install pull merge serve generate

clean:
	@if [ -d "$(DIST_DIR)" ]; then \
		rm -rf $(DIST_DIR); \
		echo "Distribution directory $(DIST_DIR) deleted. \\n"; \
	fi;

install: 
	@npm install 

pull: clean
	@if [ ! -d "$(REPO_DIR)" ]; then \
		echo "\\n \\n Adding submodule $(REPO_URL) \\n \\n"; \
		git submodule add --force $(REPO_URL); \
	fi; \
	echo "\\n \\n Updating submodule. \\n" && cd $(REPO_DIR) && git pull && cd ..

createDevToolConfig: 
	# @rm config.json; \
	# echo "\"{\"specs\": [{\"file\": \"" > config.json && \
	# echo "$(SPEC_DIR)/${SPEC_FILE}\"," > config.json && \
	# echo "\"enabled\": true,\"vFolders\": [],\"context\": {\"public\": true,"version": "1.0.0"}}]} " > config.json
 
merge: pull
	@echo "\\n \\n Merging .yaml files \\n \\n"; \
	openapi-dev-tool merge -c config.json -o $(DIST_DIR) -v

serve:  
	@openapi-dev-tool serve -c config.json

generate: merge
	@echo "\\n \\n Generating Client & Server Libraries. \\n \\n"; \
	openapi-generator-cli generate
