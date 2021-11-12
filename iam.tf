resource "aws_iam_role" "eks-assume-role" {
  name               = "${local.cluster_name}-role-account"
  assume_role_policy = data.aws_iam_policy_document.eks-assume-role-policy.json
}

data "aws_iam_policy_document" "eks-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks-attach-role" {
  role       = aws_iam_role.eks-assume-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

