terraform {
  cloud {
    organization = "njulug"

    workspaces {
      name = "infrastructure"
    }
  }
}