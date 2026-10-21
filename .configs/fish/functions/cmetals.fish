function cmetals
    set -l java_opts $JAVA_OPTS
    if test (uname) = Darwin
        set -a java_opts -Dmetals.macos-max-watch-roots=4096
    end
    JAVA_OPTS="$java_opts" command metals-mcp --client claude --workspace . --default-bsp-to-build-tool $argv
end
