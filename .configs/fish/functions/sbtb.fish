function sbtb --wraps='sbt --mem 7168 -J-XX:MaxGCPauseMillis=1000 -J-XX:+UseStringDeduplication -J-XX:+AlwaysPreTouch' --description 'alias sbtb sbt --mem 7168 -J-XX:MaxGCPauseMillis=1000 -J-XX:+UseStringDeduplication -J-XX:+AlwaysPreTouch'
    sbt --mem 7168 -J-XX:MaxGCPauseMillis=1000 -J-XX:+UseStringDeduplication -J-XX:+AlwaysPreTouch $argv
end
