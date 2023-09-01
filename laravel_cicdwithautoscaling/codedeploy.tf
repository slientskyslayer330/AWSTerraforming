resource "aws_codedeploy_app" "laravel_code_deploy" {
  compute_platform = "Server"
  name             = "LaravelCodeDeploy"
  tags = {
    Name = "LaravelCodeDeploy"
  }
}

resource "aws_codedeploy_deployment_group" "laravel_code_deploy_group" {
  app_name               = aws_codedeploy_app.laravel_code_deploy.name
  deployment_group_name  = "LaravelCodeDeploy"
  service_role_arn       = data.aws_iam_role.gitlab_ci_codedeploy_role.arn
  autoscaling_groups     = [aws_autoscaling_group.laravel_asg.id]
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
  blue_green_deployment_config {
    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 15
    }
  }
  load_balancer_info {
    target_group_info {
      name = aws_alb_target_group.laravel_tg.name
    }
  }
  tags = {
    Name = "LaravelCodeDeploy"
  }
}