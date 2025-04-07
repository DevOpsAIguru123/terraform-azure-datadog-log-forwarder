########################################
# Private Endpoints for Storage Account
########################################

# Private DNS Zone for Blob Storage
resource "azurerm_private_dns_zone" "private_dns_zone_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = module.prerequisites.resource_group_name
}

# Private DNS Zone for File Storage
resource "azurerm_private_dns_zone" "private_dns_zone_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = module.prerequisites.resource_group_name
}

# Private DNS Zone for Table Storage
resource "azurerm_private_dns_zone" "private_dns_zone_table" {
  name                = "privatelink.table.core.windows.net"
  resource_group_name = module.prerequisites.resource_group_name
}

# Private DNS Zone for Queue Storage
resource "azurerm_private_dns_zone" "private_dns_zone_queue" {
  name                = "privatelink.queue.core.windows.net"
  resource_group_name = module.prerequisites.resource_group_name
}

# Link the Private DNS Zones to the VNet
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link_blob" {
  name                  = "dns-zone-link-blob"
  resource_group_name   = module.prerequisites.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_blob.name
  virtual_network_id    = module.prerequisites.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link_file" {
  name                  = "dns-zone-link-file"
  resource_group_name   = module.prerequisites.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_file.name
  virtual_network_id    = module.prerequisites.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link_table" {
  name                  = "dns-zone-link-table"
  resource_group_name   = module.prerequisites.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_table.name
  virtual_network_id    = module.prerequisites.vnet_id
  registration_enabled  = false
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link_queue" {
  name                  = "dns-zone-link-queue"
  resource_group_name   = module.prerequisites.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_queue.name
  virtual_network_id    = module.prerequisites.vnet_id
  registration_enabled  = false
}

# Private Endpoint for Blob Storage
resource "azurerm_private_endpoint" "blob_private_endpoint" {
  name                = "pe-blob-storage-${random_string.id.result}"
  location            = var.location
  resource_group_name = module.prerequisites.resource_group_name
  subnet_id           = module.prerequisites.snet_001_id

  private_service_connection {
    name                           = "psc-blob-${random_string.id.result}"
    private_connection_resource_id = module.prerequisites.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_blob.id]
  }
}

# Private Endpoint for File Storage
resource "azurerm_private_endpoint" "file_private_endpoint" {
  name                = "pe-file-storage-${random_string.id.result}"
  location            = var.location
  resource_group_name = module.prerequisites.resource_group_name
  subnet_id           = module.prerequisites.snet_001_id

  private_service_connection {
    name                           = "psc-file-${random_string.id.result}"
    private_connection_resource_id = module.prerequisites.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_file.id]
  }
}

# Private Endpoint for Table Storage
resource "azurerm_private_endpoint" "table_private_endpoint" {
  name                = "pe-table-storage-${random_string.id.result}"
  location            = var.location
  resource_group_name = module.prerequisites.resource_group_name
  subnet_id           = module.prerequisites.snet_001_id

  private_service_connection {
    name                           = "psc-table-${random_string.id.result}"
    private_connection_resource_id = module.prerequisites.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-table"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_table.id]
  }
}

# Private Endpoint for Queue Storage
resource "azurerm_private_endpoint" "queue_private_endpoint" {
  name                = "pe-queue-storage-${random_string.id.result}"
  location            = var.location
  resource_group_name = module.prerequisites.resource_group_name
  subnet_id           = module.prerequisites.snet_001_id

  private_service_connection {
    name                           = "psc-queue-${random_string.id.result}"
    private_connection_resource_id = module.prerequisites.storage_account_id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group-queue"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_queue.id]
  }
} 