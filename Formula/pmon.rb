class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.3/pmon_0.1.3_darwin_arm64.tar.gz"
      sha256 "cd60f69df5e2034b523453666443c871030316ce30ee07b58c62dbc4bc6627fe"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.3/pmon_0.1.3_darwin_amd64.tar.gz"
      sha256 "868d72acc82a1bdd1d0b85ce2bb3fba0766665a09e313baadb4a9cd5b13f7302"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.3/pmon_0.1.3_linux_arm64.tar.gz"
      sha256 "ed28179f4d3bc9c6b300581010afb75e71a6b3420f1ab8c01d1d28d322a8c388"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.3/pmon_0.1.3_linux_amd64.tar.gz"
      sha256 "0c1c016c9f70f032200516682c25e17b9ccfee737cb13fe8b2112aa4a8c2e9ca"
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
