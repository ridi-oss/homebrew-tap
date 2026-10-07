class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.8"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.8/pmon_0.1.8_darwin_arm64.tar.gz"
      sha256 "33489ef7c69a28520994c7008cf5a1be03722e57e2c4c40141cf71f4685a8f03"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.8/pmon_0.1.8_darwin_amd64.tar.gz"
      sha256 "e6bb35f3d4f0804d6398459d1155730cc1a3f726bcf1b5a992031eb2016e33f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.8/pmon_0.1.8_linux_arm64.tar.gz"
      sha256 "6a4e2fbbd3a0f9dd026b7370f139f71e6dd593217af5886fa60f8c8f0a394b6c"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.8/pmon_0.1.8_linux_amd64.tar.gz"
      sha256 "8bebec137fe7d8c39960a0a893393a08e1a68413d727e1f07b1b35cbde442e76"
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
