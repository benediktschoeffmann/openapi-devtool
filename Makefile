# basic info
PROJECT_NAME := virtu-api

# directories
DIST_DIR := dist/

# repository information
REPO_DIR := virtu-openapi-spec
REPO_URL := git@bitbucket.org:crearex/virtu-openapi-spec.git

# config file
GENERATOR_CONFIG_FILE := openapi-dev-tool-config.json

# colors
CYAN := \033[0;36m
WHITE := \033[1;37m


# server libs to create
SERVERS := php_symfony

# client libs to generate
CLIENTS := php javascript typescript-axios typescript-node

.PHONY: clean install pull merge serve generate

clean:
	@if [ -d "$(DIST_DIR)" ]; then \
		rm -rf $(DIST_DIR); \
		echo "$(CYAN) \n \nDistribution directory $(DIST_DIR) deleted.\n\n$(WHITE)"; \
	fi;

install: 
	@echo "$(CYAN) \n \n Downloading Generator libs. \n \n$(WHITE)"; \
	(openapi-generator-cli > /dev/null); \
	echo "$(CYAN) \n \n Running \"npm ci\" "; \
	npm ci

pull: clean
	@if [ ! -d "$(REPO_DIR)" ]; then \
		echo "$(CYAN) \n \n Adding submodule $(REPO_URL) \n \n$(WHITE)"; \
		git submodule add --force $(REPO_URL); \
	fi; \
	echo "$(CYAN)\n\n Updating submodule. \n\n$(WHITE)" && cd $(REPO_DIR) && git pull && cd ..

createDevToolConfig: 
	# @rm config.json; \
	# echo "\"{\"specs\": [{\"file\": \"" > config.json && \
	# echo "$(SPEC_DIR)/${SPEC_FILE}\"," > config.json && \
	# echo "\"enabled\": true,\"vFolders\": [],\"context\": {\"public\": true,"version": "1.0.0"}}]} " > config.json
 
merge: pull
	@echo "$(CYAN) \n \n Merging .yaml files \n \n$(WHITE)"; \
	openapi-dev-tool merge -c $(GENERATOR_CONFIG_FILE) -o $(DIST_DIR) -v

serve: 
	@echo "$(CYAN) \n \n Starting Documentation server. \n \n$(WHITE)" && \
	(openapi-dev-tool serve -c $(GENERATOR_CONFIG_FILE) &) && (x-www-browser http://localhost:3000 &)

generate: merge
	@echo "$(CYAN) \n \n Generating Client & Server Libraries. \n \n$(WHITE)"; \
	openapi-generator-cli generate; \
	echo "$(CYAN) \n \n \n \n All done ! Have a look at the $(DIST_DIR) directory. \n \n$(WHITE)" 
