import AssemblyKeys._

import scalariform.formatter.preferences._

assemblySettings

seq(npSettings: _*)

EclipseKeys.withSource := true

EclipseKeys.executionEnvironment := Some(EclipseExecutionEnvironment.JavaSE17)

scalariformSettings

ScalariformKeys.preferences := FormattingPreferences()
  .setPreference(AlignSingleLineCaseStatements, true)
  .setPreference(CompactControlReadability    , false)
  .setPreference(DoubleIndentClassDeclaration , true)
  .setPreference(IndentLocalDefs              , true)
  .setPreference(RewriteArrowSymbols          , true)

