variable "aws_region" {
  type = string
}
variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "kubernetes_version" {
  type = any
}

variable "workers_instance_type" {
  type = string
}

variable "workers_desired" {
  type = number
}

variable "workers_max" {
  type = number
}

variable "workers_min" {
  type = number
}