#!/bin/bash
docker build -t osodevops/cp-ansible:6.1.1-post .
docker push osodevops/cp-ansible:6.1.1-post
