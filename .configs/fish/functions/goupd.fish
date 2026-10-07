function goupd
    argparse f/force -- $argv
    or return

    if not set -q GOBIN
        echo 'GOBIN not set'
        return 1
    end

    set -l gop ''
    if set -q _flag_force
        set gop -a
    end

    fd . $GOBIN -tf -x bash -c 'go version -m -v {} | rg \'^\s*path\' | awk \'{print $2}\'' | rg -F . | parallel go install $gop '{}@latest'
end
