# Distrobox Configuration

Reproducible development environment setup for Bazzite using Distrobox.

## Quick Start
```bash
# Create/recreate the container
distrobox assemble create --replace --file ~/.dotfiles/distrobox/distrobox.ini

# Enter the container
distrobox enter fedora-develop
```

## Files

- `distrobox.ini` - Declarative container configuration
- `distrobox-setup.sh` - Init script for host integrations (VS Code, clipboard)

## How It Works

### Container Image

Uses `registry.fedoraproject.org/fedora-toolbox:43` as the base. This is a purpose-built image for toolbox/distrobox with user integration features pre-configured.

The fedora-toolbox image is built from a kickstart file (not a Containerfile):
https://pagure.io/fedora-kickstarts/blob/main/f/fedora-container-toolbox.ks

### Package Management

Packages are declared in `distrobox.ini` via `additional_packages`. When you need new packages:

1. **Experiment**: `dnf install` inside the container
2. **Formalize**: Add to `additional_packages` in the ini file
3. **Recreate**: `distrobox assemble create --replace`

For complex setups, consider building a custom Containerfile instead.

### VS Code Integration

VS Code is installed on the host via Flatpak. The setup script creates a wrapper so `code` works from inside the container:
```bash
distrobox-host-exec flatpak run com.visualstudio.code "$@"
```

This launches the host's VS Code with access to the container's working directory.

### Clipboard (wl-copy / wl-paste)

**The Problem**: Running `wl-copy` natively inside the container works for direct usage but fails with pipes:
```bash
wl-copy 'abc123'        # Works
echo "test" | wl-copy   # Fails - clipboard empty
```

This is a Wayland quirk — when piping, the process exits before the clipboard manager grabs the data.

**The Solution**: Route clipboard commands through the host using `distrobox-host-exec`:
```bash
ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/wl-copy
ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/wl-paste
```

This makes clipboard commands execute on the host where they have direct Wayland access.

**References**:
- https://github.com/89luca89/distrobox/issues/400
- https://distrobox.it/useful_tips/

## Configuration Reference

### distrobox.ini options

| Option | Description |
|--------|-------------|
| `image` | Base container image |
| `additional_packages` | Packages to install (can specify multiple times) |
| `pre_init_hooks` | Commands run before container init |
| `init_hooks` | Commands/scripts run during container setup |
| `pull` | Always pull latest image |
| `replace` | Replace existing container on `assemble create` |
| `nvidia` | Enable NVIDIA GPU passthrough |
| `init` | Use init system inside container |

### Useful Commands
```bash
# Recreate container
distrobox assemble create --replace

# Enter container
distrobox enter fedora-develop

# Run single command in container
distrobox enter fedora-develop -- <command>

# Export an app to host
distrobox-export --app <app-name>

# Run host command from inside container
distrobox-host-exec <command>
```

## Resources

- Distrobox documentation: https://distrobox.it/
- Distrobox assemble: https://distrobox.it/usage/distrobox-assemble/
- Distrobox host-exec: https://github.com/89luca89/distrobox/blob/main/docs/usage/distrobox-host-exec.md
- Fedora toolbox kickstart: https://pagure.io/fedora-kickstarts/blob/main/f/fedora-container-toolbox.ks
- Declaring distroboxes (Jorge Castro): https://www.ypsidanger.com/declaring-your-own-personal-distroboxes/
