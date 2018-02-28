#!/bin/bash

echo ""

echo -e "\nbuild docker spark-on-yarn:1.0 image\n"
sudo docker build -t madaibaba/spark-on-yarn:1.0 .

echo ""