# cdn-docker
MyCard CDN node with SSH in docker

## Docker Info

### Ports

* `22`: SSH Port
* `80`: HTTP Port
* `443`: HTTPS Port

### Volumes

* `/etc/nginx`
* `/var/log/nginx`
* `/root/.ssh/authorized_keys` if necessary
