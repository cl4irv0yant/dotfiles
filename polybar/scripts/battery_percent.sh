#!/bin/bash

percent=$(acpi -b | awk '{print $4}' | sed 's/%//' | sed 's/,//')

echo "${percent}%"
