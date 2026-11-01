# Homebrew cask template for Disklessly.app (menu-bar app with the CLI inside).
# The release workflow fills in VERSION and SHA256. Copy the result into a tap
# (for example s546126/homebrew-tap/Casks/disklessly.rb).
cask "disklessly" do
  version "0.1.0"
  sha256 "fb1b9c12d57ccda7562d5a4dea832db6b4bf24e017fdbd2a53f44d2f88c3060a"

  url "https://github.com/s546126/disklessly/releases/download/v#{version}/Disklessly-#{version}.dmg"
  name "Disklessly"
  desc "Offload rarely used Mac apps to a repo and launch them on demand"
  homepage "https://github.com/s546126/disklessly"

  depends_on macos: ">= :ventura"

  app "Disklessly.app"
  # The CLI and the stub launcher live in Contents/MacOS; the symlinks resolve back into the app.
  binary "#{appdir}/Disklessly.app/Contents/MacOS/disklessly"
  binary "#{appdir}/Disklessly.app/Contents/MacOS/disklessly", target: "dkl"

  uninstall quit: "io.github.s546126.disklessly"

  # Packed apps are still stubs after the app is removed. Run `disklessly unpack` for
  # each one first if you want the real apps back; zap does not touch your repo.
  zap trash: [
    "~/Library/Application Support/Disklessly",
    "~/Library/Caches/Disklessly",
  ]

  caveats <<~EOS
    Before uninstalling, bring packed apps back with `disklessly unpack APP`
    (or from the dashboard). After upgrading, run:
      disklessly install-engine
      disklessly stub refresh --app <bundle id>
  EOS
end
