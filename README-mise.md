```markdown

# Some Useful `mise` Commands

| Command | Description |
|---------|-------------|
| `mise tool-alias ls node` | View LTS versions of Node.js. Node supports this feature, uv does not. |
| `mise latest uv` | Get the latest version of uv. |
| `mise ls-remote uv` | List all fully supported versions of uv. |
| `mise ls uv` | Check which version of uv is currently in use and where it is configured. |
| `mise list` | List all currently installed utilities. |

# Clearing cache

If you there are problems (e.g., if your internet disconnects while downloading uv, the archive becomes corrupted, and mise install gives an unpacking error) you can use `mise cache clear`. Under normal workflow, you don't need to use this command.


# If You Specifically Want to Fix `mise`

If you're set on using `mise` to provide the `sqlite3` utility for this project, we can bypass the broken `vfox` plugin and force `mise` to use the good old, battle-tested `asdf`-format plugin instead.

Here's what you need to do:

1. **Remove the broken plugin** that `mise` downloaded automatically:
   ```bash
   mise plugins uninstall sqlite
   ```

2. **Manually add an alternative plugin** (the standard asdf plugin from GitHub):
   ```bash
   mise plugins install sqlite https://github.com/cLupus/asdf-sqlite.git
   ```

3. **Try installing SQLite again:**
   ```bash
   mise use sqlite@latest
   ```

After this, `mise` will download SQLite's source code or binaries using a different script, and the command `sqlite3 vault/zion.sqlite "VACUUM;"` should finally work.

---

# The Universal Formula


## Quick Reminder for Error Cases
If you first tried a plain `mise use <tool>` and it threw a `vfox metadata...` error (like you saw with SQLite), **remove the broken plugin cache** before installing "the old way":
```bash
mise plugins uninstall <tool_name>
```
Then proceed with `mise plugins install ... <url>`.

This trick is your trusty fallback. Old `asdf` plugins are written in simple Bash scripts—they're rock-solid stable and work on practically any Linux/macOS system!
```

If you run into a broken modern plugin in `mise` again in the future and want to install **any other tool "the old way"** (using time-tested `asdf`-format plugins), here's the universal approach:


Instead of relying on `mise`'s internal registry (which is currently transitioning to new formats like `vfox` and sometimes breaks), you can directly feed it a Git repository URL for the plugin.

The formula is:
```bash
mise plugins install <tool_name> <git_repository_url>
```

## Step-by-Step for Any Tool:

**Step 1: Find the plugin URL**
Historically, `mise` is fully compatible with the `asdf` version manager ecosystem. There are `asdf` plugins for almost everything.
1. Open your favorite search engine (or GitHub search).
2. Search for: `asdf <tool_name> plugin github` (e.g., `asdf postgresql plugin github` or `asdf ffmpeg plugin github`).
3. Copy the repository URL you find.

**Step 2: Install the plugin via the direct URL**
For example, if you wanted to install Node.js, PostgreSQL, or FFmpeg bypassing the standard registry:
```bash
# For Node.js
mise plugins install nodejs https://github.com/asdf-vm/asdf-nodejs.git

# For PostgreSQL
mise plugins install postgres https://github.com/smashedtoatoms/asdf-postgres.git

# For FFmpeg
mise plugins install ffmpeg https://github.com/acj/asdf-ffmpeg.git
```

**Step 3: Use as usual**
Once the plugin is installed via the direct URL, `mise` knows how to work with it. From there, you just call the standard command:
```bash
mise use <tool_name>@latest
```
Or with a specific version:
```bash
mise use nodejs@20.0.0
```

