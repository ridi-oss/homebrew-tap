class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.4/pmon_0.1.4_darwin_arm64.tar.gz"
      sha256 "cd58b05c1a151f8ef6c54979d39b4d8af9bc9e5b166eaaf4f591fe7df7ad1b4c"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.4/pmon_0.1.4_darwin_amd64.tar.gz"
      sha256 "68100777106e0047a18b4570e67f03120a8390a8c002d32031f907a4fed8bb91"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.4/pmon_0.1.4_linux_arm64.tar.gz"
      sha256 "c76b62657f7ad72ee8625aa9f2e30e3c96a50b3f798a93d0eb5354e9b23bb687"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.4/pmon_0.1.4_linux_amd64.tar.gz"
      sha256 "6cd76d70e654a8d844852d80a8ad25c8251eb9a009f28e8d524b0c18cd93033e"
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
