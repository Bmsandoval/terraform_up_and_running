#!/bin/bash
OBJECT="$(aws s3 ls ${BUILDS_BUCKET} --recursive | sort | tail -n 1 | awk '{print $4}')"
aws s3 cp s3://${BUILDS_BUCKET}/$OBJECT elf
unzip -o elf
sudo chmod +x elf
./elf &
