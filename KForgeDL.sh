#!/bin/bash
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-23/kforgeaa
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-23/kforgeab
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-23/SHA256SUMS
sha256sum -C SHA256SUMS
read -n 1 -s
cat kforgeaa kforgeab > KForge.ova
rm kforgeaa kforgeab