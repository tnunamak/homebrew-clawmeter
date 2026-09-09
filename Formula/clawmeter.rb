class Clawmeter < Formula
  desc "Claude Code usage monitor with system tray"
  homepage "https://github.com/tnunamak/clawmeter"
  url "https://github.com/tnunamak/clawmeter/archive/refs/tags/v0.34.3.tar.gz"
  sha256 "cce77b970ac57f888205aafabebf81d2864b549adf8e8b1b9f7af898acf7f3e5"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}"), "-tags", "tray", "./cmd/clawmeter"

    if OS.mac?
      app = prefix/"Clawmeter.app"
      (app/"Contents/MacOS").mkpath
      (app/"Contents/MacOS/Clawmeter").write <<~EOS
        #!/bin/sh
        exec "#{opt_bin}/clawmeter" tray
      EOS
      chmod 0755, app/"Contents/MacOS/Clawmeter"

      (app/"Contents/Info.plist").write <<~XML
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>CFBundleExecutable</key>
          <string>Clawmeter</string>
          <key>CFBundleIdentifier</key>
          <string>com.clawmeter.app</string>
          <key>CFBundleName</key>
          <string>Clawmeter</string>
          <key>CFBundlePackageType</key>
          <string>APPL</string>
          <key>LSUIElement</key>
          <true/>
        </dict>
        </plist>
      XML
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawmeter version")
    assert_path_exists prefix/"Clawmeter.app/Contents/MacOS/Clawmeter" if OS.mac?
  end

  service do
    run [opt_bin/"clawmeter", "tray"]
    keep_alive false
    log_path var/"log/clawmeter.log"
    error_log_path var/"log/clawmeter.log"
  end

  def caveats
    if OS.mac?
      <<~EOS
        Start the tray now:
          brew services start clawmeter

        Open the app wrapper directly:
          open #{opt_prefix}/Clawmeter.app

        To show Clawmeter in Applications/Launchpad:
          mkdir -p ~/Applications
          ln -sfn #{opt_prefix}/Clawmeter.app ~/Applications/Clawmeter.app
      EOS
    else
      <<~EOS
        Start the tray now:
          brew services start clawmeter
      EOS
    end
  end
end
