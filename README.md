# ridi-oss/homebrew-tap

Homebrew formulae for RIDI's open-source tools.

```sh
# Homebrew 6 asks you to trust a third-party formula before it will load one. Trust the
# formula rather than the whole tap, so a future formula added here is not trusted implicitly.
brew trust --formula ridi-oss/tap/pmon
brew install ridi-oss/tap/pmon

# Or the menu-bar app, which bundles pmon and puts it on PATH (so it conflicts with the formula):
brew trust --cask ridi-oss/tap/proxy-monster-desktop
brew install --cask ridi-oss/tap/proxy-monster-desktop
```

## Formulae

| Formula | What it is |
| --- | --- |
| `pmon` | The [proxy-monster](https://github.com/ridi-oss/proxy-monster) connector — reach a database through the proxy on a stable local port, with a saved password that never changes. |

## Casks

| Cask | What it is |
| --- | --- |
| `proxy-monster-desktop` | Proxy Monster Desktop, the menu-bar app: sign in to proxy-monster, copy connection strings, and connect Claude Desktop, Claude Code or Codex. Signed and notarized; includes pmon. |

Each formula installs a prebuilt binary from its project's GitHub release, so no
toolchain is needed to install one.
