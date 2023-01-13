data "databricks_current_user" "me" {}
data "databricks_spark_version" "latest" {}
data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}
data "databricks_node_type" "smallest" {    
  local_disk = true
}

# provisioning notebooks
resource "databricks_notebook" "nb_1" {
  source = "/Users/uday.satapathy/Documents/src/sample-local-repo/local-nb-1.py"
  path   = "${data.databricks_current_user.me.home}/Terraform/notebooks/nb-1"
}

resource "databricks_notebook" "nb_2" {
  source = "/Users/uday.satapathy/Documents/src/sample-local-repo/local-nb-2.py"
  path   = "${data.databricks_current_user.me.home}/Terraform/notebooks/nb-2"
}

resource "databricks_notebook" "nb_3" {
  source = "/Users/uday.satapathy/Documents/src/sample-local-repo/local-nb-3.py"
  path   = "${data.databricks_current_user.me.home}/Terraform/notebooks/nb-3"
}

# # create multi-task job cluster
# resource "databricks_cluster" "shared_01" {
#   cluster_name            = "uday_terraform_multi-task-job_cluster_01"
#   spark_version           = data.databricks_spark_version.latest_lts.id
#   node_type_id            = data.databricks_node_type.smallest.id
#   autotermination_minutes = 20
#   autoscale {
#     min_workers = 1
#     max_workers = 2
#   }
# }

# create a multi-task job
resource "databricks_job" "this" {
  name = "Job with multiple tasks 03"

  job_cluster {
    job_cluster_key = "uday_terraform_multi-task-job_cluster_02"
    new_cluster {
      num_workers   = 2
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }
  }

  schedule {
    quartz_cron_expression = "0 0 0 ? 1/1 * *"
    timezone_id = "UTC"
   }

  email_notifications {
    on_failure = [ "uday.satapathy@databricks.com", "udaya.satapathy@outlook.com" ]
    on_start = [ "uday.satapathy@databricks.com" ]
    on_success = [ "uday.satapathy@databricks.com" ]
  }

  git_source {
      url = "https://github.com/udaysat-db/test-repo.git"
      provider = "gitHub"
      branch = "main"
    }

  task {
    task_key = "task-1"

    new_cluster {
      num_workers   = 1
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }

    notebook_task {
      notebook_path = "nb-1"
    }
  }

  task {
    task_key = "task-2"
    # this task will only run after task 1
    depends_on {
      task_key = "task-1"
    }

    notebook_task {
      notebook_path = "nb-2"
    }

    new_cluster {
      num_workers   = 1
      spark_version = data.databricks_spark_version.latest.id
      node_type_id  = data.databricks_node_type.smallest.id
    }

  }

}