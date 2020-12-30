#!/usr/bin/env node
import 'source-map-support/register'
import * as cdk from '@aws-cdk/core'
import { OpsStack } from '../lib/ops-stack'

const app = new cdk.App()
new OpsStack(app, 'OpsStack', {
	env: {
		account: '495315319309',
		region: 'us-east-1',
	}
})
