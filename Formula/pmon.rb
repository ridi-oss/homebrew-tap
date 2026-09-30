class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.6"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.6/pmon_0.1.6_darwin_arm64.tar.gz"
      sha256 "dcefca5bc5106482980fa720a1965ab9e90c72aecf425136066655006000b656"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.6/pmon_0.1.6_darwin_amd64.tar.gz"
      sha256 "08d071138800d2bffb03a830e4c779d7a3882f2348b3ad71fdb5e3ae35b239fb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.6/pmon_0.1.6_linux_arm64.tar.gz"
      sha256 "c8b36c6db45c752c16ef9b1089e39f9af1bae67e674ac69100a94f0b00470058"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.6/pmon_0.1.6_linux_amd64.tar.gz"
      sha256 "13b236320d9c5b5a8dfd810430e5d2cc04fa010a852530d7769a6fa735badf3c"
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
    # merely executing — and it needs no daemon, no login, and no network.
    assert_match "datasource", shell_output("#{bin}/pmon show 2>&1", 1)
  end
end
