function genb
    if not test -d "./project"
        echo "Not a scala dir; skipping"
        return 1
    end

    echo "\
// DO NOT EDIT! This file is auto-generated.

// This file enables sbt-bloop to create bloop config files.

addSbtPlugin(\"ch.epfl.scala\" % \"sbt-bloop\" % \"1.5.11\") \
" > project/metals.sbt

    if not rg -Fq .bloop .gitignore
        echo ".bloop" >> .gitignore
    end
    if not rg -Fq metals .gitignore
        echo ".metals" >> .gitignore
    end

    sbt bloopInstall
end
