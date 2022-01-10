#!/bin/bash
ssh root@192.168.1.1 'wg' | grep 'interface' | awk '{print $2}'
