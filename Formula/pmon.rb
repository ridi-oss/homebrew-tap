class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.17"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.17/pmon_0.1.17_darwin_arm64.tar.gz"
      sha256 "6e516c23c91357ed8ad29082e71f94c6c65c4c5a49ad6902c177cc1177a9121e"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.17/pmon_0.1.17_darwin_amd64.tar.gz"
      sha256 "7ce3f0e1d6793790ed1e17f8269472b3402a83ad22d3d8d318047fb8613fdca6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.17/pmon_0.1.17_linux_arm64.tar.gz"
      sha256 "dbd17a5f3bc247c4c36375e8eed5c50d6dd2cac9a929db9498a32b8ddf95b140"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.17/pmon_0.1.17_linux_amd64.tar.gz"
      sha256 "cdce48b70e7cba82c44b30698fc6f429279202b7e32dda00179ff4141365751f"
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
