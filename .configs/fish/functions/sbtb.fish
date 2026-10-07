function sbtb --wraps='sbt --mem 7168' --description 'alias sbtb=sbt --mem 7168 with GC tuning'
    sbt --mem 7168 -J-XX:MaxGCPauseMillis=1000 -J-XX:+UseStringDeduplication -J-XX:+AlwaysPreTouch $argv
end
