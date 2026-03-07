class Clawmeter < Formula
  desc "Claude Code usage monitor with system tray"
  homepage "https://github.com/tnunamak/clawmeter"
  url "https://github.com/tnunamak/clawmeter/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b9382f97015d026a3acd8b39259b8c32c9c22abce888abaa72d2354ebdadaa6f"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}"), "-tags", "tray", "./cmd/clawmeter"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clawmeter version")
  end

  service do
    run [opt_bin/"clawmeter", "tray"]
    keep_alive false
    log_path var/"log/clawmeter.log"
    error_log_path var/"log/clawmeter.log"
  end
end
