# mergerfs + SnapRAID setup

`/etc/fstab`:

```txt
# Data drives
UUID=2eeb4386-e26e-4340-9747-74fb3d18dd57   /mnt/disk1  xfs           defaults 0 0
UUID=e030fa2f-a9b4-4788-8d10-05cf5031f9c0   /mnt/disk2  xfs           defaults 0 0
UUID=f9a79cef-3959-4aa8-a9c9-af54660cb755   /mnt/disk3  xfs           defaults 0 0
UUID=c7283793-37c6-4b01-95e1-cca26af0da8f   /mnt/cache  btrfs         defaults 0 0
UUID=8d8cb485-eb23-475b-a9c1-03b8309cdbaa   /mnt/parity xfs           defaults 0 0
/mnt/disk1:/mnt/disk2:/mnt/disk3:/mnt/cache /mnt/user   fuse.mergerfs defaults,allow_other,use_ino,category.create=lfs,moveonenospc=true,minfreespace=512G,cache.files=partial,dropcacheonclose=true 0 0
/mnt/disk1:/mnt/disk2:/mnt/disk3            /mnt/hdds   fuse.mergerfs defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true,minfreespace=25M,cache.files=partial,dropcacheonclose=true  0 0```

## mergerfs

Command equivalent to fstab mergerfs mounts:

```txt
mergerfs -o defaults,allow_other,use_ino,category.create=lfs,moveonenospc=true,minfreespace=512G,cache.files=partial,dropcacheonclose=true /mnt/disk1:/mnt/disk2:/mnt/disk3:/mnt/cache /mnt/user
mergerfs -o defaults,allow_other,use_ino,category.create=mfs,moveonenospc=true,minfreespace=25M,cache.files=partial,dropcacheonclose=true /mnt/disk1:/mnt/disk2:/mnt/disk3 /mnt/hdds
```

## Caching and mover

### Topology

- `/mnt/user` - Combined mergerfs pool
- `/mnt/hdds` - HDD-only mergerfs pool
- `/mnt/cache` - cache mount point
- `/mnt/disk*` - Each HDD, starting from 1. `/mnt/disk1`, `/mnt/disk2`, etc.

### Mover script

Stolen from [here](https://raw.githubusercontent.com/trapexit/mergerfs/latest-release/tools/mergerfs.time-based-mover)

It moves anything that hasn't been access in more than 3 days.

Requires `rsync` - install with `apt update && apt install rsync`

```sh
#!/usr/bin/env sh

if [ $# != 3 ]; then
  echo "usage: $0 <cache-fs> <backing-pool> <days-old>"
  exit 1
fi

CACHE="${1}"
BACKING="${2}"
N=${3}

find "${CACHE}" -type f -atime +${N} -printf '%P\n' | \
  rsync --files-from=- -axqHAXWES --preallocate --remove-source-files "${CACHE}/" "${BACKING}/"
```

Located at `/root/mergerfs.time-based-mover.sh`, runs daily at 4 AM:

```cron
0 4 * * * /root/mergerfs.time-based-mover.sh /mnt/cache /mnt/hdds 3
```

## SnapRAID

### `/etc/snapraid.conf`

The list of files is stored on multiple disks in `snapraid.content`, and the parity is just one file (`snapraid.parity`)

```txt
parity /mnt/parity/snapraid.parity
content /var/snapraid/snapraid.content
content /mnt/disk1/snapraid.content
content /mnt/disk2/snapraid.content
content /mnt/disk3/snapraid.content
data d1 /mnt/disk1/
data d2 /mnt/disk2/
data d3 /mnt/disk3/
```

### Syncing

Run daily at 2 AM (`/etc/cron.d/snapraid-sync`):

```cron
* 02 * * * /root/snapraid-sync.sh
```

`/root/snapraid-sync.sh`:

```sh
#!/usr/bin/env sh
CONTAINERS=$(docker ps -q)
docker stop $CONTAINERS
snapraid sync
docker start $CONTAINERS
```
