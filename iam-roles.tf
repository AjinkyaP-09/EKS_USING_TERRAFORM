# This creates the IAM policy needed by the AWS Load Balancer Controller
# You must attach this role to the ServiceAccount in Kubernetes later

data "aws_iam_policy_document" "alb_controller_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "eks-alb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume.json
}

# In a real scenario, download the full IAM policy JSON from AWS docs. 
# For brevity, I am attaching a managed policy if available or a simplified one.
# IMPORTANT: For production, use the full policy.json from AWS Load Balancer Controller docs.
resource "aws_iam_role_policy_attachment" "alb_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess" # Simplified for demo
  role       = aws_iam_role.alb_controller.name
}

output "alb_role_arn" {
  value = aws_iam_role.alb_controller.arn
}
