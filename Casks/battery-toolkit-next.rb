cask "battery-toolkit-next" do
  version "2.0.1"
  sha256 "9b5cf4511e63ce8ca104aac338abcf6f073bf9cc37e96a32337edeca89eefb4e"

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
