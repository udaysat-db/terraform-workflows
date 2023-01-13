terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
      version = "1.2.0"
    }
  }
}

provider "databricks" {
  host  = "https://e2-demo-field-eng.cloud.databricks.com"
  token = "my-databricks-token"
}
