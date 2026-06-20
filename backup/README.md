```markdown
# Mise Installation and Configuration Guide

## Installation

Run the following command to install `mise`:

```bash
curl https://mise.run | sh
```

---

## Automatic Activation in Terminal

To make `mise` work automatically when your terminal opens, add the following to your `~/.bashrc` file:

```bash
# Add shims to PATH instead of activating via eval
echo 'export PATH="$HOME/.local/share/mise/shims:$PATH"' >> ~/.bashrc

# Reload bashrc
source ~/.bashrc
```

> **Note:** The commented line (`eval "$(~/.local/bin/mise activate bash)"`) is an alternative method, but the PATH/shim approach is recommended.

---

## Desktop Integration (.desktop Files)

When creating a `.desktop` file, use the following format for the `Exec` line:

```ini
Exec=/work/mise-app-launcher.sh /snap/bin/kate -b %U
```

Replace `/snap/bin/kate` with the **full path** to your actual application.

For Antigravity IDE, note the usage of --no-sandbox:

[Desktop Entry]
Version=1.0
Type=Application
Name=Antigravity IDE
Comment=Antigravity 2.0 Shared Agent Engine
# # Call your hook script, passing the IDE binary, the AppArmor bypass flag, and %U for files/folders
Exec=/work/mise-app-launcher.sh /work/google/antigravity/antigravity-ide/bin/antigravity-ide --no-sandbox %U
Icon=code
Terminal=false
Categories=Development;IDE;
StartupNotify=true
StartupWMClass=antigravity-ide



---

## Configuration File

Place your `config.toml` file in the following location:

```
~/.config/mise/config.toml
```

---

## Additional Resources

For more detailed instructions and advanced usage, check out the full guide:

👉 [Full article on Medium](https://alex-ber.medium.com/4d861cdd366c)
```

Also we're copying global Antigravity configuration files:

~/.gemini/antigravity-cli/settings.json 
~/.gemini/config/AGENTS.md 
~/.gemini/config/skills/
