#!/bin/bash

percent=$(acpi -b | awk '{print $4}' | sed 's/%,//')

echo "${percent}%"
