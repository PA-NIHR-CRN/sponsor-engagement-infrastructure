variable "env" {
  description = "environment name"
  type        = string

}
variable "system" {
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string

}

variable "ecs_subnets" {
  description = "list of subnets for ecs"
  type        = list(any)

}

variable "lb_subnets" {
  description = "list of subnets for lb"
  type        = list(any)

}

variable "account" {
  description = "account name"
  type        = string
  default     = "nihrd"

}


variable "container_name" {
  description = "container"
  type        = string

}

variable "ecs_cpu" {
}

variable "ecs_memory" {
}

variable "image_url" {
  description = "container image url"
  type        = string


}

#env

variable "instance_count" {
}

variable "logs_bucket" {
}

variable "whitelist_ips" {
}

variable "domain_name" {

}

variable "validation_email" {

}

variable "ingress_rules" {
  description = "List of ingress rules with IP and description"
  # type = mlist(object({
  #   ip          = string
  #   description = string
  # }))
}
