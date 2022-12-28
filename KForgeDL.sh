#!/bin/bash
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-12-28/kforgeaa
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-12-28/kforgeab
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-12-28/kforgeac
wget https://github.com/ArrayBolt3/kforge/releases/download/2022-12-28/SHA256SUMS
sha256sum -c SHA256SUMS
if [ $? -eq 0 ]; then
	cat kforgeaa kforgeab kforgeac > KForge.ova
	rm kforgeaa kforgeab kforgeac
else
	echo "SHA256SUM error! Please run 'sha256sum -c SHA256SUMS' and redownload the damaged file(s)."
fi
