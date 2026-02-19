#!/bin/bash
## SECTION: This is all the original, replacing it with a a newer version
# Add default route for internet traffic
# sudo ip route add default via 192.168.1.1 dev $(ip -4 addr show | grep "inet 192.168.1" | awk '{print $NF}' | head -n1) 2>/dev/null

# Add route for corporate VPN networks (adjust these subnets based on your company's networks)
# Common corporate subnets - you may need to add/remove based on what your company uses
# sudo ip route add 192.168.187.0/24 via $(ip -4 addr show | grep "inet 10.10" | awk '{print $2}' | cut -d'/' -f1) 2>/dev/null
# sudo ip route add 10.0.0.0/8 via $(ip -4 addr show | grep "inet 10.10" | awk '{print $2}' | cut -d'/' -f1) 2>/dev/null
# sudo ip route add 172.16.0.0/12 via $(ip -4 addr show | grep "inet 10.10" | awk '{print $2}' | cut -d'/' -f1) 2>/dev/null

# echo "Routes configured"


## SECTION: this is really old. keep it disabled
# sudo ip route add default via 192.168.1.1 dev $(ip -4 addr show | grep "inet 192.168.1" | awk '{print $NF}' | head -n1) 


# Clear any existing default routes to avoid conflicts
sudo ip route del default 2>/dev/null

# Find the active local network interface (192.168.1.x)
LOCAL_IFACE=$(ip -4 addr show | grep "inet 192.168.1" | awk '{print $NF}' | head -n1)

if [ -z "$LOCAL_IFACE" ]; then
    echo "Error: No local network interface found"
    exit 1
fi

# Add default route for internet via local gateway
sudo ip route add default via 192.168.1.1 dev $LOCAL_IFACE

# Check if we have a VPN interface with 10.10.x.x IP
VPN_IFACE=$(ip -4 addr show | grep "inet 10.10" | awk '{print $NF}' | head -n1)

if [ -n "$VPN_IFACE" ]; then
    # VPN interface exists in WSL - use it directly
    VPN_IP=$(ip -4 addr show $VPN_IFACE | grep "inet 10.10" | awk '{print $2}' | cut -d'/' -f1)
    echo "VPN interface found: $VPN_IFACE with IP $VPN_IP"
    
    # Add routes for corporate networks through VPN interface
    sudo ip route add 192.168.187.0/24 dev $VPN_IFACE 2>/dev/null
    sudo ip route add 10.0.0.0/8 dev $VPN_IFACE 2>/dev/null
    sudo ip route add 172.16.0.0/12 dev $VPN_IFACE 2>/dev/null
else
    # VPN interface not in WSL - route corporate traffic through Windows host
    echo "VPN interface not found in WSL, routing corporate traffic through Windows host"
    
    # Get the Windows host IP (usually the .1 address in the WSL subnet)
    # In mirrored mode, we can try routing through the local gateway
    sudo ip route add 192.168.187.0/24 via 192.168.1.1 dev $LOCAL_IFACE 2>/dev/null
    sudo ip route add 10.0.0.0/8 via 192.168.1.1 dev $LOCAL_IFACE 2>/dev/null
    sudo ip route add 172.16.0.0/12 via 192.168.1.1 dev $LOCAL_IFACE 2>/dev/null
fi

echo "Routes configured for interface: $LOCAL_IFACE"
ip route show
