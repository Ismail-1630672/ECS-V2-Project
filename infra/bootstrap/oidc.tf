resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

resource "aws_iam_role" "github_connect_aws" {
  name = "${var.project_name}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:Ismail-1630672/ECS-V2-Project:*"
        }
      }
    }]

  })

  tags = {
    Name = "${var.project_name}-github-actions-role"
  }
}

resource "aws_iam_role_policy" "ecs_deploy_policy" {
  name = "${var.project_name}-ecs-deploy-permissions"
  role = aws_iam_role.github_connect_aws.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchDeleteImage",
          "ecr:BatchGetImage",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:CompleteLayerUpload",
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:TagResource",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:ContinueServiceDeployment",
          "ecs:CreateService",
          "ecs:DeleteCluster",
          "ecs:DeleteService",
          "ecs:DeleteTaskDefinitions",
          "ecs:ListTagsForResource",
          "ecs:DeregisterTaskDefinition",
          "ecs:ExecuteCommand",
          "ecs:PutClusterCapacityProviders",
          "ecs:RegisterTaskDefinition",
          "ecs:RunTask",
          "ecs:StartTask",
          "ecs:StopServiceDeployment",
          "ecs:StopTask",
          "ecs:TagResource",
          "ecs:UntagResource",
          "ecs:UpdateService"

        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:AddListenerCertificates",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateRule",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteRule",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeListenerAttributes",
          "elasticloadbalancing:DescribeListenerCertificates",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:ModifyRule",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:RemoveListenerCertificates",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:SetWebAcl",
          "elasticloadbalancing:SetSecurityGroups",
          "elasticloadbalancing:SetSubnets",
          "elasticloadbalancing:ModifyListener"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "acm:DeleteCertificate",
          "acm:DescribeCertificate",
          "acm:GetCertificate",
          "acm:AddTagsToCertificate"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:TagQueue",
          "sqs:CreateQueue",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:ReceiveMessage",
          "sqs:GetQueueUrl",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:ListQueueTags",
          "sqs:SetQueueAttributes"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy:UpdateDeploymentGroup",
          "codedeploy:ContinueDeployment",
          "codedeploy:CreateApplication",
          "codedeploy:CreateDeployment",
          "codedeploy:CreateDeploymentConfig",
          "codedeploy:CreateDeploymentGroup",
          "codedeploy:DeleteApplication",
          "codedeploy:DeleteDeploymentConfig",
          "codedeploy:DeleteDeploymentGroup",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetDeploymentGroup",
          "codedeploy:GetDeploymentTarget",
          "codedeploy:StopDeployment",
          "codedeploy:TagResource",
          "codedeploy:UntagResource",
          "codedeploy:UpdateApplication",
          "codedeploy:RegisterApplicationRevision",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets",
          "secretsmanager:CreateSecret",
          "secretsmanager:TagResource",
          "secretsmanager:DeleteSecret",
          "secretsmanager:UpdateSecret",
          "secretsmanager:RotateSecret",
          "secretsmanager:PutSecretValue",
          "secretsmanager:DeleteResourcePolicy",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:DescribeSecret"

        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "rds:AddTagsToResource",
          "rds:CreateDBInstance",
          "rds:CreateDBSubnetGroup",
          "rds:CreateDBSnapshot",
          "rds:DeleteDBInstance",
          "rds:DeleteDBSubnetGroup",
          "rds:DescribeDBInstances",
          "rds:DescribeDBSubnetGroups",
          "rds:RebootDBInstance",
          "rds:ModifyDBInstance",
          "rds:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "elasticache:AddTagsToResource",
          "elasticache:CreateCacheCluster",
          "elasticache:CreateCacheSecurityGroup",
          "elasticache:CreateCacheSubnetGroup",
          "elasticache:DeleteCacheCluster",
          "elasticache:DeleteCacheSecurityGroup",
          "elasticache:DeleteCacheSubnetGroup",
          "elasticache:DescribeCacheClusters",
          "elasticache:DescribeCacheSecurityGroups",
          "elasticache:DescribeCacheSubnetGroups",
          "elasticache:ModifyCacheCluster",
          "elasticache:ModifyCacheSubnetGroup",
          "elasticache:ListTagsForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:TagLogGroup",
          "logs:TagResource",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:ListLogGroups",
          "logs:ListTagsLogGroup",
          "logs:ListTagsForResource",
          "logs:PutRetentionPolicy"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "wafv2:AssociateWebACL",
          "wafv2:CreateWebACL",
          "wafv2:TagResource",
          "wafv2:DeleteWebACL",
          "wafv2:DisassociateWebACL",
          "wafv2:GetWebACL",
          "wafv2:ListWebACLs",
          "wafv2:UpdateWebACL",
          "wafv2:ListTagsForResource",
          "wafv2:GetWebACLForResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTags",
          "ec2:AcceptVpcEndpointConnections",
          "ec2:AssignPrivateIpAddresses",
          "ec2:AssociateRouteTable",
          "ec2:AssociateSecurityGroupVpc",
          "ec2:AssociateSubnetCidrBlock",
          "ec2:AttachInternetGateway",
          "ec2:AttachNetworkInterface",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateInternetGateway",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:CreateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:CreateSubnet",
          "ec2:CreateVpc",
          "ec2:CreateVpcEndpoint",
          "ec2:DeleteInternetGateway",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteRouteTable",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteSubnet",
          "ec2:DeleteVpc",
          "ec2:DeleteVpcEndpoints",
          "ec2:DisassociateRouteTable",
          "ec2:DisassociateSecurityGroupVpc",
          "ec2:ModifyVpcEndpoint",
          "ec2:DetachInternetGateway",
          "ec2:DetachNetworkInterface",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:DisassociateRouteTable",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:GetRole",
          "iam:PutRolePolicy",
          "iam:TagRole",
          "iam:CreateOpenIDConnectProvider",
          "iam:PassRole",
          "iam:AttachRolePolicy",
          "iam:TagOpenIDConnectProvider",
          "iam:CreatePolicy",
          "iam:TagPolicy",
          "iam:DeleteOpenIDConnectProvider",
          "iam:DeletePolicy",
          "iam:DeleteRole",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
          "iam:GetOpenIDConnectProvider",
          "iam:GetPolicy",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:ListPolicies",
          "iam:ListPolicyTags",
          "iam:ListRolePolicies",
          "iam:ListRoleTags",
          "iam:ListRoles",
          "iam:TagOpenIDConnectProvider",
          "iam:TagPolicy",
          "iam:TagRole",
          "iam:UntagPolicy",
          "iam:UntagRole",
          "iam:UpdateOpenIDConnectProviderThumbprint",
          "iam:UpdateRole"
        ]
        Resource = "*"
      }
    ]
  })
}