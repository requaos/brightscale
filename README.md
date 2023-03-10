## Brightscale

### A DeltaLake demo using Scala v2.13 on Spark v3.3.1, Scala v2.13 on Deltalake Standalone and a suite of maintenance utilities written in Rust using Delta-rs

#### Demo setup:

On NixOS, get a completely ephemeral development environment:
This leverages the work from [typelevel](https://github.com/typelevel/typelevel-nix)

```shell
nix develop github:typelevel/typelevel-nix#application
```

Build scala demo:
This is the scala [streaming example from delta-io](https://github.com/delta-io/delta/blob/master/examples/scala/src/main/scala/example/Streaming.scala)

```shell
sbt -Dsbt.ivy.home=./dist/ publishLocal
```

Launch demo:
Initial spark configuration using docker and docker-compose adapted from: [Creating a Spark Standalone Cluster with Docker and docker-compose(2021 update)](https://dev.to/mvillarrealb/creating-a-spark-standalone-cluster-with-docker-and-docker-compose-2021-update-6l4)

```shell
docker-compose up --build
```


Submit job to spark manually (runs in console container and prints verbose logs for troubleshooting):

```shell
docker run -it -e "SPARK_WORKLOAD=submit" -v $PWD/dist:/opt/spark-apps --network=brightscale_default brightscale-spark-console /bin/bash

/opt/spark/bin/spark-submit --verbose --master spark://spark-master:7077 --class brightscale.Streaming --packages io.delta:delta-core_2.13:2.2.0 --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=log4j2.properties" --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=log4j2.properties" --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" file:///opt/spark-apps/local/com.requiredprofessionals/brightscale_2.13/0.1.0-SNAPSHOT/jars/brightscale_2.13.jar
```
