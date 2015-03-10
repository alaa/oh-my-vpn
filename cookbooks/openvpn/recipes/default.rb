attr = node['openvpn']['server']

attr['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

template '/etc/openvpn/server.conf' do
  source 'server.conf.erb'
  variables(
    port: attr['port'],
    protocol: attr['protocol'],
    dev: attr['dev'],
    dh_key: node['easyrsa']['dh_key_size'],
    network_address: attr['network_address'],
    network_subnet: attr['network_subnet'],
    dns_servers: attr['dns_servers'],
    user: attr['user'],
    group: attr['group'],
    enable_redirect_gateway: attr['enable_redirect_gateway'],
    enable_client_to_client: attr['enable_client_to_client'],
    enable_compression: attr['enable_compression'],
    status_file: attr['status_file'],
    log_file: attr['log_file']
  )
end

execute 'enable port forwarding' do
  command 'echo 1 > /proc/sys/net/ipv4/ip_forward'
  not_if 'cat /proc/sys/net/ipv4/ip_forward | grep 1'
end

execute 'uncomment port-forwarding from sysctl' do
  command "sed -i '/#net.ipv4.ip_forward=1/c\net.ipv4.ip_forward=1/' /etc/sysctl.conf"
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

execute 'allow openvpn traffic' do
  command "iptables -t nat -A POSTROUTING -s #{attr['network_address']}/24 -o #{attr['network_interface']} -j MASQUERADE"
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

attr['acl'].each do |protocol, ports|
  ports.each do |port|
    execute "allow port: #{port}" do
      command "iptables -A INPUT -i #{attr['network_interface']} -p #{protocol} --dport #{port} -m state --state NEW,ESTABLISHED -j ACCEPT"
      command "iptables -A OUTPUT -o #{attr['network_interface']} -p #{protocol} --sport #{port} -m state --state ESTABLISHED -j ACCEPT"
      not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
    end
  end
end
