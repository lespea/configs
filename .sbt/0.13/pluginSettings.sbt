import AssemblyKeys._

import scalariform.formatter.preferences._

import com.typesafe.sbt.SbtStartScript

assemblySettings

EclipseKeys.withSource := true

EclipseKeys.executionEnvironment := Some(EclipseExecutionEnvironment.JavaSE17)

scalariformSettings

ScalariformKeys.preferences := FormattingPreferences()
  .setPreference(AlignSingleLineCaseStatements, true)
  .setPreference(CompactControlReadability    , false)
  .setPreference(DoubleIndentClassDeclaration , true)
  .setPreference(IndentLocalDefs              , true)
  .setPreference(RewriteArrowSymbols          , true)

site.settings

net.virtualvoid.sbt.graph.Plugin.graphSettings

//org.scalastyle.sbt.ScalastylePlugin.Settings

// Create a default Scala style task to run with tests
//lazy val testScalaStyle = taskKey[Unit]("testScalaStyle")

//testScalaStyle := {
  //org.scalastyle.sbt.PluginKeys.scalastyle.toTask(" q w").value
//}

//(test in Test) <<= (test in Test) dependsOn testScalaStyle

packSettings

seq(SbtStartScript.startScriptForClassesSettings: _*)

//seq(SbtStartScript.startScriptForJarSettings: _*)

packageArchetype.java_application

addCommandAlias("pluginUpdates", "; reload plugins; dependencyUpdates; reload return")

autoCompilerPlugins := true

//  Many checks broken right now + no way to whitelist? wtf?
//addCompilerPlugin("org.brianmckenna" %% "wartremover" % "0.10")
//scalacOptions in (Compile, compile) += "-P:wartremover:only-warn-traverser:org.brianmckenna.wartremover.warts.Unsafe"

resolvers += "linter" at "http://hairyfotr.github.io/linteRepo/releases"

addCompilerPlugin("com.foursquare.lint" %% "linter" % "0.1-SNAPSHOT")

//instrumentSettings  // for scalariform

