# Low-cost .NET Web App on AWS

This CDK TypeScript project deploys a simple .NET web front end using S3 static
website hosting. For a basic web app, this is usually the least expensive AWS
shape because there is no always-on server, container, load balancer, or NAT
gateway.

The stack publishes the contents of `website-dist` to a public S3 website bucket
and outputs the website URL after deployment. The source for a Blazor
WebAssembly app lives in `src/CheapDotnetWeb`.

## CI/CD flow

TeamCity should build, test, publish, synthesize, and package:

```bash
bash ./teamcity/build.sh
PACKAGE_VERSION="%build.number%" bash ./teamcity/package.sh
```

Octopus should deploy the immutable TeamCity package:

```bash
STACK_NAME="CdkDotnetStack" ENVIRONMENT_NAME="Dev" bash ./octopus/deploy.sh
```

This keeps CI and CD separate: TeamCity produces the artifact once, then Octopus
promotes that same artifact through environments.

## Useful commands

* `npm run build` compile TypeScript to JavaScript
* `npm run watch` watch mode for TypeScript
* `npm run test` run the Jest tests
* `npx cdk synth` synthesize the CloudFormation template
* `npx cdk deploy` deploy this stack to your default AWS account and region
