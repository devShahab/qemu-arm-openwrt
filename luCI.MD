## LuCI web interface
To access the LuCI web interface on your OpenWrt instance running in QEMU, you can follow these steps:
- Ensure LuCI is Installed and Running:
- First, make sure that LuCI is installed on your OpenWrt instance. You can install it using:

```
opkg update
opkg install luci
```

## Start the LuCI web server:
```
/etc/init.d/uhttpd start
```

#### Port Forwarding in QEMU:
- Ensure that you have forwarded the necessary ports (80 for HTTP and 443 for HTTPS) in your QEMU command line. For example:
    `qemu-system-arm -netdev user,id=mynet0,hostfwd=tcp::80-:80,hostfwd=tcp::443-:443 -device e1000,netdev=mynet0 ...`

- Firewall Configuration:
    - Make sure your firewall rules allow traffic on ports 80 and 443. You can add rules to allow this traffic:
```
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-LuCI-HTTP'
uci set firewall.@rule[-1].src='wan'
uci set firewall.@rule[-1].dest_port='80'
uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall
/etc/init.d/firewall restart
```

- Accessing LuCI:
    - Open your web browser and navigate to the IP address of your TAP interface. For example, if your TAP interface IP is `192.168.10.1`, you can access LuCI by going to: `http://192.168.10.1`



- Secure Access:
    - For secure access, ensure that luci-ssl is installed and configured:
```
opkg install luci-ssl
/etc/init.d/uhttpd restart
```

#### Access LuCI via HTTPS: `https://192.168.10.1`
