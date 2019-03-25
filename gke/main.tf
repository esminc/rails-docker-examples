provider "google-beta" {
  region  = "${var.region}"
  project = "${var.project}"
}

data "google_container_engine_versions" "default" {
  provider = "google-beta"

  location = "${var.zone}"
}

resource "google_project_service" "container" {
  provider = "google-beta"

  project            = "${var.project}"
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudresourcemanager" {
  provider = "google-beta"

  project            = "${var.project}"
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "servicenetworking" {
  provider = "google-beta"

  project            = "${var.project}"
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sqladmin" {
  provider = "google-beta"

  project            = "${var.project}"
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_network" "private_network" {
  provider   = "google-beta"
  depends_on = [
    "google_project_service.container",
    "google_project_service.cloudresourcemanager",
    "google_project_service.servicenetworking",
    "google_project_service.sqladmin",
  ]

  name                    = "${var.environment}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "private_subnet" {
  provider = "google-beta"

  name          = "${var.environment}"
  ip_cidr_range = "${var.private_subnet_cider}"
  network       = "${google_compute_network.private_network.self_link}"
  region        = "${var.region}"
}

resource "google_compute_global_address" "sql_peering" {
  provider = "google-beta"

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.private_network.self_link}"
}

resource "google_service_networking_connection" "sql_peering" {
  provider = "google-beta"

  network                 = "${google_compute_network.private_network.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.sql_peering.name}"]
}

resource "google_sql_database_instance" "primary" {
  provider   = "google-beta"
  depends_on = ["google_service_networking_connection.sql_peering"]

  region           = "${var.region}"
  database_version = "POSTGRES_9_6"

  settings {
    tier = "${var.db_machine_type}"

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "${google_compute_network.private_network.self_link}"
    }
  }

  provisioner "local-exec" {
    # FIXME: password...
    command = "gcloud sql users create postgres --instance=${self.name} --password=postgres --project=${var.project}"
  }
}

resource "google_container_cluster" "primary" {
  provider = "google-beta"

  name               = "${var.environment}"
  location           = "${var.region}-c"
  node_locations     = ["asia-northeast1-a", "asia-northeast1-b"]
  min_master_version = "${data.google_container_engine_versions.default.latest_master_version}"
  network            = "${google_compute_network.private_network.self_link}"
  subnetwork         = "${google_compute_subnetwork.private_subnet.self_link}"

  ip_allocation_policy = {
    cluster_ipv4_cidr_block = "${var.k8s_cluster_cider}"
    services_ipv4_cidr_block = "${var.k8s_services_cider}"
  }

  # manage another dedicated pool
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary" {
  provider = "google-beta"

  name       = "${var.environment}-node-pool"
  location   = "${var.region}-c"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = "${var.k8s_node_count}"

  node_config {
    machine_type = "${var.k8s_node_machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata {
      "disable-legacy-endpoints" = "true"
    }
  }
}
