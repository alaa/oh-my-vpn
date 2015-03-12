require 'spec_helper'

@openvpn_home = '/etc/openvpn/'
@easyrsa_home = File.join(@openvpn_home, 'easy-rsa')
@easyrsa_keys = File.join(@easyrsa_home, 'keys')

@dh_key = File.join(@openvpn_home, 'dh2048.pem')
@root_crt = File.join(@openvpn_home, 'ca.crt')
@root_key = File.join(@openvpn_home, 'ca.key')
@server_crt = File.join(@openvpn_home, 'myopenvpn.crt')
@server_csr = File.join(@easyrsa_keys, 'myopenvpn.csr')
@server_key = File.join(@openvpn_home, 'myopenvpn.key')

@server_config = File.join(@openvpn_home, 'server.conf')
@openssl_1_0_0 = File.join(@easyrsa_home, 'openssl-1.0.0.cnf')
@vars = File.join(@easyrsa_home, 'vars')

@client_config = File.join('/root/', 'client.conf')

@files = [@root_key, @root_crt, @server_crt, @server_key, @server_csr,
          @server_config, @openssl_1_0_0, @vars, @client_config]

@dirs = [@openvpn_home, @easyrsa_home, @easyrsa_keys]


@files.each do |file|
  describe file(file) do
    it { should be_file }
  end

  describe command("du -sh #{file}") do
    its(:stdout) { should_not match(/^0/) }
  end
end

describe service("openvpn") do
  it { should be_enabled }
  it { should be_running }
end

@dirs.each do |dir|
  describe file(dir) do
    it { should be_directory }
  end
end

describe file(@server_config) do
  its(:content) { should match(/^port 1194/) }
  its(:content) { should match(/^proto udp/) }
  its(:content) { should match(/^dev tun/) }
  its(:content) { should match(/^dh dh2048.pem/) }
  its(:content) { should match(/^push \"redirect-gateway def1 bypass-dhcp\"/) }
  its(:content) { should match(/^push \"dhcp\-option DNS/) }
  its(:content) { should match(/^client\-to\-client/) }
  its(:content) { should match(/^comp\-lzo/) }
  its(:content) { should match(/^user nobody/) }
  its(:content) { should match(/^group nogroup/) }
end

describe port(1194) do
  it { should be_listening.with('udp') }
end

describe interface('tun0') do
  it { should exist }
end

describe iptables do
  {udp: [1194, 53], tcp: [53]}.each do |proto, ports|
    ports.each do |port|
      it { should have_rule("-A OUTPUT -o eth0 -p #{proto} -m #{proto} --sport #{port} -m state --state ESTABLISHED -j ACCEPT") }
      it { should have_rule("-A INPUT -i eth0 -p #{proto} -m #{proto} --dport #{port} -m state --state NEW,ESTABLISHED -j ACCEPT") }
    end
  end
end
