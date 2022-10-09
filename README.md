# wsl2-vmmem-fix
Helpful changes to fix vmmem eating up available physical memory and flooding your disk. \
Systems with low amounts of physical RAM can benefit the most of these changes. \

## One reason why vmmem process uses so much memory..
> __ANSWER: IT IS FILE CACHING! :(__

The high VM memory usage (in windows process __vmmem__) is because \
linux caches files for better performance.

Most notable memory increase is because __Docker images are also files (!)__ and are included into this cache!

To confirm this, try running some Docker containers and compare the memory usage before/after.
```
# linux 
free -mh (see "buff/cached" memory)

# windows
vmmem (see process memory usage)
```
The __buff/cached__ memory is increased by the size of the docker image file being used!


## Linux

### Disable swappiness

> _"The swappiness in Linux is a rate in which the operating system 
tends to write data out of the RAM onto the disk drive (HDD or SSD)"_

Letting VM to compensate lack of memory (RAM) by allowing it to flush to disk \
will slow the host system down ALOT and burn trough your ssd/nvme disk also faster!

To avoid these problems disable swapiness in ``/etc/sysctl.conf``:
```
vm.swappiness=0
```
Apply changes with ``sudo sysctl -p`` command.

> NB! Increase your memory limit if it is not enough for VM!


### Forcing distro to release cached files memory

WSL distro kernel tries to re-claim small amounts of memory \
back to host by running periodically (PS. when CPU is idle!): \
``echo 1 > /proc/sys/vm/compact_memory``

This can be seen in ``dmesg -T`` logs:
```
villisco@blackbox:~$ dmesg -T
...
[Sun Oct  9 13:04:51 2022] WSL2: Performing memory compaction.
[Sun Oct  9 13:05:52 2022] WSL2: Performing memory compaction.
[Sun Oct  9 13:06:57 2022] WSL2: Performing memory compaction.
```

But this will not re-claim most of the files cached in memory space.

__To force kernel to clear caches use:__
```
echo 1 > /proc/sys/vm/drop_caches
```
> NB! This will free the memory but could slow down \
> the performance/speed when working with WSL distro.

## Windows

## WSL limits

WSL resource usages can be limited by ``.wslconfig`` file.

Place this file in Windows: \
``C:/Users/{username}/.wslconfig``

Read more about available ``.wslconfig`` settings: \
https://learn.microsoft.com/en-us/windows/wsl/wsl-config