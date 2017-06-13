lazy val root = (project in file("."))
  .settings(
    name := "stacks-and-queues",
    organization := "org.ymmtmdk",
    autoScalaLibrary := false,
    crossPaths := false,
    libraryDependencies ++= Seq(
      "junit" % "junit" % "4.12" % "test",
      "org.hamcrest" % "hamcrest-all" % "1.3" % "test",
      "com.novocode" % "junit-interface" % "0.11" % "test",
      "com.twitter.common" % "objectsize" % "0.0.12"
    )
  )
