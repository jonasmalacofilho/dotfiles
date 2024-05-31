function repro-crate -a crate_name -a crate_version -d "Attempt to reproduce a .crate"
    echo "This may potentially run arbitrary code from the crate!"
    confirm --prompt "Are you sure you want to continue?" -- echo
    or return

    set -l spec "$crate_name-$crate_version"
    echo "Crate: $spec"
    echo

    # create and cd into temporary directory

    # See: https://rust-lang.github.io/rfcs/3463-crates-io-policy-update.html
    # TLDR: maximum of 1 request per second + unique UA + contact info
    set -l stock_wget_ua "Wget/"(pacman -Q wget | awk '{print $2}' | awk -F"-" '{print $1}')
    set -l repro_wget_ua "repro-crate/wip (github.com/jonasmalacofilho/dotfiles) $stock_wget_ua"

    # The supported download URL for a crate is:
    #
    #     https://crates.io/api/v1/crates/$crate_name/$crate_version/download
    #
    # However, wget gets confused with the link redirection and outputs a generically named file.
    # While we could force our own name, we instead prefer to follow the redirection by hand.
    set -l download_url "https://static.crates.io/crates/hdrhistogram/$spec.crate"
    echo "Downloading: $download_url"
    # wget -U $repro_wget_ua -o wget.log -d $download_url
    file $spec.crate
    echo

    # extract vsf metadata
    # clone repository src
    # cd src
    # checkout tag/commit
    # cargo publish

    # diffoscope target/package/$spec.crate ../$spec.crate
end
