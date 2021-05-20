This is a free openvpn client you can run using bash.

So you don't need proprietary clients anymore to run the VPN.

This client will install the VPN using a systemd service so that it starts when you boot your PC.

It will also use `iptables` to setup a "killswitch". iptables will be configured to only allow connections to the VPN server and the VPN DNS servers. All other connections to anything else will be blocked. You can future configure which ports will be opened by tuning on the tunnel interface.

This client will also configure your system to use the DNS servers provided by the VPN provider, in order to avoid DNS leaks.

# Requirements

1. The openvpn official client is suggested. See [here](https://community.openvpn.net/openvpn/wiki/OpenvpnSoftwareRepos) for installation instructions

    If you decide to use the openvpn client that comes with Ubuntu instead of the one provided above, notice that this client look for configuration files in `/etc/openvpn` instead of `/etc/openvpn/client`. Thus, to make it work, open `service_install.sh` and change

    `/etc/openvpn/client/bashvpn.conf`

    into

    `/etc/openvpn/bashvpn.conf`

2. iptables-persistent is needed in order to save iptables rules
`sudo apt-get install iptables-persistent`

3. Additional Packages required for script functionality

    - `network-manager` and `network-manager-openvpn` are both called in the installation script
    - `psmisc` will install the `killall` command

    ```bash
    sudo apt-get install network-manager network-manager-openvpn psmisc`
    ```

# Instructions

1. Rename `config.ini.template` into `config.ini`

2. Open `config.ini` and put inside the DNS servers provided by your VPN provider. It's important you use the DNS servers of your VPN provider and neither the ones you obtain through DHCP nor public ones in order to avoid DNS leaks

3. Your VPN provider should provide you with .ovpn configuration files to use the VPN through the openvpn client. Download them

4. To install the service, run `service_install.sh <OVPN FILE>`, substituting `<OVPN FILE>` with the configuration file provided by your VPN

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

    Also run 

    `sudo ip6tables -S | grep DROP`

    You should obtain the same output as above

4. Check your external IP address, for example [here](https://whatismyipaddress.com/).

5. You should prevent WebRTC from leaking local IP addresses. The [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) add-on has an option that does that. Install it in your browser and activate that option.


# Process

If you wish to run the VPN as a process, after running steps 1-3 above, use `connect_process.sh <OVPN FILE>`.

# Direct connection

If for some reason you want to disconnect the VPN, run `vpnmode_undo.sh`
