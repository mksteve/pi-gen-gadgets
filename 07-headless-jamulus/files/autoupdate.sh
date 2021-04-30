#!/bin/bash -e
sleep 60
sudo apt-get update > /home/pi/update.txt
sudo apt-get install jamulus >> /home/pi/update.txt
