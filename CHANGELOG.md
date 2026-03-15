## [1.1.0](https://github.com/islamelkadi/terraform-aws-vpc/compare/v1.0.1...v1.1.0) (2026-03-15)


### Features

* Complete Checkov Security Scan Integration and Suppressions ([#3](https://github.com/islamelkadi/terraform-aws-vpc/issues/3)) ([21a13bb](https://github.com/islamelkadi/terraform-aws-vpc/commit/21a13bbc48b439771f1f483fe9e9dadd45dae819))


### Bug Fixes

* add CKV_TF_1 suppression for external module metadata ([e4d6201](https://github.com/islamelkadi/terraform-aws-vpc/commit/e4d6201543254a00fcf4712af6895226489d0ba8))
* add skip-path for .external_modules in Checkov config ([c27fa8e](https://github.com/islamelkadi/terraform-aws-vpc/commit/c27fa8e811d8376c7d4472bc60627aed7b30471d))
* address Checkov security findings ([b2fe584](https://github.com/islamelkadi/terraform-aws-vpc/commit/b2fe584041c87addd91bad8551a7f4bea4f59060))
* correct .checkov.yaml format to use simple list instead of id/comment dict ([4469df8](https://github.com/islamelkadi/terraform-aws-vpc/commit/4469df8e1bfac601aa69ada5072a4bef9489d11e))
* remove skip-path from .checkov.yaml, rely on workflow-level skip_path ([3c45ccc](https://github.com/islamelkadi/terraform-aws-vpc/commit/3c45ccc263e45866358646623af6fe6f3d9004d5))
* update workflow path reference to terraform-security.yaml ([f0673db](https://github.com/islamelkadi/terraform-aws-vpc/commit/f0673dbc465168104afa1d33f781a5c3ce263715))


### Documentation

* add GitHub Actions workflow status badges ([359bd4c](https://github.com/islamelkadi/terraform-aws-vpc/commit/359bd4c4428e9993594f6a0e4dd82e797fcdf159))
* add security scan suppressions section to README ([7df169a](https://github.com/islamelkadi/terraform-aws-vpc/commit/7df169a0cb118fd44de45b78a8f52831dd4a4c24))

## [1.0.1](https://github.com/islamelkadi/terraform-aws-vpc/compare/v1.0.0...v1.0.1) (2026-03-08)


### Code Refactoring

* enhance examples with real infrastructure and improve code quality ([3d2aa54](https://github.com/islamelkadi/terraform-aws-vpc/commit/3d2aa54750743db28bca349663eac337ca647ec6))

## 1.0.0 (2026-03-07)


### ⚠ BREAKING CHANGES

* First publish - VPC Terraform module

### Features

* First publish - VPC Terraform module ([2ba5576](https://github.com/islamelkadi/terraform-aws-vpc/commit/2ba5576b2e2b5d007610486bb76e0bc0ab2e4083))
