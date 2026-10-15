class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.14"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.14/pmon_0.1.14_darwin_arm64.tar.gz"
      sha256 "d508b21d2793744d28c22f364928b3fb2cefdb87be0ce19e752ace59706d7b87"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.14/pmon_0.1.14_darwin_amd64.tar.gz"
      sha256 "399742b72b69ba28d9932246cb34233f4dc282e91e674445f4e0e107172d33bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.14/pmon_0.1.14_linux_arm64.tar.gz"
      sha256 "f92ddd7202dde5282c540f963a56954c2c5992f5d86e21e934aad24e1955526b"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.14/pmon_0.1.14_linux_amd64.tar.gz"
      sha256 "3b4464b96534b8e19e4de40ce9d94576019577f7932348c1f43e11314c815a45"
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
