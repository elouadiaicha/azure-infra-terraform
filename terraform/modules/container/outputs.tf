# TODO : exposer le FQDN public du container
#
# output "fqdn" {
#   value = azurerm_container_group.aci.fqdn
# }
output "fqdn" {
  value = azurerm_container_group.aci.fqdn
}