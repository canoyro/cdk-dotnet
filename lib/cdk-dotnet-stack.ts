import * as path from 'path';
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as s3deploy from 'aws-cdk-lib/aws-s3-deployment';
import { Construct } from 'constructs';

export class CdkDotnetStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const environmentName = this.node.tryGetContext('environment') ?? 'dev';
    const siteSourcePath = this.node.tryGetContext('siteSourcePath') ?? 'website-dist';
    const siteArtifactPrefix = `${environmentName}/site`;

    const siteArtifactBucket = new s3.Bucket(this, 'DotnetWebSiteArtifactBucket', {
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
      encryption: s3.BucketEncryption.S3_MANAGED,
      enforceSSL: true,
      removalPolicy: cdk.RemovalPolicy.RETAIN,
    });

    new s3deploy.BucketDeployment(this, 'DotnetWebSiteArtifactDeployment', {
      sources: [s3deploy.Source.asset(path.join(__dirname, '..', siteSourcePath))],
      destinationBucket: siteArtifactBucket,
      destinationKeyPrefix: siteArtifactPrefix,
      prune: true,
    });

    new cdk.CfnOutput(this, 'EnvironmentName', {
      value: environmentName,
    });

    new cdk.CfnOutput(this, 'WebsiteArtifactBucketName', {
      value: siteArtifactBucket.bucketName,
    });

    new cdk.CfnOutput(this, 'WebsiteArtifactPrefix', {
      value: siteArtifactPrefix,
      description: 'S3 prefix containing files to copy onto the existing IIS server.',
    });
  }
}
