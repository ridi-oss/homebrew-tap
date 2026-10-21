class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.16"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.16/pmon_0.1.16_darwin_arm64.tar.gz"
      sha256 "e28849346bca0832bd765577d66fa1c35ec82902689fd0468d021fb8bdf3851e"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.16/pmon_0.1.16_darwin_amd64.tar.gz"
      sha256 "0faafd1a50dc7a49cd9d62f2499a52c514343a16aaafdf181545bb5e1a5129e6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.16/pmon_0.1.16_linux_arm64.tar.gz"
      sha256 "418f8efccbd96163bed7e8ca1b11d572cd0706ff699ebe5598f54a393da741c3"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.16/pmon_0.1.16_linux_amd64.tar.gz"
      sha256 "64acd269d95b9d8bd94ed16aa0f3bb620ab1eacdd998336e7aa52f396fb71647"
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
