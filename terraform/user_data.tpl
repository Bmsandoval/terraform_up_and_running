#!/bin/bash
aws s3 cp s3://${BUILDS_BUCKET}/latest elf
sudo chmod +x elf
. elf &
