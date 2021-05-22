# Introduction

`bashvpn` is a free openvpn client you can run using bash.

So you don't need proprietary clients anymore to run the VPN.

This client will install the VPN using a systemd service so that it starts when you boot your PC.

It will also use `iptables` to setup a "killswitch".

`iptables` will be configured to only allow packets from/to the VPN server and the VPN DNS servers.

All other packets will be dropped.

You can further configure which ports will be opened by tuning on the tunnel interface.

This client will also configure your system to use the DNS servers provided by the VPN provider, in order to avoid DNS leaks.

# Requirements

1. For Ubuntu users, the openvpn official client is suggested. See [here](https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos) for installation instructions.

    Fedora users are fine with `sudo dnf install openvpn`.

2. iptables-persistent is needed in order to save iptables rules.

    For Ubuntu users, run `sudo apt-get install iptables-persistent`.

    For Fedora users, run `sudo dnf install iptables-services`.

3. Additional Packages required for script functionality. We need NetworkManager and the `killall` command.

    For Ubuntu users, run `sudo apt-get install psmisc`.

    For Debian users, run `sudo apt-get install network-manager network-manager-openvpn psmisc`.

    For Fedora users, you should be fine.

# Instructions

1. Rename `config.ini.template` into `config.ini`

2. Open `config.ini` and modify as follows:

    `DNS1=` put here the first DNS server provided by your VPN provider. Don't use public DNS servers like Google's in order to avoid DNS leaks. Use the DNS server of your VPN provider.

    `DNS2` second DNS server of your VPN provider.

    `IP4TABLES_FILE` where to save iptables rules. On Fedora this is `/etc/sysconfig/iptables` which is the default. If you are running a different distribution, try looking into `usr/lib/systemd/system/iptables.service`, read the docs of your distro or open an issue in this repository.

    `IP6TABLES_FILE` as above but for IP6. Defaults to `/etc/sysconfig/ip6tables`.

    `OPENVPN_CONF_DIR` where openvpn is looking for configuration files. On Fedora and on Ubuntu running the openvpn client from the official open repositories, this is `/etc/openvpn/client`, which is the default. On Ubuntu running the openvpn client found in the Ubuntu's repositories, not the OpenVPN official repositories, this is `/etc/openvpn`.

3. Your VPN provider should provide you with .ovpn configuration files to use the VPN through the openvpn client. Download them.

4. To install the service, run `service_install.sh [OVPN_FILE]`, substituting `[OVPN_FILE]` with the .ovpn configuration file provided by your VPN.

These steps must be run only once. The VPN tunnel will be enabled as a systemd service and should boot up with your computer.

# Checking the tunnel

You should check that everything works

1. **MOST VPN PROVIDERS HAVE A WEB PAGE THAT CHECKS WHETHER THE VPN IS WORKING. USE IT TO CHECK THAT THE VPN IS REALLY WORKING**.

2. Check you are not subject to DNS leaks by running [this test](https://www.dnsleaktest.com/). You can learn about DNS leaks [here](https://proprivacy.com/vpn/guides/dns-leak-protection).

3. Check the killswitch.

    Run

    `sudo iptables -S | grep DROP`

    The output should be

    > -P INPUT DROP
    > -P FORWARD DROP
    > -P OUTPUT DROP

    Also run:

    `sudo ip6tables -S | grep DROP`

    You should obtain the same output as above

4. Check your external IP address, for example [here](https://whatismyipaddress.com/).

5. You should prevent WebRTC from leaking local IP addresses. The [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) add-on has an option that does that. Install it in your browser and activate that option.


# Process

If you wish to run the VPN as a process, after running steps 1-3 above, use `connect_process.sh [OVPN_FILE]`.

# Direct connection

If for some reason you want to disconnect the VPN:

* If you installed as a service, call `service_uninstall.sh`
* Kill the process if you used `connect_process.sh` (just press CTRL+C)
