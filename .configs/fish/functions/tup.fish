function tup
    mold --run env RUSTFLAGS="-C link-args=-s -C target-cpu=native" topgrade --disable gem --disable pip3 --disable vim --disable cargo --skip-notify
    pyenv update
end
