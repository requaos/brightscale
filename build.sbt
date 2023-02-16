import scala.util.{Success, Try}
name := "brightscale"
organization := "com.requiredprofessionals"
organizationName := "requiredprofessionals"

scalaVersion := "2.13.10"
val sparkVersion = "3.3.1"
val deltaVersion = "2.2.0"
val hadoopVersion = "3.3.4"

lazy val extraMavenRepo = sys.env.get("EXTRA_MAVEN_REPO").toSeq.map { repo =>
  resolvers += "Delta" at repo
}

javaOptions += "-Dsbt.ivy.home=./dist/"

lazy val root = (project in file("."))
  .settings(
    run / fork := true,
    run / javaOptions ++= Seq(
        "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED"
    ),
    name := name.value,
    scalaVersion := scalaVersion.value,
    libraryDependencies ++= Seq(
      "io.delta" %% "delta-core" % deltaVersion,
      "org.apache.spark" %% "spark-sql" % sparkVersion
    ),
    ThisBuild / versionScheme := Some("semver-spec"),
    extraMavenRepo,
    resolvers += Resolver.mavenLocal,
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature"
    ),
    Compile / packageBin / mainClass := Some("com.requiredprofessionals.brightscale.Streaming"),
    Compile / run / mainClass := Some("com.requiredprofessionals.brightscale.Streaming")
  )