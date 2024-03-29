#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "namespace" {
  default = "higgs-tutorial"
}

variable "notebook-image" {
  default = "lukasheinrich/higgsplot:20190715"
}

variable "higgs-cms-image" {
  default = "gcr.io/mmm-goog-ad-higgs/cms-higgs-4l-full"
}

variable "higgs-worker-image" {
  default = "gcr.io/mmm-goog-ad-higgs/worker"
}

output "namespace" {
  value = "${var.namespace}"
}

output "jupytertoken" {
  value = "${random_string.jupytertoken.result}"
}

output "jupyter-url" {
  value = "http://${kubernetes_service.jupyter.load_balancer_ingress[0].ip}:8888/?token=${random_string.jupytertoken.result}"
}
