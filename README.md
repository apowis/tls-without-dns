# Introduction

This repo gives a small demo of how a user might usually do a HTTPS connection, where a DNS lookup is performed before the TLS handshake and then the HTTPS connection happens.

The second option is to simply send a TLS handshake to an IP, filling in the SNI value, without doing the DNS query.

The Dockerfile here essentially does this using zgrab2.

Usage:
```sh
docker run --privileged zzz 8.8.8.8 www.google.com
```

This does exactly what is described above, whilst also capturing the PCAP of the activity and outputting the relevant frames to screen.

Output:
```
Running zgrab2 HTTPS for www.google.com...
200 OK
Running zgrab2 HTTPS for 8.8.8.8 forcing SNI to be www.google.com...
302 Found

PCAP capture showing DNS queries and TLS client hello's:
    1 0.562481721   172.17.0.2 → 192.168.65.7 DNS 85 Standard query 0xbf9c AAAA www.google.com OPT
    2 0.562511931   172.17.0.2 → 192.168.65.7 DNS 85 Standard query 0x6168 A www.google.com OPT
    3 0.622985763   172.17.0.2 → 142.250.179.228 TLSv1.2 217 Client Hello
    4 0.791975120   172.17.0.2 → 8.8.8.8      TLSv1.2 217 Client Hello
    5 0.845906900   172.17.0.2 → 192.168.65.7 DNS 81 Standard query 0xe024 AAAA dns.google OPT
    6 0.846450255   172.17.0.2 → 192.168.65.7 DNS 81 Standard query 0x4e64 A dns.google OPT
```

Frames 1, 2 and 3 are the DNS query for google and then the coresponding TLS handhshake.

Frame 4 is a direct TLS handshake to google without the DNS query, forcing the SNI value.
