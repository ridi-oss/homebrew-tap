class Pmon < Formula
  desc "Reach a database through proxy-monster on a stable local port"
  homepage "https://github.com/ridi-oss/proxy-monster"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.5/pmon_0.1.5_darwin_arm64.tar.gz"
      sha256 "377aba56a7217c2ec4285c68518bac521e9c911b73b05fcf16c71cdd63d84bd7"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.5/pmon_0.1.5_darwin_amd64.tar.gz"
      sha256 "3a973027f3d0ef5c8d10c1bcba5f4dbc203dc69842475e1b56b10b4b7ec264a7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.5/pmon_0.1.5_linux_arm64.tar.gz"
      sha256 "358e3f495be5e7352101585d8f7183dd1429deba3e56aff1d4abbc3281bb055e"
    end
    on_intel do
      url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v0.1.5/pmon_0.1.5_linux_amd64.tar.gz"
      sha256 "ed6be3c2d58d8e993d9bbb1508eb642a19e286cac9f2f0505231b92304b4911f"
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
