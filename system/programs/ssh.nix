{ ... }:
{
  programs.ssh = {
    # Disable any potentially annoying behaviors
    startAgent = false;
    forwardX11 = false;
    setXAuthLocation = false;
    agentPKCS11Whitelist = null;
    # Set mozilla recommended configs
    hostKeyAlgorithms = [
      "ssh-ed25519-cert-v01@openssh.com"
      "ssh-rsa-cert-v01@openssh.com"
      "ssh-ed25519"
      "ssh-rsa"
      "ecdsa-sha2-nistp521-cert-v01@openssh.com"
      "ecdsa-sha2-nistp384-cert-v01@openssh.com"
      "ecdsa-sha2-nistp256-cert-v01@openssh.com"
      "ecdsa-sha2-nistp521"
      "ecdsa-sha2-nistp384"
      "ecdsa-sha2-nistp256"
    ];
    kexAlgorithms = [
      "curve25519-sha256@libssh.org"
      "ecdh-sha2-nistp521"
      "ecdh-sha2-nistp384"
      "ecdh-sha2-nistp256"
      "diffie-hellman-group-exchange-sha256"
    ];
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
      "hmac-sha2-512"
      "hmac-sha2-256"
      "umac-128@openssh.com"
    ];
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes128-gcm@openssh.com"
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];
    extraConfig = ''
      HashKnownHosts yes
      ForwardAgent no
    '';
  };
}
