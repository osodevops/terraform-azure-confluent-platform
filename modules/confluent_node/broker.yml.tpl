#!/usr/bin/env bash
systemctl stop firewalld
systemctl disable firewalld
echo "Sleeping for 1 min to allow volume to become attached....."
sleep 1m
export VOLUME_STAT="`file -s /dev/sdc`"
if [[ $VOLUME_STAT == *"ext4"* ]]; then
echo "Volume already formatted (data exists)"
mkdir -p /var/lib/kafka/data
mount /dev/sdc /var/lib/kafka/data
else
echo "Blank volume, formatting...."
mkfs -F -t ext4 /dev/sdc
mkdir -p /var/lib/kafka/data
mount /dev/sdc /var/lib/kafka/data
fi
echo /dev/sdc /var/lib/kafka/data ext4 defaults,nofail 0 2 >> /etc/fstab
rm -R /var/lib/kafka/data/lost+found