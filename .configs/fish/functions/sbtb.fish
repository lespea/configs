function sbtb --wraps='sbt --mem 9216' --description 'alias sbtb=sbt --mem 8192'
    sbt --mem 9216 -J-XX:MaxGCPauseMillis=1000 -J-XX:+UseStringDeduplication -J-XX:+AlwaysPreTouch $argv
end
