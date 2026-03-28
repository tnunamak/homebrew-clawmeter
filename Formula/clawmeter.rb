class Clawmeter < Formula
  desc "Claude Code usage monitor with system tray"
  homepage "https://github.com/tnunamak/clawmeter"
  url "https://github.com/tnunamak/clawmeter/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "4664d2c31f1adc866fe6d02ae0131c89e96ba8cf46849539d3fbcdbcb2d91972"
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
