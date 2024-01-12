# big-data-scripts

This repository contains a Dockerfile that installs Hadoop and Spark on Ubuntu 20.04. 

Created for the Big Data course at PES University.

## Usage

1. Clone the repository
2. Make changes to the Dockerfile
    1. Ideally the Dockerfile should work as is, unless the Hadoop and Spark download links have expired
    2. If the links have expired, update the links in the Dockerfile (L4 to L6)
2. Build the image. Note that this step takes some time.
```bash
docker build . -t big-data
```
3. Run the container
```bash
docker run -it --entrypoint=/bin/bash -p 9870:9870 -p 9864:9864 -p 8088:8088 -p 22:22 -p 8080:8080 big-data
```
4. Start Hadoop and Spark by running the following commands in the container
```bash
/etc/init.d/ssh start
$HADOOP_HOME/sbin/start-all.sh
$SPARK_HOME/sbin/start-all.sh
```
After running the commands, type `jps` to check if all the services have started. You should be able to view the following processes.
```bash
352 DataNode
1398 Master
856 ResourceManager
570 SecondaryNameNode
189 NameNode
1645 Jps
990 NodeManager
1535 Worker
```
5. Once the services have started, you can access the Hadoop and Spark UIs at the following URLs:

| Service | URL |
| --- | --- |
| Hadoop NameNode | http://localhost:9870 |
| Hadoop DataNode | http://localhost:9864 |
| Hadoop ResourceManager | http://localhost:8088 |
| Spark Master | http://localhost:8080 |
