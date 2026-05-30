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

    const siteBucket = new s3.Bucket(this, 'DotnetWebSiteBucket', {
      blockPublicAccess: s3.BlockPublicAccess.BLOCK_ACLS,
      publicReadAccess: true,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
      autoDeleteObjects: true,
      websiteIndexDocument: 'index.html',
      websiteErrorDocument: 'index.html',
    });

    new s3deploy.BucketDeployment(this, 'DotnetWebSiteDeployment', {
      sources: [s3deploy.Source.asset(path.join(__dirname, '..', siteSourcePath))],
      destinationBucket: siteBucket,
    });

    new cdk.CfnOutput(this, 'EnvironmentName', {
      value: environmentName,
    });

    new cdk.CfnOutput(this, 'WebsiteBucketName', {
      value: siteBucket.bucketName,
    });

    new cdk.CfnOutput(this, 'WebsiteUrl', {
      value: siteBucket.bucketWebsiteUrl,
      description: 'Public URL for the low-cost .NET static web app.',
    });
  }
}
