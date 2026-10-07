function hpretty --argument url
    curl -s $url | prettier --parser html --bracket-same-line | bat -lhtml
end
