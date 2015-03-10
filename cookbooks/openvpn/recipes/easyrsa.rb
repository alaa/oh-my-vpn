attr = node['easyrsa']

execute "bootstraping easy-rsa files" do
  command "cp -r /usr/share/easy-rsa/ /etc/openvpn"
  not_if { ::File.directory? '/etc/openvpn/easy-rsa' }
end

template "/etc/openvpn/easy-rsa/openssl-1.0.0.cnf" do
  source 'openssl-1.0.0.cnf.erb'
end

directory '/etc/openvpn/easy-rsa/keys' do
  action :create
end

%w(index.txt serial).each do |f|
  file "/etc/openvpn/easy-rsa/keys/#{f}" do
    action :create
  end
end

template "/etc/openvpn/easy-rsa/vars" do
  source 'easyrsa.vars.erb'
  variables(
    country: attr['key_country'],
    province: attr['key_province'],
    city: attr['key_city'],
    organization: attr['key_org'],
    email: attr['key_email'],
    organization_unit: attr['key_ou'],
    servername: attr['key_servername']
  )
end

execute 'Generate the Diffie-Hellman parameters' do
  command "openssl dhparam -out /etc/openvpn/dh#{attr['dh_key_size']}.pem #{attr['dh_key_size']}"
  not_if { ::File.exists?("/etc/openvpn/dh#{attr['dh_key_size']}.pem") }
end

execute 'Build Root key and Server key' do
  command "/bin/bash -c './clean-all && source ./vars && ./pkitool --initca && ./pkitool --server #{attr['key_servername']}'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/generated_by_chef.txt') }
end

execute 'Move root key, crt' do
  command "bash -c 'cp ./keys/{ca.key,ca.crt} /etc/openvpn'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/generated_by_chef.txt') }
end

execute 'Move server key, csr and crt' do
  command "bash -c 'cp ./keys/#{attr['key_servername']}.{csr,crt,key} /etc/openvpn'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/generated_by_chef.txt') }
end

service 'openvpn' do
  action :restart
  restart_command 'sudo service openvpn restart'
end
