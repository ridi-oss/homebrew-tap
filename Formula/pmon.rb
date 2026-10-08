class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.9"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.9/pmon_0.1.9_darwin_arm64.tar.gz"
      sha256 "458381e441a550271ecaaf3bd3af15e4320a13181e79500909e627a60b801637"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.9/pmon_0.1.9_darwin_amd64.tar.gz"
      sha256 "6a62a35d12ccff0a5f75fd53addbfdeb2093427e98f2e7d0694a62441136e3d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.9/pmon_0.1.9_linux_arm64.tar.gz"
      sha256 "357b4c9475643ff55a7690d8a64f87674aa97bb5815daa02837e0e38bba27599"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.9/pmon_0.1.9_linux_amd64.tar.gz"
      sha256 "b7697d6bc15d57600a9aba4274d52e165a02aab59bf4073f5ae00c11e6923f59"
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
