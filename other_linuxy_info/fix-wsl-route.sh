#!/bin/bash

# Try to add default route via eth0 first (common when VPN is active)
ip route add default via 192.168.1.1 dev eth0 2>/dev/null

# If that fails, try eth1
if [ $? -ne 0 ]; then
    ip route add default via 192.168.1.1 dev eth1 2>/dev/null
fi

# If both fail, try to find any UP interface with an IP in 192.168.1.x range
if [ $? -ne 0 ]; then
    IFACE=$(ip -4 addr show | grep "inet 192.168.1" | awk '{print $NF}' | head -n1)
    if [ -n "$IFACE" ]; then
        ip route add default via 192.168.1.1 dev $IFACE 2>/dev/null
    fi
fi
