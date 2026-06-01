# Low-cost .NET Web App on AWS

This project builds a simple .NET web front end and packages the published
static files for deployment to an existing Windows IIS server.

The source for a Blazor WebAssembly app lives in `src/CheapDotnetWeb`.
TeamCity publishes the app into `website-dist`, packages it, and Octopus copies
those files onto the IIS server.

## CI/CD flow

TeamCity should build, test, publish, synthesize, and package:

```bash
bash ./teamcity/build.sh
PACKAGE_VERSION="%build.number%" bash ./teamcity/package.sh
```

Octopus should deploy the immutable TeamCity package to the Windows IIS server:

```powershell
$env:IIS_WEB_ROOT = "C:\inetpub\wwwroot"
.\octopus\deploy.ps1
```

This keeps CI and CD separate: TeamCity produces the artifact once, then Octopus
promotes that same artifact through environments.

## Useful commands

* `npm run build` compile TypeScript to JavaScript
* `npm run watch` watch mode for TypeScript
* `npm run test` run the Jest tests
* `npx cdk synth` synthesize the CloudFormation template
* `npx cdk deploy` deploy the optional AWS staging stack
