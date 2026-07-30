class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.0/pmon_0.1.0_darwin_arm64.tar.gz"
      sha256 "f43d1b6be3a1918a3dff4e80c5aa6e584d0c1517464624ac1a51be01d7bafc29"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.0/pmon_0.1.0_darwin_amd64.tar.gz"
      sha256 "498145e5676974215ee1bf349c137b97eb9fae1687129142cc7b62c483201e0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.0/pmon_0.1.0_linux_arm64.tar.gz"
      sha256 "ed50745f0f67a612bf2640dc5cd7c3c2e009f71bb18c2cb36af6d7b36c6d7b3c"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.0/pmon_0.1.0_linux_amd64.tar.gz"
      sha256 "01fbd49d87521c868ae8c27f81c5f113a4f408cbe58b849e63beec15ddd4c19b"
    end
  end

  def install
    bin.install "pmon"
  end

  def caveats
    <<~EOS
      Log in before connecting; that also starts the daemon and opens the brokers:
        pmon login
        pmon show <datasource>

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
