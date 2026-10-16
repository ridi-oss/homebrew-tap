class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.15"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.15/pmon_0.1.15_darwin_arm64.tar.gz"
      sha256 "608616eedc6cc1afbcf2d96067dc2f6f6daff7b01cc88460ed6f3f65eeca7324"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.15/pmon_0.1.15_darwin_amd64.tar.gz"
      sha256 "2590fd77e8e62e7a2df48f70f4ae8353fbc58b5eedd72d4ba0c3539e3aa5be94"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.15/pmon_0.1.15_linux_arm64.tar.gz"
      sha256 "449c1b1b1fdb6244d4cc05f52f853942d0a699d5588fb1b6afb354e15b32ea0a"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.15/pmon_0.1.15_linux_amd64.tar.gz"
      sha256 "04a4839330a829849243c510f80a0b8ab0c2062287b001393445f40d376e9ea0"
    end
  end

  def install
    bin.install "pmon"
  end

  def caveats
    <<~EOS
      Log in before connecting; that also starts the daemon and opens the brokers:
        pmon login --url <control-plane-url>
        pmon show <datasource>

      Upgrading? Run `pmon restart` so the running daemon picks up this version.

      The daemon's lifetime is yours to choose, so there is no brew service for it.
      `pmon stop` closes it.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pmon --version")

    # Every subcommand is present. Deliberately not `pmon status` or `login`: those talk to a daemon
    # and a control plane, so their result depends on machine state a formula test must not assume.
    assert_match "login", shell_output("#{bin}/pmon --help")

    # A missing argument is rejected by the CLI itself, which proves the binary parses rather than
    # merely executing — and it needs no daemon, no login, and no network. kong exits 80 on a usage error.
    assert_match "datasource", shell_output("#{bin}/pmon show 2>&1", 80)
  end
end
