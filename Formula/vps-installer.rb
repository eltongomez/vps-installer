class VpsInstaller < Formula
  desc "Professional VPS Provisioning Tool with 13 Containerized Stacks"
  homepage "https://github.com/eltongomez/vps-installer"
  url "https://github.com/eltongomez/vps-installer/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "8c3b5f4e9a2d1c6f7e8b9a0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d"
  license "MIT"
  
  head "https://github.com/eltongomez/vps-installer.git", branch: "main"

  depends_on "jq"
  depends_on "curl"
  depends_on "openssl"
  
  # Docker is required at runtime (but not installable via Homebrew for all systems)

  def install
    bin.install "setup-vps.sh" => "vps-installer"
    
    # Install documentation
    doc.install "README.md", "LICENSE", "CHANGELOG.md"
    doc.install "README_PROJETO.md", "README_NONINTERACTIVE.md"
    doc.install "SECURITY.md", "TROUBLESHOOTING.md"
    
    # Install helper scripts
    libexec.install "noninteractive.env"
  end

  def caveats
    <<~EOS
      VPS Installer requires Docker and Docker Compose to be installed and running.
      
      To install Docker on macOS:
        brew install docker
      
      For more information, visit:
        https://github.com/eltongomez/vps-installer#installation
        
      Get started:
        vps-installer
    EOS
  end

  test do
    system "bash", "-n", bin/"vps-installer"
  end
end