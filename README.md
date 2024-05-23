# **Route Through Tor**

Setting up a Linux system to route all outgoing traffic through the Tor network involves several steps. 
A bash script to achieve this. 
This script assumes you have tor and iptables installed. 

**TODO:**
*Adaptation to piguard*

- Start service at boot or when connection lost with wireguard. 
- Take into account iptable rules loaded for Wireguard.
- Add obfsproxy IP bridges. 

