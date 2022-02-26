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
        "log": {
                "loglevel": "warning"
        },
        "inbound": {
                "protocol": "VMess",
                "port": 8080,
                "settings": {
                        "clients": [{
                                "id": "73419d1a-cbd6-4b6f-db1d-38d78b3fb109",
                                "alterId": 64,
                                "security": "chacha20-poly1305"
                        }]
                },
                "streamSettings": {
                        "network": "tcp",
                        "httpSettings": {
                                "path": "/"
                        },
                        "tcpSettings": {
                                "header": {
                                        "type": "http",
                                        "response": {
                                                "version": "1.1",
                                                "status": "200",
                                                "reason": "OK",
                                                "headers": {
                                                        "Content-Type": ["application/octet-stream", "application/x-msdownload", "text/html", "application/x-shockwave-flash"],
                                                        "Transfer-Encoding": ["chunked"],
                                                        "Connection": ["keep-alive"],
                                                        "Pragma": "no-cache"
                                                }
                                        }
                                }
                        }
                }
        },
        "inboundDetour": [],
        "outbound": {
                "protocol": "freedom",
                "settings": {}
        }
}

# Run xray
/usr/local/bin/xray -config /usr/local/etc/xray/config.json
