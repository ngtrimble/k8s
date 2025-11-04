#!/usr/bin/env bash
set -euo pipefail

docker run -it --rm -v $(pwd):/data neptune-networks/cloud-localds-docker:latestc -v seed.iso user-data.yaml meta-data
chmod 0644 seed.iso

echo "Created seed ISO at seed.iso"

echo "Note: Upload seed.iso to your Proxmox ISO storage (e.g. local:iso/seed.iso) so the packer template can attach it before boot."
