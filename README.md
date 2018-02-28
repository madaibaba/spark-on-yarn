## Spark on Yarn within Docker Containers


![alt tag](https://raw.githubusercontent.com/madaibaba/spark-on-yarn/master/spark-on-yarn.png)


#### 1. Clone Github Repository

```
git clone https://github.com/madaibaba/spark-on-yarn
```

#### 2. Pull Docker Image

```
sudo docker pull madaibaba/spark-on-yarn:1.0
```

#### 3. Start Docker Container

##### 3.1 Start Three Container for default (one master and two slaves)

```
cd spark-on-yarn
sudo ./start-container.sh
```

##### 3.2 Start six Container as below (one master and five slaves)

```
cd spark-on-yarn
sudo ./start-container.sh 6
```
