function genBloop
    if not test -d "./project"
        echo "Not a scala dir; skipping"
        return 1
    end

    if not rg -Fq .bloop .gitignore
        echo ".bloop" >>.gitignore
    end
    if not rg -Fq metals .gitignore
        echo ".metals" >>.gitignore
    end

    sbt bloopInstall
end
