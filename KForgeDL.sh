#!/bin/bash
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-23/kforgeaa
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-9-23/kforgeab
cat kforgeaa kforgeab > KForge.ova
rm kforgeaa kforgeab
