resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "ace3b69b-d0b9-49e9-9b73-d773fa99864e"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "b546df32-1a0c-4d19-ba3c-0d80ec882d77"
  }
}

# Create subnet
resource "azurerm_subnet" "my_terraform_subnet" {
  name                 = "${random_pet.prefix.id}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "${random_pet.prefix.id}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "35dbfd2e-d14c-45c2-89ce-1e454d0a1263"
  }
}

# Create Network Security Group and rules
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "${random_pet.prefix.id}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "90baf987-059a-4c49-b70b-1cfa782597a5"
  }
}

# Create network interface
resource "azurerm_network_interface" "my_terraform_nic" {
  name                = "${random_pet.prefix.id}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "my_nic_configuration"
    subnet_id                     = azurerm_subnet.my_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "8b38e315-a966-47d4-ad8d-290557b17103"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.my_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  admin_username        = "azureuser"
  admin_password        = random_password.password.result
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "ac5c6f53-b0f3-44d1-98c3-3ad82fc70a76"
  }
}

# Install IIS web server to the virtual machine
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "${random_pet.prefix.id}-wsi"
  virtual_machine_id         = azurerm_windows_virtual_machine.main.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
  SETTINGS
  tags = {
    git_commit           = "b3d834cdc3a69cba9ec98066fa16108f086fd525"
    git_file             = "main.tf"
    git_last_modified_at = "2023-03-22 20:39:36"
    git_last_modified_by = "113141616+blahsi@users.noreply.github.com"
    git_modifiers        = "113141616+blahsi"
    git_org              = "blahsi"
    git_repo             = "test"
    yor_trace            = "80fc2a45-960e-4be2-a693-80cc2b136c80"
  }
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "random_password" "password" {
  length      = 20
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
  special     = true
}

resource "random_pet" "prefix" {
  prefix = var.prefix
  length = 1
}
