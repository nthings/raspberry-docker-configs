# Raspi-Tail-Hole
A simple tailscale pi-hole automated setup for debian based OS, tested on Raspbery Pi 3 b+ and Raspberry Pi OS Lite (64-bit) (Debian Bookworm)
## Tailscale initial configuration
To configure your raspberry pi to use tailscale run the following command 

```bash
curl -sL https://raw.githubusercontent.com/rsgarciae/raspi-tailhole/main/bin/start.sh | bash
```


this will

 1- enable vnc on your raspoberry pi

 2- set your raspberry static ip using the current ip of your device

 3.- enable ip forwarding

 4.- install docker


## Log into tailscale 

[log into tailscale or create your account] (https://tailscale.com/login)

once you create your account, you can add your devices such as your phone.

## Create tailscale auth key

Generate your auth key on

![https://login.tailscale.com/admin/settings/keys](https://github.com/rsgarciae/raspi-tailhole/blob/main/images/generate_key.png?raw=true)

## Enable device approval
![https://login.tailscale.com/admin/settings/device-management](https://github.com/rsgarciae/raspi-tailhole/blob/main/images/device_approval.png?raw=true)

## Configure ACL's
Add [sample_acl.json](sample_acl.json) to tailscale acls, to allow auto approve subnet routes and exit nodes

## Create the docker container 
to initialize the docker container run the following command 

make sure to replace the following variables variables 

TS_AUTHKEY=<REPLACEME_WITH_THE_KEY>  replace this varaible with the auth key generated in the previous step 

TS_EXTRA_ARGS=--advertise-routes=<REPLACEME_WITH_YOUR_SUBNET_RANGE> replace with your subnet/subnets range, eg 192.0.2.0/24,198.51.100.0/24


```bash
docker run -d \
    --name=tailscale \
    -v "/var/lib:/var/lib" \
    -v "/dev/net/tun:/dev/net/tun" \
    --network=host \
    --cap-add=NET_ADMIN \
    --cap-add=NET_RAW \
    --env TS_AUTHKEY="<REPLACEME_WITH_THE_KEY>" \
    --env TS_EXTRA_ARGS="--advertise-exit-node"  \
    --env TS_ROUTES="<REPLACEME_WITH_YOUR_SUBNET_RANGE>" \
    --restart unless-stopped \
    tailscale/tailscale:v1.74.1
```

## Pi-Hole initial configuration

[Customize wiht the Env vars you need](https://github.com/pi-hole/docker-pi-hole/blob/master/README.md#environment-variables)

### Replacing varibales 

DHCP variables can be found under your router admin page, this configuration is usually under settings -> LAN -> DHCP
there you will se start and end address range,

FTLCONF_LOCAL_IPV4 varibale can be replaced with your raspberry pi static ip 


```bash
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 80:80 \
    -p "67:67/udp" \
    -v "${PIHOLE_BASE}/etc-pihole:/etc/pihole" \
    -v "${PIHOLE_BASE}/etc-dnsmasq.d:/etc/dnsmasq.d" \
    -e TZ="America/Monterrey" \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e PIHOLE_DNS_="1.1.1.1;1.0.0.1" \
    -e DNSSEC=true \
    -e DHCP_ACTIVE=true \
    -e DHCP_START="<REPLACE_ME_WITH_START_IP>" \
    -e DHCP_END="<REPLACE_ME_WITH_END_IP>" \
    -e DHCP_ROUTER="<REPLACE_ME_WITH_ROUTER_IP>" \
    -e FTLCONF_LOCAL_IPV4="<REPLACE_WITH_STATIC_IP>" \
    -e WEBPASSWORD=admin \
    -e QUERY_LOGGING=true \
    -e WEBTHEME="default-darker" \
    -e WEB_PORT=80 \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --network=host \
    --hostname=pi.hole \
    --cap-add=NET_ADMIN \
    pihole/pihole:2024.07.0
```

## DHCP configuration
To use your raspberry pi as DHCP you will need to configure your router to use your raspberry as dhcp server.
Todo so go to your router admin page, this configuration is ussually under settings -> LAN -> DHCP.
use your raspberry pi static address as only DNS server 

## Thanks for your support !

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/rsgarciae)
