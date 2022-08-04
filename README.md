# Virtù OpenAPI Dev Tool 

This tool is able to merge and parse split OpenAPI definition files, generate client/server libraries from it and also to use this definition to display documentation

## Cloning

Clone the repository.
```bash
git clone git@bitbucket.org:crearex/virtu-openapi-dev-tool.git
```

If you have authorisation problems, you probably don't have ssh setup correctly. Follow guides like this one to setup ssh. [SSH setup guide](https://linuxhint.com/generate-ssh-key-ubuntu/)

Please bear in mind that your ssh key has to be set as an authorization in the repository settings. 

## Installing

Download the latest [NodeJS](https://nodejs.org/en/) version - you might consider using [nvm](https://github.com/nvm-sh/nvm) for this.

Install the OpenAPI Libraries:
```bash
    npm i -g @lyra-network/openapi-dev-tool @openapitools/openapi-generator-cli
```

Run the generator and npm install script via ```make```:
```
    make install
```

## Viewing the Documentation

Run ReDoc via ```make```:
```bash
    make serve
``` 

You need to have port  3000 open for this to work. 

## Generating

Merge split definmition files and generate the client/server libraries via ```make```:
```bash
    make generate
```