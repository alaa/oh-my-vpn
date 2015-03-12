class Chef::Recipe::Filter
  def self.provisioned?
    ::File.exists?('/etc/openvpn/provisioned.lock')
  end
end
