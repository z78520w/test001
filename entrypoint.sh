#!/bin/sh

# Download and install xray
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray

# Remove temporary directory
rm -rf /tmp/xray

# xray new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
    "inbounds": [{
        "port": 443,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "18a28d40-fb08-942f-a920-01a34c1d608d",
                "level": 1,
                "alterId": 64
            }]
        },
        "streamSettings": {
            "network": "tcp",
            "tcpSettings": {
                "header": {
                    "type": "http",
                    "response": {
                        "version": "1.1",
                        "status": "200",
                        "reason": "OK",
                        "headers": {
                            "Content-Type": ["application/octet-stream",
                            "application/x-msdownload",
                            "text/html",
                            "application/x-shockwave-flash"],
                            "Transfer-Encoding": ["chunked"],
                            "Connection": {
                            "Pragma": "no-cache"
                        }
                    }
                }
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom",
        "settings": {
 
        }
    },
    {
        "protocol": "blackhole",
        "settings": {
 
        },
        "tag": "blocked"
    }],
    "routing": {
        "strategy": "rules",
        "settings": {
            "rules": [{
                "type": "field",
                "ip": ["geoip:private"],
                "outboundTag": "blocked"
            }]
        }
    }
}
EOF

# Run xray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json
