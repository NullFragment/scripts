#!/bin/bash


while true; do
  clear

  # Be sure to use the device id produced by the output of `xinput list`!
  xinput query-state $1

  # Alternatively, you can use the full device name:
  #     xinput query-state "Kingsis Peripherals Evoluent VerticalMouse 4"
  # will work as well.

  sleep 1
done
