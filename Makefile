#!make
include .env

# basic info
PROJECT_NAME := ${PROJECT_NAME}

# directories
DIST_DIR := ${DIST_DIR}
LIB_DIR := ${LIB_DIR}
PACKAGE_DIR := node_modules/

# repository information
REPO_DIR := ${REPO_DIR}
REPO_FILE := openapi.yaml
REPO_URL := ${REPO_URL}
REPO_BRANCH := ${REPO_BRANCH}

# config file
GENERATOR_CONFIG_FILE := openapi-dev-tool-config.json

# colors
CYAN := \033[0;36m
WHITE := \033[1;37m


# server libs to create
SERVERS := ${SERVERS}

# client libs to generate
CLIENTS := ${CLIENTS}

.PHONY: all clean install pull merge serve generate

all: clean install pull merge generate

clean:
	@if [ -d "$(DIST_DIR)" ]; then \
		rm -rf $(DIST_DIR); \
		echo "$(CYAN) \n \nDistribution directory $(DIST_DIR) deleted.\n\n$(WHITE)"; \
	fi;
	@if [ -d "$(SPEC_DIR)" ]; then \
		rm -rf $(SPEC_DIR); \
		echo "$(CYAN) \n \nSpecification directory $(SPEC_DIR) deleted.\n\n$(WHITE)"; \
	fi;
	@if [ -d "$(PACKAGE_DIR)" ]; then \
		rm -rf $(PACKAGE_DIR); \
		echo "$(CYAN) \n \nPackage directory $(PACKAGE_DIR) deleted.\n\n$(WHITE)"; \
	fi;
	@if [ -d "$(LIB_DIR)" ]; then \
		rm -rf $(LIB_DIR); \
		echo "$(CYAN) \n \nLibrary directory $(LIB_DIR) deleted.\n\n$(WHITE)"; \
	fi;

install:
	@if [ ! -d "$(LIB_DIR)" ]; then \
		echo "$(CYAN) \n \n Downloading Generator libs. \n \n$(WHITE)"; \
		(openapi-generator-cli > /dev/null); \
	fi; \
	if [ ! -d "$(PACKAGE_DIR)" ]; then \
		echo "$(CYAN) \n \n Running \"npm ci\" \n\n$(WHITE)"; \
		npm ci; \
	fi;

pull: clean
	@if [ ! -d "$(SPEC_DIR)" ]; then \
		mkdir "$(SPEC_DIR)"; \
	fi; \
	if [ ! -d "$(SPEC_DIR)/$(REPO_DIR)" ]; then \
		echo "$(CYAN) \n \n Adding submodule $(REPO_URL) \n \n$(WHITE)"; \
		cd $(SPEC_DIR) && git submodule add  --force $(REPO_URL) $(REPO_DIR) && cd ..; \
	fi; \
	echo "$(CYAN)\n\n Updating submodule. \n\n$(WHITE)" && cd $(SPEC_DIR)/$(REPO_DIR) && git checkout $(REPO_BRANCH) && git pull && cd ..;

createDevToolConfig:
	# @rm config.json; \
	# echo "\"{\"specs\": [{\"file\": \"" > config.json && \
	# echo "$(SPEC_DIR)/$(REPO_DIR)/${REPO_FILE}\"," > config.json && \
	# echo "\"enabled\": true,\"vFolders\": [],\"context\": {\"public\": true,"version": "1.0.0"}}]} " > config.json

merge: pull
	@echo "$(CYAN) \n \n Merging .yaml files \n \n$(WHITE)"; \
	openapi-dev-tool merge -c $(GENERATOR_CONFIG_FILE) -o $(DIST_DIR) -v

generate: merge
	@echo "$(CYAN) \n \n Generating Client & Server Libraries. \n \n$(WHITE)"; \
	openapi-generator-cli generate; \
	echo "$(CYAN) \n \n \n \n All done ! Have a look at the $(DIST_DIR) directory. \n \n$(WHITE)"

serve: generate
	@echo "$(CYAN) \n \n Starting Documentation server. \n \n$(WHITE)" && \
	(openapi-dev-tool serve -c $(GENERATOR_CONFIG_FILE) &) && (x-www-browser http://localhost:3000 &)

all: generate