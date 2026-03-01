#!/bin/bash

kumaURL="http://kuma:9070/api/push/"
# Default notify Treshold
notifyThreshold="95"

notifyKuma () {
        freeDiskSpace=`df | grep -F "$diskToCheck" | awk '{print $5}' | tr -d %`

        if [ "$freeDiskSpace" -le "$notifyThreshold" ]; then
                curl -fs -o /dev/null --retry 5 -m 10 "$kumaURL/$kumaToken?status=up&msg=OK&ping=$freeDiskSpace"
        else
                curl -fs -o /dev/null --retry 5 -m 10 "$kumaURL/$kumaToken?status=down&msg=NoFreeSpaceLeft&ping=$freeDiskSpace"
        fi
}

# Here you can add you disks and tokens for kuma
# Each time treshold reached, down status will be send
# You can set indvidual Treshold for each disk, or use default one

diskToCheck="/mnt/disk1"
kumaToken="1y2x3v4b5"
notifyKuma

notifyThreshold="90"
diskToCheck="/dev/mapper/ubuntu--vg-ubuntu--lv"
kumaToken="yxcvbn"
notifyKuma

notifyThreshold="90"
diskToCheck="/dev/mapper/ubuntu--vg-something-lv"
kumaToken="123456"
notifyKuma

exit 0
