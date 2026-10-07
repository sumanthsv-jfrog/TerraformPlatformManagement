locals {
  repo_map = {
    for repo in var.repositories :
    repo.name => repo
  }

  local_packages = [
    "generic", "docker", "maven", "npm", "pypi", "helm", "go", "gradle",
    "debian", "rpm", "nuget", "conan", "cargo", "gems", "composer",
    "terraform_module", "terraform_provider", "oci", "alpine", "ansible", "nix",
  ]

  remote_packages = [
    "generic", "docker", "maven", "npm", "pypi", "helm", "go", "gradle",
    "debian", "rpm", "nuget", "conan", "cargo", "gems", "composer",
    "terraform", "oci", "vcs", "alpine", "ansible",
  ]

  virtual_packages = [
    "generic", "docker", "maven", "npm", "pypi", "helm", "go", "gradle",
    "nuget", "conan", "debian", "rpm", "alpine", "oci",
  ]

  federated_packages = [
    "generic", "docker", "maven", "npm", "helm", "go", "gradle",
    "nuget", "conan", "cargo", "debian", "rpm", "alpine", "oci",
  ]

  supported_combinations = concat(
    [for pkg in local.local_packages : "local:${pkg}"],
    [for pkg in local.remote_packages : "remote:${pkg}"],
    [for pkg in local.virtual_packages : "virtual:${pkg}"],
    [for pkg in local.federated_packages : "federated:${pkg}"],
  )

  repos_grouped = merge(
    {
      for pkg in local.local_packages :
      "local_${pkg}" => {
        for name, repo in local.repo_map :
        name => repo
        if repo.repo_type == "local" && repo.package_type == pkg
      }
    },
    {
      for pkg in local.remote_packages :
      "remote_${pkg}" => {
        for name, repo in local.repo_map :
        name => repo
        if repo.repo_type == "remote" && repo.package_type == pkg
      }
    },
    {
      for pkg in local.virtual_packages :
      "virtual_${pkg}" => {
        for name, repo in local.repo_map :
        name => repo
        if repo.repo_type == "virtual" && repo.package_type == pkg
      }
    },
    {
      for pkg in local.federated_packages :
      "federated_${pkg}" => {
        for name, repo in local.repo_map :
        name => repo
        if repo.repo_type == "federated" && repo.package_type == pkg
      }
    },
  )
}
