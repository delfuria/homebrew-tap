cask "battery-toolkit-next" do
  version "2.0.3"
  sha256 "6c59cea0c3714a987b32b8e788d5e7a3edb8c068b4148cf25bfdb22cb712620b"

  url "https://github.com/delfuria/Battery-Toolkit-Next/releases/download/v#{version}/Battery-Toolkit-Next-#{version}.zip"
  name "Battery Toolkit Next"
  desc "Control the platform power state of Apple Silicon Macs"
  homepage "https://github.com/delfuria/Battery-Toolkit-Next"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  app "Battery Toolkit Next.app"

  uninstall_preflight_steps do
    run "/usr/bin/security",
        args:         ["authorizationdb", "remove", "com.delfuria.batterytoolkitd.manage"],
        sudo:         true,
        must_succeed: false
  end

  uninstall launchctl:  "com.delfuria.batterytoolkitd",
            quit:       "com.delfuria.BatteryToolkit",
            login_item: "com.delfuria.BatteryToolkitAutostart",
            delete:     [
              "/Library/LaunchDaemons/com.delfuria.batterytoolkitd.plist",
              "/Library/PrivilegedHelperTools/com.delfuria.batterytoolkitd",
            ]

  zap trash: [
    "/var/root/Library/Preferences/com.delfuria.batterytoolkitd.plist",
    "~/Library/Preferences/com.delfuria.BatteryToolkit.plist",
  ]

  caveats <<~EOS
    Do not run Battery Toolkit Next together with the original Battery Toolkit:
    both control the same charging hardware. Uninstall it first, e.g.:
      brew uninstall --cask battery-toolkit
  EOS
end
