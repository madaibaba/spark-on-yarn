## Spark on Yarn within Docker Containers


![alt tag](https://raw.githubusercontent.com/madaibaba/spark-on-yarn/master/spark-on-yarn.png)


#### 1. Clone Github Repository

```
git clone https://github.com/madaibaba/spark-on-yarn
```

#### 2. Pull Docker Image

```
sudo docker pull madaibaba/spark-on-yarn:3.0
```

#### 3. Create My Bridge Network

```
sudo docker network create -d bridge mybridge
```

#### 4. Start Docker Container

##### 4.1 Start Three Container for default (one master and two slaves)

```
cd spark-on-yarn
sudo ./start-container.sh
```

##### 4.2 Start six Container as below (one master and five slaves)

```
cd spark-on-yarn
sudo ./start-container.sh 6
```
