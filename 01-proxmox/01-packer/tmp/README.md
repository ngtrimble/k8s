Packer template for Proxmox VM template (autoinstall + cloud-init)

Overview
- This folder contains a Packer HCL template and supporting cloud-init files to build a Proxmox VM template that uses Ubuntu autoinstall + cloud-init.

What is included
- `template.pkr.hcl` - the Packer HCL packer template (uses the Telmate Proxmox plugin)
- `variables.pkr.hcl` - simple variable defaults you can override
- `user-data.yaml` - cloud-init + autoinstall configuration (edit: especially passwords and ssh keys)
- `meta-data` - cloud-init meta-data file
- `make-seed.sh` - helper to create a seed.iso from user-data/meta-data

Assumptions and requirements
- Packer v1.7+ with HCL2 support
- Install the Telmate Proxmox packer plugin (see plugin docs) or run `packer init` after adding plugin to your system
- `cloud-localds` (package: cloud-image-utils) or `genisoimage` available to create the seed ISO
- The target Proxmox has the Ubuntu server ISO already uploaded to the ISO storage path referenced by `iso_file` (default: `local:iso/ubuntu-22.04-live-server-amd64.iso`)
- You will upload `seed.iso` (created by `make-seed.sh`) to Proxmox ISO storage (e.g. `local:iso/seed.iso`) so the builder can attach it during boot

Steps
1) Edit `user-data.yaml`:
   - Replace the example hashed password and `ssh_authorized_keys` with your desired values
   - You can generate a password hash with `mkpasswd --method=SHA-512` (from `whois` package) or `python -c 'import crypt; print(crypt.crypt("password", crypt.mksalt(crypt.METHOD_SHA512)))'`

2) Create the seed ISO locally:

```bash
cd proxmox/packer
./make-seed.sh
```

3) Upload `seed.iso` to Proxmox ISO storage (e.g. `/var/lib/vz/template/iso/seed.iso` or via the web UI).

4) Configure your `variables.pkr.hcl` or pass variables via `-var` when running packer. Make sure `proxmox_password` is provided securely (env var or CLI).

5) Initialize and build with packer:

```bash
packer init .
packer build -var 'proxmox_password=YOURPASSWORD' template.pkr.hcl
```

Notes & next steps
- The Telmate Packer Proxmox plugin evolves; fields in the `source "proxmox"` block may vary by plugin version. If you have a different plugin or workflow (e.g., create qcow2 and import), adapt accordingly.
- After build completes, the VM should be converted to a Proxmox template named per `template_name`.
- You may want to add additional provisioning steps (apt cleanup, cloud-init clean, timezone, packages, or custom images).

Security
- Do not commit secrets (passwords/private keys) into the repo. Use CI secrets or pass sensitive values at build time.
