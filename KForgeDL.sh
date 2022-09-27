#!/bin/bash
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-26/kforgeaa
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-26/kforgeab
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-26/SHA256SUMS
sha256sum -C SHA256SUMS
read -n 1 -s
cat kforgeaa kforgeab > KForge.ova
rm kforgeaa kforgeab
