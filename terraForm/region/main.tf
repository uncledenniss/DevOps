resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.region
}



# Define subnet
resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Define public IP address
resource "azurerm_public_ip" "publicip" {
  name                = "${var.region}-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Define virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.region}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Define network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.region}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Define network security group rules (omitted for brevity)


resource "azurerm_network_security_group" "nsg" {
  name                = "${var.region}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Define firewall rules (omitted for brevity)


resource "azurerm_firewall" "firewall" {
  name                = "my-firewall"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name      = "FirewallRule"
    subnet_id = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.publicip.id
  }

}


# Define load balancer (omitted for brevity)

resource "azurerm_lb" "lb" {
  name                = "${var.region}-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}



# Define virtual machine
resource "azurerm_virtual_machine" "vm" {
  count                 = 5  # Change the count to 5 to deploy five VMs
  name                  = "${var.region}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = "${var.region}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  # source_image_reference {
  #   publisher = "MicrosoftWindowsServer"
  #   offer     = "WindowsServer"
  #   sku       = "2019-Datacenter"
  #   version   = "latest"
  # }

  tags = {
    environment = "testing"
  }
}

# Define traffic manager profile
resource "azurerm_traffic_manager_profile" "tm" {
  name                = "my-tm"
  resource_group_name = azurerm_resource_group.rg.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "myapp"
    ttl           = 30
  }

  monitor_config {
    protocol                    = "http"
    port                        = 80
    path                        = "/"
    # interval                    = 30
    # timeout                     = 10
    tolerated_number_of_failures = 3
  }

  # endpoint {
  #   name                = "region1"
  #   type                = "AzureEndpoints"
  #   target_resource_id = azurerm_lb.lb.id
  #   priority            = 1
  #   weight              = 100
  # }

  # endpoint {
  #   name                = "region2"
  #   type                = "AzureEndpoints"
  #   target_resource_id = azurerm_lb.lb.id
  #   priority            = 2
  #   weight              = 100
  # }
}
