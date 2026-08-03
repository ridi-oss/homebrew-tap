class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.2/pmon_0.1.2_darwin_arm64.tar.gz"
      sha256 "bcc072562a56f464b377fd34a4f95a72d1da33edca631860d4b47d7113b70d8b"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.2/pmon_0.1.2_darwin_amd64.tar.gz"
      sha256 "461aafe069a6dbd6455a16cf2931e3843359accbb0fb6e1106805c391df0c921"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.2/pmon_0.1.2_linux_arm64.tar.gz"
      sha256 "90089ff7778cf7567ad4817391c5cfd845b73ecfea8f780f8dfc5eae6172d37e"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.2/pmon_0.1.2_linux_amd64.tar.gz"
      sha256 "57553f1ef443365ef1084d072bd766aa9a57d4f2e2a9876ed94ee24d47e6bac7"
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
