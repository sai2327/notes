# 16. Networking Commands

## Table of Contents
- [16.1 Network Configuration (ip, ifconfig)](#161-network-configuration-ip-ifconfig)
- [16.2 Connectivity Testing (ping, traceroute)](#162-connectivity-testing-ping-traceroute)
- [16.3 Port & Connection Info (ss, netstat)](#163-port--connection-info-ss-netstat)
- [16.4 Remote Access (ssh, scp, rsync)](#164-remote-access-ssh-scp-rsync)
- [16.5 Downloading (curl, wget)](#165-downloading-curl-wget)
- [16.6 DNS Tools](#166-dns-tools)
- [16.7 Practice & Assessment](#167-practice--assessment)

---

## 16.1 Network Configuration (ip, ifconfig)

### ip command (modern)

```bash
# Show all interfaces and IPs
$ ip addr show
# or short form:
$ ip a
1: lo: <LOOPBACK,UP>
    inet 127.0.0.1/8 scope host lo
2: eth0: <BROADCAST,MULTICAST,UP>
    inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0
    inet6 fe80::1/64 scope link

# Show only IPv4
ip -4 addr

# Show routing table
$ ip route
default via 192.168.1.1 dev eth0
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100

# Show specific interface
ip addr show eth0

# Bring interface up/down
sudo ip link set eth0 up
sudo ip link set eth0 down

# Add IP address
sudo ip addr add 192.168.1.200/24 dev eth0

# Delete IP address
sudo ip addr del 192.168.1.200/24 dev eth0
```

### ifconfig (legacy but still common)

```bash
$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.100  netmask 255.255.255.0  broadcast 192.168.1.255
        ether 00:11:22:33:44:55  txqueuelen 1000

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
```

---

## 16.2 Connectivity Testing (ping, traceroute)

### ping

```bash
# Test connectivity
$ ping google.com
PING google.com (142.250.190.78) 56(84) bytes of data.
64 bytes from 142.250.190.78: icmp_seq=1 ttl=117 time=12.3 ms
64 bytes from 142.250.190.78: icmp_seq=2 ttl=117 time=11.8 ms
^C
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 11.8/12.05/12.3/0.25 ms

# Send specific number of pings
ping -c 4 192.168.1.1

# Set timeout
ping -W 2 192.168.1.1     # 2 second timeout
```

### traceroute

```bash
# Show path packets take to destination
$ traceroute google.com
 1  gateway (192.168.1.1)      1.234 ms
 2  isp-router (10.0.0.1)     5.678 ms
 3  core-router (172.16.0.1)  10.123 ms
 4  google.com (142.250.190.78) 12.345 ms

# Useful for finding WHERE connectivity breaks
```

---

## 16.3 Port & Connection Info (ss, netstat)

### ss (modern, faster)

```bash
# Show listening ports
$ ss -tlnp
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port  Process
LISTEN  0       128     0.0.0.0:22          0.0.0.0:*          sshd
LISTEN  0       511     0.0.0.0:80          0.0.0.0:*          nginx
LISTEN  0       128     0.0.0.0:443         0.0.0.0:*          nginx

# Flags:
# -t = TCP
# -u = UDP
# -l = Listening only
# -n = Show numbers (don't resolve names)
# -p = Show process name

# Show all connections (including established)
ss -tuanp

# Show TCP connections to specific port
ss -tn dport = :80
```

### netstat (legacy)

```bash
# Same as ss but older
$ netstat -tlnp
Proto Recv-Q Send-Q Local Address     Foreign Address   State    PID/Program
tcp        0      0 0.0.0.0:22        0.0.0.0:*         LISTEN   1234/sshd
tcp        0      0 0.0.0.0:80        0.0.0.0:*         LISTEN   5678/nginx
```

---

## 16.4 Remote Access (ssh, scp, rsync)

### ssh — Secure Shell

```bash
# Connect to remote server
ssh user@192.168.1.100
ssh john@server.example.com

# Connect on custom port
ssh -p 2222 user@host

# Execute command remotely (without login shell)
ssh user@host "ls -la /var/log"

# SSH with key authentication
ssh -i ~/.ssh/id_ed25519 user@host

# Generate SSH key pair
ssh-keygen -t ed25519 -C "john@example.com"
# Creates: ~/.ssh/id_ed25519 (private) and ~/.ssh/id_ed25519.pub (public)

# Copy public key to server (enables passwordless login)
ssh-copy-id user@host
```

### scp — Secure Copy

```bash
# Copy local file to remote
scp file.txt user@host:/home/user/

# Copy remote file to local
scp user@host:/var/log/syslog ./local_copy.log

# Copy directory recursively
scp -r project/ user@host:/home/user/backup/

# Custom port
scp -P 2222 file.txt user@host:/tmp/
```

### rsync — Efficient Sync

```bash
# Sync directory (only transfers changes!)
rsync -avz project/ user@host:/backup/project/

# Flags:
# -a = archive mode (preserves permissions, timestamps)
# -v = verbose
# -z = compress during transfer
# --delete = remove files on dest that don't exist on source
# --dry-run = show what WOULD happen without doing it

# Dry run first (safe!)
rsync -avz --dry-run --delete source/ dest/

# Sync with progress
rsync -avz --progress large_file.iso user@host:/data/
```

---

## 16.5 Downloading (curl, wget)

### curl

```bash
# Download and display
curl https://example.com

# Save to file
curl -o page.html https://example.com
curl -O https://example.com/file.zip    # Keep original filename

# Follow redirects
curl -L https://short.url/abc

# Show headers only
curl -I https://example.com

# POST request
curl -X POST -d "user=john&pass=secret" https://api.example.com/login

# POST with JSON
curl -X POST -H "Content-Type: application/json" \
  -d '{"name":"john"}' https://api.example.com/users

# Download with authentication
curl -u username:password https://api.example.com/data
```

### wget

```bash
# Download file
wget https://example.com/file.zip

# Download with custom filename
wget -O myfile.zip https://example.com/file.zip

# Resume interrupted download
wget -c https://example.com/large_file.iso

# Download entire website (mirror)
wget --mirror --convert-links https://example.com

# Quiet mode (no progress output)
wget -q https://example.com/file.txt
```

---

## 16.6 DNS Tools

```bash
# Lookup IP address of domain
$ nslookup google.com
Server:  8.8.8.8
Address: 8.8.8.8#53
Name:    google.com
Address: 142.250.190.78

# dig (more detailed DNS query)
$ dig google.com
;; ANSWER SECTION:
google.com.     300  IN  A  142.250.190.78

# Query specific record type
dig google.com MX          # Mail servers
dig google.com NS          # Name servers
dig google.com TXT         # TXT records

# Check hostname
$ hostname
my-server

# View/edit DNS config
cat /etc/resolv.conf
# nameserver 8.8.8.8
# nameserver 8.8.4.4
```

---

## 16.7 Practice & Assessment

### MCQs

**Q1.** `ss -tlnp` shows:
- A) All running processes
- B) Listening TCP ports with process names
- C) Network speed
- D) Firewall rules

**Answer:** B

---

**Q2.** To copy a directory to a remote server:
- A) `scp file.txt user@host:/path`
- B) `scp -r directory/ user@host:/path`
- C) `cp -r directory/ user@host:/path`
- D) `ssh copy directory/ user@host`

**Answer:** B

---

### Hands-On

**Task:** Write commands to:
1. Check your IP address
2. Test connectivity to 8.8.8.8 (4 pings)
3. Find what service is on port 80
4. Download a file from a URL

```bash
ip addr show            # or: hostname -I
ping -c 4 8.8.8.8
ss -tlnp | grep :80
wget https://example.com/file.txt
```

---

> **Next Topic:** [17 - Package Management](17-package-management.md)
