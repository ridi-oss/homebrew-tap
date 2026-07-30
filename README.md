# ridi-oss/homebrew-tap

Homebrew formulae for RIDI's open-source tools.

```sh
# Homebrew 6 asks you to trust a third-party formula before it will load one. Trust the
# formula rather than the whole tap, so a future formula added here is not trusted implicitly.
brew trust --formula ridi-oss/tap/pmon
brew install ridi-oss/tap/pmon
```

## Formulae

| Formula | What it is |
| --- | --- |
| `pmon` | The [proxy-monster](https://github.com/ridi-oss/proxy-monster) connector — reach a database through the proxy on a stable local port, with a saved password that never changes. |

Each formula installs a prebuilt binary from its project's GitHub release, so no
toolchain is needed to install one.
