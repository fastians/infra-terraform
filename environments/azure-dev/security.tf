resource "azurerm_network_security_group" "monitoring" {
  name                = "azure-dev-monitoring-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "AllowSSH"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.monitoring.name
}

resource "azurerm_network_security_rule" "grafana" {
  name                        = "AllowGrafana"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3000"
  source_address_prefix       = var.ingress_source_cidr
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.monitoring.name
}

resource "azurerm_network_security_rule" "loki" {
  name                        = "AllowLoki"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3100"
  source_address_prefix       = var.ingress_source_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.monitoring.name
}

resource "azurerm_network_security_rule" "prometheus" {
  name                        = "AllowPrometheus"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9090"
  source_address_prefix       = var.ingress_source_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.monitoring.name
}

resource "azurerm_network_security_rule" "alertmanager" {
  name                        = "AllowAlertmanager"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "9093"
  source_address_prefix       = var.ingress_source_cidr
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.monitoring.name
}

resource "azurerm_network_interface_security_group_association" "vm" {
  network_interface_id      = azurerm_network_interface.vm.id
  network_security_group_id = azurerm_network_security_group.monitoring.id
}

resource "azurerm_network_interface_security_group_association" "monitoring_server" {
  network_interface_id      = azurerm_network_interface.monitoring_server.id
  network_security_group_id = azurerm_network_security_group.monitoring.id
}
