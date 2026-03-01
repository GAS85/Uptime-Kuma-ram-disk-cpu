# Uptime-Kuma-ram-disk-cpu
Basic RAM, Disk and CPU alerts for uptime kuma

## Step 1

Create Uptime-Kuma monitors for CPU, RAM and Disk (multiple disks can be supported too) usage.

## Step 2

- Download scirpts and save them in a `/usr/local/bin/` folder. Add execution flag via command `chmod +x /usr/local/bin/kuma-*.sh`
- Add scripts to your crontab as "nobody":

```shell
sudo -u nobody crontab -e
```

```shell
@hourly /usr/local/bin/kuma-disk-space.sh #Report free disk space to Kuma and error if too less
0,15,30,45 * * * * /usr/local/bin/kuma-cpu-usage.sh #Report free disk space to Kuma and error if too less
*/5 * * * * /usr/local/bin/kuma-ram-usage.sh #Report free ram usage
```
