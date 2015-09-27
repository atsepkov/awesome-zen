#!/usr/bin/env bash
# Copyright 2015 Alexander Tsepkov

sensors | awk '/^Core/ {t=substr($3,2,4);if (t>max) max=t} END {print max}'
