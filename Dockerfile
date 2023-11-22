FROM golang:bookworm

RUN git clone https://github.com/zmap/zgrab2.git && \
    cd zgrab2 && \
    make

RUN apt-get update && \
    apt-get install -y jq tcpdump tshark


ADD ./https-without-sni.sh /home/
RUN chmod 777 /home/https-without-sni.sh
ENTRYPOINT ["/home/https-without-sni.sh"]