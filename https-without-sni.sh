#!/bin/bash

IP=$1
DOMAIN=$2

tshark -i eth0 -w output.pcap > /dev/null 2>&1 &
pid=$(ps -e | pgrep tshark)

sleep 1
echo ""
echo ""
echo "Running zgrab2 HTTPS for ${DOMAIN}..."
echo ${DOMAIN} | /go/zgrab2/zgrab2 http \
    --use-https -p 443 2>/dev/null |
    jq -r '.data.http.result.response.status_line'

echo "Running zgrab2 HTTPS for ${IP} forcing SNI to be ${DOMAIN}..."
echo ${IP} | /go/zgrab2/zgrab2 http \
    --server-name=${DOMAIN} --use-https -p 443 2>/dev/null |
    jq -r '.data.http.result.response.status_line'

# wait for tcpdump to get all the frames
sleep 0.5
kill -2 $pid

echo ""
echo "PCAP capture showing DNS queries and TLS client hello's:"
tshark -2 -r output.pcap \
    -R "tls.handshake.type==1 || dns.flags==0x0100" \
    2>/dev/null
