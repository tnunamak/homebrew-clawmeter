class Clawmeter < Formula
  desc "Claude Code usage monitor with system tray"
  homepage "https://github.com/tnunamak/clawmeter"
  url "https://github.com/tnunamak/clawmeter/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "8f283dc2def2f8f46b048d963673033f9dc99588aa7252291d40569f0e1f1ecd"
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
