# Start the Tor service
service tor start

# Get the Tor TransPort and DNSPort from torrc configuration
TOR_TRANSPORT_PORT=9040
TOR_DNS_PORT=5353

# Set up iptables rules

# Flush old rules
iptables -F
iptables -t nat -F

# Set default policies to accept
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Allow all traffic on the loopback interface
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related incoming connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Redirect DNS requests to Tor
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT
iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports $TOR_DNS_PORT

# Redirect all other traffic to Tor
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TOR_TRANSPORT_PORT

# Prevent local network traffic from being redirected to Tor
iptables -t nat -A OUTPUT -d 127.0.0.0/8 -j RETURN
iptables -t nat -A OUTPUT -d 192.168.0.0/16 -j RETURN
iptables -t nat -A OUTPUT -d 10.0.0.0/8 -j RETURN
iptables -t nat -A OUTPUT -d 172.16.0.0/12 -j RETURN

# Allow Tor traffic
iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT
iptables -A OUTPUT -p tcp --dport $TOR_TRANSPORT_PORT -j ACCEPT

# Drop all other outbound traffic (optional, for extra security)
# iptables -A OUTPUT -j DROP
