function sbtb --wraps='sbt --mem 8192' --description 'alias sbtb=sbt --mem 8192'
    sbt --mem 9216 $argv
end
