data "aws_iam_user" "gitlab_ci_user" {
  user_name = "gitlab-ci-user"
}

data "aws_iam_role" "gitlab_ci_ec2_role" {
  name = "gitlab-ci-ec2-role"
}

data "aws_iam_role" "gitlab_ci_codedeploy_role" {
  name = "gitlab-ci-codedeploy-role"
}