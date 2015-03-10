# oh-my-vpn!
Setup your own OpenVPN server in 30 seconds! and secure your naked internet connections before it is too late.

### Installation:
Pick a new cheap server, CPU and Memory does not really matter
Make sure you get Ubuntu 14.10 as it is the only platform tested so far.
install the following dependencies
Pull down the repository to your server
run chef-solo

After your run chef-solo your OpenVPN server will be ready to use, except you
need to copy the key and certificate and install them into your favorite openvpn-client

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
### Supporting Operating Systems

``` Ubuntu 14.10 ```

### TODO
- Generate Client SSL certificates
- Email the client certificates to the user email
- Make one-liner command for installation
- Add recipe to configure the client machine
- Write system tests on top of docker and kitchen
- Pipe-line the project to Travis-ci for continous testing
- Add Support Ubuntu [14.04, 13.10, 13.04, 12.10, 12.04] and Debian [7.4, 7.0]
