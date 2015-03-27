# oh-my-vpn!
Setup your own OpenVPN server in ~30 seconds! and secure your naked internet connections before it is too late.

### Why?
If you are not paranoid about security, well you should start reading!

### Server Setup
Pick a new cheap server, CPU and Memory does not really matter
Cloud providers are awesome for this setup

### Use the one-liner script (Server):
```
curl -L https://git.io/pdTu | sh
```
This will take care about setting up the Server for you, and generates the client config files for you at the following paths:

- ```/root/client.conf```
- ```/root/client.ovpn```

The client config files are actually ```Readable``` and ```Identical```, But some OpenVPN clients requires different file extension.

### Post-Installation (Client):

- Install OpenVPN client your machine.
- Copy the client configurations file ```client.conf``` or ```client.ovpn``` and import it to your favorite OpenVPN client.

### Supported Operating Systems (Tested):

- ``` Ubuntu 14.10 ```
- ``` Ubuntu 14.04 ```
- ``` Ubuntu 13.10 ```
- ``` Debian 7.0 ```
- ``` Debian 7.4 ```
- ``` Debian 7.6 ```
- ``` Debian 7.8 ```

### TODO
- Build Docker image for Server
- Build Docker image for client and route client connections through the container 
- Pipe-line the project to Travis-ci for continous testing
- Add Support for other platforms: Centos, Fedora, OpenSUSE, Archlinux, Gentoo
- Add Multi-Client support
- Improve the README

#### Contribute
- Fork and submit pull requests
- For new features or refactoring make sure all kitchen tests pass on all platforms
- You can run the tests:
```
cd cookbooks/openvpn/
kitchen verify -c 6
```
