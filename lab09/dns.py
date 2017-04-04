#!/usr/bin/env python3

# Python DNS query client
#
# Example usage:
#   ./dns.py --type=A --name=www.pacific.edu --server=8.8.8.8
#   ./dns.py --type=AAAA --name=www.google.com --server=8.8.8.8

# Should provide equivalent results to:
#   dig www.pacific.edu A @8.8.8.8 +noedns
#   dig www.google.com AAAA @8.8.8.8 +noedns
#   (note that the +noedns option is used to disable the pseduo-OPT
#    header that dig adds. Our Python DNS client does not need
#    to produce that optional, more modern header)


from dns_tools import dns  # Custom module for boilerplate code

import argparse
import ctypes
import random
import socket
import struct
import string
import sys
import os


class dns_header_bitfields(ctypes.BigEndianStructure):
    _fields_ = [
        ("qr", ctypes.c_uint16, 1),
        ("opcode", ctypes.c_uint16, 4),
        ("aa", ctypes.c_uint16, 1),
        ("tc", ctypes.c_uint16, 1),
        ("rd", ctypes.c_uint16, 1),
        ("ra", ctypes.c_uint16, 1),
        ("reserved", ctypes.c_uint16, 3),
        ("rcode", ctypes.c_uint16, 4)
    ]


def main():
    # Setup configuration
    parser = argparse.ArgumentParser(description='DNS client for ECPE 170')
    parser.add_argument('--type', action='store', dest='qtype',
                        required=True, help='Query Type (A or AAAA)')
    parser.add_argument('--name', action='store', dest='qname',
                        required=True, help='Query Name')
    parser.add_argument('--server', action='store', dest='server_ip',
                        required=True, help='DNS Server IP')

    args = parser.parse_args()
    qtype = args.qtype
    qname = args.qname
    server_ip = args.server_ip
    port = 53
    server_address = (server_ip, port)

    if qtype not in ("A", "AAAA"):
        print("Error: Query Type must be 'A' (IPv4) or 'AAAA' (IPv6)")
        sys.exit()

    # Create UDP socket
    # ---------
    # STUDENT TO-DO
    # ---------
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Generate DNS request message
    # ---------
    # STUDENT TO-DO
    # ---------


    bitfields = dns_header_bitfields()
    messageID = random.getrandbits(8)+random.getrandbits(8)
    bitfields.qr = 1
    bitfields.opcode = 0
    bitfields.aa = 0
    bitfields.tc = 0
    bitfields.rd = 1
    bitfields.ra = 1
    bitfields.reserved = 0
    bitfields.rcode = 0

    qdcount = 1
    ancount = 0
    nscount = 0
    arcount = 0

    parts = qname.split(".")
    question = bytes('','ascii')
    for part in parts:
        length = len(part)
        length_bytes = struct.pack('!B', length)
        encode = bytes(part,'ascii')
        question += length_bytes + encode



    if qtype == "A":
        qnum = 1
    elif qtype == "AAAA":
        qnum = 28
    else:
        qnum = 0

    qclass = 1
    zero_byte = struct.pack('!s', bytes(0))

    qlast = struct.pack('!HH', qnum, qclass)

    request = bytearray()
    request += struct.pack('!H2sHHHH', messageID, bytes(bitfields), qdcount, ancount, nscount, arcount)

    request += question + zero_byte + qlast
    print("REQUEST: ", request)


    # Send request message to server
    # (Tip: Use sendto() function for UDP)
    # ---------
    # STUDENT TO-DO
    # ---------
    try:
        bytes_sent = s.sendto(request, server_address)
    except socket.error as msg:
        print("Error: send() failed")
        print("Description: " + str(msg))
        sys.exit()

    print("Sent %d bytes to server" % bytes_sent)
    # Receive message from server
    # (Tip: use recvfrom() function for UDP)
    # ---------
    # STUDENT TO-DO
    # ---------
    max_recv = 4096

    try:
       	(raw_bytes, src_addr) = s.recvfrom(max_recv)
    except socket.error as msg:
        print("Error: unable to recv()")
        print("Description: " + str(msg))
        sys.exit()


    # Close socket
    # ---------
    # STUDENT TO-DO
    # ---------
    try:
        s.close()
    except socket.error as msg:
        print("Error: unable to close() socket")
        print("Description: " + str(msg))
        sys.exit()

    print("Sockets closed, now exiting")

    # Decode DNS message and display to screen
    dns.decode_dns(raw_bytes)


if __name__ == "__main__":
    sys.exit(main())
