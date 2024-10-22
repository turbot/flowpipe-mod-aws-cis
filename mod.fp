mod "aws_cis" {
  title         = "AWS CIS"
  description   = "Run pipelines to detect and correct AWS resources that are non-compliant with CIS."
  color         = "#FF9900"
  documentation = file("./README.md")
  icon          = "/images/mods/turbot/aws-compliance.svg"
  categories    = ["aws", "compliance", "public cloud", "standard", "terminal"]

  opengraph {
    title       = "AWS CIS Mod for Flowpipe"
    description = "Run pipelines to detect and correct AWS resources that are non-compliant with CIS."
    image       = "/images/mods/turbot/aws-compliance-social-graphic.png"
  }

  require {
    flowpipe {
      min_version = "1.0.0"
    }
    mod "github.com/turbot/flowpipe-mod-aws-compliance" {
      version = "v1.0.0-rc.11"
    }
  }
}
