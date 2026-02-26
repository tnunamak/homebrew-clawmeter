class Clawmeter < Formula
  desc "Claude Code usage monitor with system tray"
  homepage "https://github.com/tnunamak/clawmeter"
  url "https://github.com/tnunamak/clawmeter/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "b9d6e56206110a51ce322b716f5db6122810fb71a75207f7f45397458fbfd05e"
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
