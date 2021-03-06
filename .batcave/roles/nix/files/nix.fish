if test -n $HOME
    set NIX_LINK $HOME/.nix-profile

    # Set the default profile.
    if not test -L "$NIX_LINK"
        echo "creating $NIX_LINK" >&2
        set _NIX_DEF_LINK @localstatedir@/nix/profiles/default
        @coreutils@/ln -s $_NIX_DEF_LINK $NIX_LINK
    end

    #set PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
    set -x PATH $NIX_LINK/bin $PATH

    # Subscribe the user to the Nixpkgs channel by default.
    if not test -e $HOME/.nix-channels
        echo "https://nixos.org/channels/nixpkgs-unstable nixpkgs" > $HOME/.nix-channels
    end

    # Append ~/.nix-defexpr/channels/nixpkgs to $NIX_PATH so that
    # <nixpkgs> paths work when the user has fetched the Nixpkgs
    # channel.
    set -x NIX_PATH $NIX_PATH:$HOME/.nix-defexpr/channels/nixpkgs

    # Set $SSL_CERT_FILE so that Nixpkgs applications like curl work.
    if test -e /etc/ssl/certs/ca-certificates.crt # NixOS, Ubuntu, Debian, Gentoo, Arch
        set -xg SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
    else if test -e /etc/ssl/certs/ca-bundle.crt # Old NixOS
         set -xg SSL_CERT_FILE /etc/ssl/certs/ca-bundle.crt
    else if test -e /etc/pki/tls/certs/ca-bundle.crt # Fedora, CentOS
        set -xg SSL_CERT_FILE /etc/pki/tls/certs/ca-bundle.crt
    else if test -e $NIX_LINK/etc/ssl/certs/ca-bundle.crt # fall back to cacert in Nix profile
        set -xg SSL_CERT_FILE $NIX_LINK/etc/ssl/certs/ca-bundle.crt
    else if test -e $NIX_LINK/etc/ca-bundle.crt # old cacert in Nix profile
        set -xg SSL_CERT_FILE $NIX_LINK/etc/ca-bundle.crt
    end
end
