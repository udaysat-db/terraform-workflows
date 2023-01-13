// creates a repo
resource "databricks_repo" "uday-test-repo" {
  url = "https://github.com/udaysat-db/test-repo.git"
  branch = "main"
}