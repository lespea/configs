//import AssemblyKeys._

//import scalariform.formatter.preferences._

//import com.typesafe.sbt.SbtStartScript

//import NativePackagerKeys._



////////////////////////
//  Compiler Plugins  //
////////////////////////

//esolvers += "linter" at "http://hairyfotr.github.io/linteRepo/releases"

//addCompilerPlugin("com.foursquare.lint" %% "linter" % "0.1-SNAPSHOT")



////////////////////
//  IDE Settings  //
////////////////////




////////////////
//  Builders  //
////////////////

//assemblySettings

//packSettings

//seq(SbtStartScript.startScriptForClassesSettings: _*)

//packageArchetype.java_application



//////////////////
//  Formatters  //
//////////////////

//scalariformSettings
//
//ScalariformKeys.preferences := FormattingPreferences()
//  .setPreference(AlignParameters              , true)
//  .setPreference(AlignArguments               , true)
//  .setPreference(AlignSingleLineCaseStatements, true)
//  .setPreference(CompactControlReadability    , false)
//  .setPreference(DoubleIndentClassDeclaration , true)
//  .setPreference(IndentLocalDefs              , true)
//  .setPreference(RewriteArrowSymbols          , true)



////////////
//  Misc  //
////////////

net.virtualvoid.sbt.graph.Plugin.graphSettings







//////////////
///  OLD  ////
//////////////

//org.scalastyle.sbt.ScalastylePlugin.Settings

// Create a default Scala style task to run with tests
//lazy val testScalaStyle = taskKey[Unit]("testScalaStyle")

//testScalaStyle := {
  //org.scalastyle.sbt.PluginKeys.scalastyle.toTask(" q w").value
//}

//(test in Test) <<= (test in Test) dependsOn testScalaStyle

//seq(SbtStartScript.startScriptForJarSettings: _*)

//addCommandAlias("pluginUpdates", "; reload plugins; dependencyUpdates; reload return")

//autoCompilerPlugins := true

//  Many checks broken right now + no way to whitelist? wtf?
//addCompilerPlugin("org.brianmckenna" %% "wartremover" % "0.10")
//scalacOptions in (Compile, compile) += "-P:wartremover:only-warn-traverser:org.brianmckenna.wartremover.warts.Unsafe"

//instrumentSettings  // for scalariform

//EclipseKeys.withSource := true
//
//EclipseKeys.executionEnvironment := Some(EclipseExecutionEnvironment.JavaSE18)
