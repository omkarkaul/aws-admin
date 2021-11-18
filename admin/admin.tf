# Config for Admin user group with Admin policy, and Admin user
resource "aws_iam_group" "admin_group" {
    name = "Admin"
}

resource "aws_iam_user" "admin" {
    name = "GlobalAdmin"
}

resource "aws_iam_user_group_membership" "admin_membership" {
    user = aws_iam_user.admin.name
    groups = [
        aws_iam_group.admin_group.name
    ]
}

resource "aws_iam_group_policy" "global_admin_policy" {
    name = "GlobalAdminPolicy"
    group = aws_iam_group.admin_group.name
    policy = file("admin-policy.json")
}
