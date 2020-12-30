import { Stack, Construct, SecretValue, StackProps } from '@aws-cdk/core'
import { CdkPipeline, SimpleSynthAction } from '@aws-cdk/pipelines'

import * as codepipeline from '@aws-cdk/aws-codepipeline'
import * as codepipeline_actions from '@aws-cdk/aws-codepipeline-actions'

export class OpsStack extends Stack {
	constructor(scope: Construct, id: string, props?: StackProps) {
		super(scope, id, props)

		const sourceArtifact = new codepipeline.Artifact()
		const cloudAssemblyArtifact = new codepipeline.Artifact()

		const pipeline = new CdkPipeline(this, 'Pipeline', {
			pipelineName: 'MyAppPipeline',
			cloudAssemblyArtifact,

			sourceAction: new codepipeline_actions.GitHubSourceAction({
				actionName: 'GitHub',
				output: sourceArtifact,
				oauthToken: SecretValue.secretsManager('/capricorn-example/production/GITHUB_TOKEN'),
				trigger: codepipeline_actions.GitHubTrigger.POLL,
				owner: '68696c6c@gmail.com',
				repo: 'capricorn_example',
			}),

			synthAction: SimpleSynthAction.standardNpmSynth({
				sourceArtifact,
				cloudAssemblyArtifact,

				// Use this if you need a build step (if you're not using ts-node
				// or if you have TypeScript Lambdas that need to be compiled).
				buildCommand: 'npm run build',
			}),
		})
	}
}
