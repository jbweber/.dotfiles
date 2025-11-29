#!/bin/sh

# VS Code wrapper
cat > /usr/local/bin/code << 'EOF'
#!/bin/sh
distrobox-host-exec flatpak run com.visualstudio.code "$@"
EOF
chmod +x /usr/local/bin/code

# Clipboard wrappers
ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/wl-copy
ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/wl-paste
