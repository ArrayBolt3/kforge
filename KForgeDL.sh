#!/bin/bash
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-10-13/kforgeaa
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-10-13/kforgeab
cat kforgeaa kforgeab > KForge.ova
rm kforgeaa kforgeab
