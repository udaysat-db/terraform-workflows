resource "databricks_git_credential" "ado" {
  git_username          = "myuser"
  git_provider          = "azureDevOpsServices"
  personal_access_token = "sometoken"
}