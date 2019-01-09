#!/bin/bash

echo ""

echo -e "\nbuild docker spark-on-yarn:2.0 image\n"
sudo docker build -t madaibaba/spark-on-yarn:2.0 .

echo ""