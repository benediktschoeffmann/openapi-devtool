# virtu openAPI dev tool

Installing:
```
npm install
```

## Available commands
| Command | Description |
| --- | --- |
| `npm run merge` | Parses all files defined from root file in `config.json` and outputs it to `dist` folder| 
| `npm run serve` | Builds a dev server with ReDoc enabled at localhost:3000 |
| `npm run build` | Builds client/server libraries as defined in `openapitools.json` |

## Troubleshooting

* Be aware that java needs to be installed on your machine. 
* If build fails: did you `merge` first?

## Further documentation:
* https://github.com/OpenAPITools/openapi-generator
* https://github.com/lyra/openapi-dev-tool
