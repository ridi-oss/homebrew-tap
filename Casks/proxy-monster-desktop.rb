cask "proxy-monster-desktop" do
  version "0.1.15"
  sha256 "00adaa4ed3c3f165a21ea50b0740ed4accbb936467afccee409915ba72b7d66b"

  url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v#{version}/ProxyMonsterDesktop_#{version}_darwin_universal.zip"
  name "Proxy Monster Desktop"
  desc "Menu-bar app that signs in to proxy-monster and connects AI apps to it"
  homepage "https://github.com/ridi-oss/proxy-monster"

  livecheck do
    url :url
    regex(/^pmon[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  auto_updates true
  # Bundles pmon on PATH, so it can't install beside the pmon formula (casks can't declare that conflict).
  depends_on macos: :monterey

  app "Proxy Monster Desktop.app"
  binary "#{appdir}/Proxy Monster Desktop.app/Contents/MacOS/pmon"

  uninstall quit: "com.ridi.oss.proxymonster.pmontray"

  zap trash: "~/Library/Preferences/com.ridi.oss.proxymonster.pmontray.plist"

  caveats <<~EOS
    Open Proxy Monster Desktop, then use the Connect page of your proxy-monster console,
    or Settings › Servers, to add a server and sign in.
  EOS
end
