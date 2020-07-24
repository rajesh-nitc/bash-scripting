#!/bin/bash

# Apache Bench
sudo apt-get install apache2-utils
ab -c 1000 -n 50000 -qSd http://104.154.231.30:8080/

# OUTPUT
# Concurrency Level: 1000
# Requests per second: 2980.93 [#/sec] (mean)
# Time per request: 335.465 [#ms] (mean)

# EXPLANATION
# The cluster handled about 3,000 requests per second
# It completed most requests in around 300 milliseconds