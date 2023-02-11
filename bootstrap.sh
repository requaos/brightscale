#!/bin/bash

. "/opt/spark/bin/load-spark-env.sh"

if [ "$SPARK_WORKLOAD" == "master" ];
then

export SPARK_MASTER_HOST=`hostname`

touch $SPARK_MASTER_LOG
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.master.Master --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG

elif [ "$SPARK_WORKLOAD" == "worker" ];
then

touch $SPARK_WORKER_LOG
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG

elif [ "$SPARK_WORKLOAD" == "submit" ];
then
    echo "SPARK SUBMIT" && sleep 4s
    cd /opt/spark/bin && ./spark-submit --deploy-mode cluster --master spark://spark-master:7077 --total-executor-cores 3 --class com.requiredprofessionals.brightscale.Streaming --packages io.delta:delta-core_2.13:2.2.0 --conf "spark.executor.extraJavaOptions=-Dlog4j.configuration=log4j2.properties" --conf "spark.driver.extraJavaOptions=-Dlog4j.configuration=log4j2.properties" --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" file:///opt/spark-apps/local/com.requiredprofessionals/brightscale_2.13/0.1.0-SNAPSHOT/jars/brightscale_2.13.jar
else
    echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker, submit"
fi