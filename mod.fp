mod "aws_cis" {
  title         = "AWS CIS"
  description   = "Run pipelines to detect and correct AWS resources that are non-compliant with CIS benchmarks."
  color         = "#FF9900"
  documentation = file("./README.md")
  database      = var.database
  icon          = "/images/mods/turbot/aws-compliance.svg"
  categories    = ["aws", "compliance", "public cloud", "standard", "terminal"]

  opengraph {
    title       = "AWS CIS Mod for Flowpipe"
    description = "Run pipelines to detect and correct AWS resources that are non-compliant with CIS benchmarks."
    image       = "/images/mods/turbot/aws-compliance-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws-compliance" {
      version = "^1"
    }
  }
}
