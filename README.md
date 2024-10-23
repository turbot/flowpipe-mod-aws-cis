# AWS CIS Mod for Flowpipe

Pipelines to detect and remediate AWS resources non-compliant with CIS benchmarks.

## Documentation

- **[Pipelines →](https://hub.flowpipe.io/mods/turbot/aws_cis/pipelines)**

## Getting Started

### Requirements

Docker daemon must be installed and running. Please see [Install Docker Engine](https://docs.docker.com/engine/install/) for more information.

### Installation

Download and install Flowpipe (https://flowpipe.io/downloads) and Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew install turbot/tap/flowpipe
brew install turbot/tap/steampipe
```

Install the AWS plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install aws
```

Steampipe will automatically use your default AWS credentials. Optionally, you can [setup multiple accounts](https://hub.steampipe.io/plugins/turbot/aws#multi-account-connections) or [customize AWS credentials](https://hub.steampipe.io/plugins/turbot/aws#configuring-aws-credentials).

Create a `connection_import` resource to import your Steampipe AWS connections:

```sh
vi ~/.flowpipe/config/aws.fpc
```

```hcl
connection_import "aws" {
  source      = "~/.steampipe/config/aws.spc"
  connections = ["*"]
}
```

For more information on importing connections, please see [Connection Import](https://flowpipe.io/docs/reference/config-files/connection_import).

For more information on connections in Flowpipe, please see [Managing Connections](https://flowpipe.io/docs/run/connections).

Clone the mod:

```sh
mkdir aws-cis
cd aws-cis
git clone git@github.com:turbot/flowpipe-mod-aws-cis.git
```

Install the dependencies:

```sh
flowpipe mod install
```

### Running CIS Pipelines

To run your first CIS pipeline, you'll need to ensure your Steampipe server is up and running:

```sh
steampipe service start
```

To find your desired CIS pipeline, you can filter the `pipeline list` output:

```sh
flowpipe pipeline list | grep "cis"
```

Then run your chosen pipeline:

```sh
flowpipe pipeline run cis_v400
```

By default the above approach would find the relevant resources and then send a message to your configured [notifier](https://flowpipe.io/docs/reference/config-files/notifier).

### Configure Variables

Several pipelines have [input variables](https://flowpipe.io/docs/build/mod-variables#input-variables) that can be configured to better match your environment and requirements.

The easiest approach is to setup your vars file, starting with the example file:

```sh
cp flowpipe.fpvars.example flowpipe.fpvars
vi flowpipe.fpvars
```

Alternatively, you can pass variables on the command line:

```sh
flowpipe pipeline run cis_v400 --var notifier=notifier.default
```

Or through environment variables:

```sh
export FP_VAR_notifier="notifier.default"
flowpipe pipeline run cis_v400
```

For more information, please see [Passing Input Variables](https://flowpipe.io/docs/build/mod-variables#passing-input-variables)

## Open Source & Contributing

This repository is published under the [Apache 2.0 license](https://www.apache.org/licenses/LICENSE-2.0). Please see our [code of conduct](https://github.com/turbot/.github/blob/main/CODE_OF_CONDUCT.md). We look forward to collaborating with you!

[Flowpipe](https://flowpipe.io) and [Steampipe](https://steampipe.io) are products produced from this open source software, exclusively by [Turbot HQ, Inc](https://turbot.com). They are distributed under our commercial terms. Others are allowed to make their own distribution of the software, but cannot use any of the Turbot trademarks, cloud services, etc. You can learn more in our [Open Source FAQ](https://turbot.com/open-source).

## Get Involved

**[Join #flowpipe on Slack →](https://turbot.com/community/join)**

Want to help but don't know where to start? Pick up one of the `help wanted` issues:

- [Flowpipe](https://github.com/turbot/flowpipe/labels/help%20wanted)
- [AWS CIS Mod](https://github.com/turbot/flowpipe-mod-aws-cis/labels/help%20wanted)
