# oh-my-vpn
Setup your own OpenVPN server in 30 seconds! and secure your naked internet connections before it is too late.

### Installation:
Pick a new cheap server, CPU and Memory does not really matter
Make sure you get ubuntu 14.10 as it is the only platfrom tested so far.
install the following dependencies
Pull down the repository to your server
run chef-solo

After your run chef-solor your openvpn server will be ready to use, except you
need to copy the key and certificate and install them into your favorite openvpn-client

### Dependecies first!

```
sudo aptitude update
sudo aptitude safe-upgrade -y -f
sudo aptitude install -y ruby ruby-dev build-essential wget git
sudo gem install ohai chef --no-rdoc --no-ri
```

### Pull the repo and run Chef-solo

```
cd /tmp/ && git clone https://github.com/alaa/oh-my-vpn.git
sudo chef-solo -c /tmp/oh-my-vpn/solo.rb

```
### Supporting Operating Systems

``` ubuntu 14.10 ```
