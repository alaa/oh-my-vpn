# oh-my-vpn!
Setup your own OpenVPN server in 30 seconds! and secure your naked internet connections before it is too late.

### Server Setup
Pick a new cheap server, CPU and Memory does not really matter
Install the required dependencies
Pull down the repository to your server
run chef-solo

### Install the dependencies first:

```
sudo aptitude update
sudo aptitude safe-upgrade -y -f
sudo aptitude install -y ruby ruby-dev build-essential wget git
sudo gem install ohai chef --no-rdoc --no-ri
```

### Pull-down the code and run chef-solo

```
cd /tmp/ && git clone https://github.com/alaa/oh-my-vpn.git
sudo chef-solo -c /tmp/oh-my-vpn/solo.rb
```

### Post-Installation
After your run chef-solo, your OpenVPN server will be ready:
- Copy the generated config ```/root/client.conf``` and place it in your laptop at ```/etc/openvpn```
- Restart openvpn service on your laptop ``` service openvpn restart```

### Supporting Operating Systems

``` Ubuntu 14.10 ```
``` Ubuntu 13.10 ```

### TODO
- Email the client certificates to the user email
- Make one-liner command for installation
- Add recipe to configure the client machine
- Pipe-line the project to Travis-ci for continous testing
- Add Support Ubuntu [14.04, 13.04, 12.10, 12.04] and Debian [7.4, 7.0]
