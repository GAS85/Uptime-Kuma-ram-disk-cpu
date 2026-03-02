# Uptime-Kuma-ram-disk-cpu

Basic RAM, Disk and CPU alerts for uptime kuma

## Usage

### Step 1

Create Uptime-Kuma monitors for CPU, RAM and Disk (multiple disks can be supported too) usage.

![Uptime Kuma Push URL](/img/Uptime%20Kuma%20-%20Push%20URL.png)

In this example:

- `https://kuma:9071` shall be set as `kumaURL` variable.
- `EObTdPA1H0Lsu3HDdU6Ba0tyJt83frtk` shall be set as `kumaToken` variable.

### Step 2

- Download scirpts and save them in a `/usr/local/bin/` folder. Add execution flag via command `chmod +x /usr/local/bin/kuma-*.sh`
- Add scripts to your crontab as "nobody":

```shell
sudo -u nobody crontab -e
```

```shell
@hourly /usr/local/bin/kuma-disk-space.sh #Report free disk space to Kuma and error if too less
*/15 * * * * /usr/local/bin/kuma-cpu-usage.sh #Report CPU usage to Kuma and error if too less
*/5 * * * * /usr/local/bin/kuma-ram-usage.sh #Report free ram usage
```

"Ping" will be used to display graph, e.g. for my CPU usage with treshold `400` it will looks like this:

![Uptime Kuma CPU Usage Example](/img/Uptime%20Kuma%20-%20Graph.png)
