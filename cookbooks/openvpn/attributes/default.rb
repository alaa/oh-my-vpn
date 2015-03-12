# Defaults
packages = %w(openvpn iptables)
if node['platform'] != "debian"
  packages += ['easy-rsa']
end
default['openvpn']['server']['packages'] = packages
default['openvpn']['server']['port'] = 1194
default['openvpn']['server']['protocol'] = 'udp'
default['openvpn']['server']['dev'] = 'tun'

# Network
default['openvpn']['server']['network_address'] = '10.8.0.0'
default['openvpn']['server']['network_subnet'] = '255.255.255.0'
default['openvpn']['server']['network_interface'] = node['network']['default_interface']
default['openvpn']['server']['dns_servers'] = ['109.74.192.20', '109.74.193.20']
default['openvpn']['server']['acl'] = { 'tcp' => [53, 22], 'udp' => [53, 1194] }

# Auth
default['openvpn']['server']['user'] = 'nobody'
default['openvpn']['server']['group'] = 'nogroup'

# Flags
default['openvpn']['server']['enable_redirect_gateway'] = true
default['openvpn']['server']['enable_client_to_client'] = true
default['openvpn']['server']['enable_compression'] = true

# Logging
default['openvpn']['server']['status_file'] = 'openvpn-status.log'
default['openvpn']['server']['log_file'] = 'openvpn.log'
