# Homebrew formula template for the disklessly CLI.
# The release workflow fills in VERSION and SHA256 from SHA256SUMS. Copy the result
# into a tap (for example s546126/homebrew-tap/Formula/disklessly-cli.rb).
class DisklesslyCli < Formula
  desc "Offload rarely used Mac apps to a repo and launch them on demand"
  homepage "https://github.com/s546126/disklessly"
  version "0.2.1"
  url "https://github.com/s546126/disklessly/releases/download/v#{version}/disklessly-#{version}-macos-universal.tar.gz"
  sha256 "4e6a5e7f340ac21cb09f5d866e929ceed8686d1e01867eb03bd8a1466f554a08"
  license "MIT"

  depends_on :macos

  def install
    # disklessly looks for disklessly-stub beside itself and for the page at ../share/disklessly/web.
    bin.install "bin/disklessly", "bin/disklessly-stub"
    bin.install_symlink "disklessly" => "dkl"
    (share/"disklessly").install "share/disklessly/web"
    doc.install "README.md", "CHANGELOG.md", "PRIVACY.md", "THIRD_PARTY_NOTICES.md"
  end

  def caveats
    <<~EOS
      Stubs exec a stable copy of the engine under
        ~/Library/Application Support/Disklessly/bin/disklessly
      After installing or upgrading, refresh that copy and your stubs:
        disklessly install-engine
        disklessly stub refresh --app <bundle id>   # once per packed app; see `disklessly list`

      Replacing apps in /Applications needs App Management permission for your
      terminal (System Settings > Privacy & Security > App Management).

      The menu-bar app is a separate cask: brew install --cask disklessly
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/disklessly version")
    output = shell_output("#{bin}/disklessly 2>&1", 64)
    assert_match "disklessly help", output
  end
end
