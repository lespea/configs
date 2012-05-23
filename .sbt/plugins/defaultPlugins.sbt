addSbtPlugin("com.typesafe.sbteclipse" % "sbteclipse-plugin" % "2.1.0-M2")

addSbtPlugin("me.lessis" % "np" % "0.2.0")

resolvers += Resolver.url("sbt-plugin-releases",
  url("http://scalasbt.artifactoryonline.com/scalasbt/sbt-plugin-releases/"))(
    Resolver.ivyStylePatterns)
