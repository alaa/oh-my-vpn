# oh-my-vpn!
Setup your own OpenVPN server in ~30 seconds! and secure your naked internet connections before it is too late.

### Server Setup
Pick a new cheap server, CPU and Memory does not really matter
The following one-liner script installs Chef and related depedencies and provision openvpn-server and generates the client configuration file.

### Use the one-liner script (Server):
```
curl -L https://git.io/pdTu | sh
```
A generated file for openvpn-client should exist at ```/root/client.conf```

### Post-Installation (Client):

- Install OpenVPN on your machine.
- Copy the client-config and place it under your OpenVPN client configuration directory  ```/etc/openvpn```
- Restart openvpn service on your laptop ``` service openvpn restart```

If you are using GUI OpenVPN client, you can just read the generated configuration file and replicate the config to your GUI client, ```It is readable by humans```. Also you will find the SSL certificates embded into the file. 

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
