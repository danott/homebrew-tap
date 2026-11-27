class ThingsCli < Formula
  desc "CLI and MCP server for Things 3"
  homepage "https://github.com/danott/things-cli"
  url "https://github.com/danott/things-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "577414196eef0c5f4b4ad8bb05fe9449b353b20459af29a8339061ecad765a7e"
  license "MIT"
  head "https://github.com/danott/things-cli.git", branch: "main"

  depends_on "go" => :build
  depends_on :macos

  def install
    # mattn/go-sqlite3 needs cgo.
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}", output: bin/"things")
    generate_completions_from_executable(bin/"things", "completion", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      To give Claude Code the things skill and MCP server:
        things setup claude
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/things --version")
  end
end
