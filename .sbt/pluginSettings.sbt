import AssemblyKeys._

assemblySettings

seq(npSettings: _*)

EclipseKeys.withSource := true

EclipseKeys.executionEnvironment := Some(EclipseExecutionEnvironment.JavaSE17)
