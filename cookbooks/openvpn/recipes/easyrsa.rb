attr = node['easyrsa']

execute "bootstraping easy-rsa files" do
  command "cp -r /usr/share/easy-rsa/ /etc/openvpn"
  not_if { ::File.directory? '/etc/openvpn/easy-rsa' }
end

template "/etc/openvpn/easy-rsa/openssl-1.0.0.cnf" do
  source 'openssl-1.0.0.cnf.erb'
end

template "/etc/openvpn/easy-rsa/vars" do
  source 'easyrsa.vars.erb'
  variables(country: attr['key_country'],
            province: attr['key_province'],
            city: attr['key_city'],
            organization: attr['key_org'],
            email: attr['key_email'],
            organization_unit: attr['key_ou'],
            servername: attr['key_servername'])
end

directory '/etc/openvpn/easy-rsa/keys' do
  action :create
end

file "/etc/openvpn/easy-rsa/keys/serial" do
  action :create
  content '01'
end

file "/etc/openvpn/easy-rsa/keys/index.txt" do
  action :create
end

execute 'clean old certifications/keys' do
  command "./clean-all"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

execute 'Generate the Diffie-Hellman key' do
  command "openssl dhparam -out /etc/openvpn/dh#{attr['dh_key_size']}.pem #{attr['dh_key_size']}"
  not_if { ::File.exists?("/etc/openvpn/dh#{attr['dh_key_size']}.pem") }
end

execute 'build root cert' do
  command "/bin/bash -c './clean-all && source ./vars && ./pkitool --initca --batch'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

execute 'build server cert/key' do
  command "/bin/bash -c 'source ./vars && ./pkitool --server #{attr['key_servername']} --batch'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

execute 'build client cert/key' do
  command "/bin/bash -c '> keys/index.txt && source ./vars && ./pkitool client --batch'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

execute 'Move root cert/key to openvpn home' do
  command "bash -c 'cp ./keys/{ca.key,ca.crt} /etc/openvpn'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

execute 'Move server cert/key to openvpn home' do
  command "bash -c 'cp ./keys/#{attr['key_servername']}.{crt,key} /etc/openvpn'"
  cwd '/etc/openvpn/easy-rsa'
  not_if { ::File.exists?('/etc/openvpn/provisioned.lock') }
end

service 'openvpn' do
  action :restart
end

file '/etc/openvpn/provisioned.lock' do
  content { Time.now }
  only_if { `service openvpn status`.match(/is running/) }
end

template '/root/client.conf' do
  source 'client.conf.erb'
  variables(
    lazy {
      {
        ca:   File.open('/etc/openvpn/ca.crt').read,
        cert: File.open("/etc/openvpn/easy-rsa/keys/client.crt").read,
        key:  File.open("/etc/openvpn/easy-rsa/keys/client.key").read
      }
    }
  )
end
