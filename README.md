# oh-my-vpn
Setup your own OpenVPN server in 30 seconds! and secure your naked internet connections before it is too late.

### Installation:

```
sudo aptitude update
sudo aptitude safe-upgrade -y -f
sudo aptitude install -y ruby ruby-dev build-essential wget git
sudo gem update --no-rdoc --no-ri
sudo gem install ohai chef --no-rdoc --no-ri

cd /tmp/ && git clone https://github.com/alaa/oh-my-vpn.git
sudo chef-solo -c /tmp/oh-my-vpn/solo.rb

```
### Supporting Operating Systems

``` ubuntu 14.10 ```
