cask "proxy-monster-desktop" do
  version "0.1.9"
  sha256 "1b59fa833d3578c4c491fa7fb3d02e94ad6d87ac0652e2d06cdaecc3ef5d637e"

  url "https://github.com/ridi-oss/proxy-monster/releases/download/pmon-v#{version}/ProxyMonsterDesktop_#{version}_darwin_universal.zip"
  name "Proxy Monster Desktop"
  desc "Menu-bar app that signs in to proxy-monster and connects AI apps to it"
  homepage "https://github.com/ridi-oss/proxy-monster"

  livecheck do
    url :url
    regex(/^pmon[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

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
