#!/bin/bash

set -e

mkdir -p $HOME/.config
cp -r /home/kicad/.config/kicad $HOME/.config/

erc_violation=0 # ERC exit code
drc_violation=0 # DRC exit code

# Check if any schematic output/erc are selected without the file being present
if [[ -z "$INPUT_SCHEMATIC_FILE" && (
    "$INPUT_RUN_ERC" == "true" || 
    "$INPUT_SCHEMATIC_OUTPUT_PDF" == "true" || 
    "$INPUT_SCHEMATIC_OUTPUT_SVG" == "true" || 
    "$INPUT_SCHEMATIC_OUTPUT_BOM" == "true" || 
    "$INPUT_SCHEMATIC_OUTPUT_NETLIST" == "true" )
]]; then
    echo "Error: Schematic output/ERC options selected without a schematic file."
    exit 1
fi

# Run ERC
if [[ -n $INPUT_SCHEMATIC_FILE && $INPUT_RUN_ERC == "true" ]]
then
  kicad-cli sch erc \
    --output "`dirname $INPUT_SCHEMATIC_FILE`/$INPUT_ERC_OUTPUT_FILE_NAME" \
    --exit-code-violations \
    "$INPUT_SCHEMATIC_FILE"
  erc_violation=$?
fi

# Run DRC
if [[ -n $INPUT_PCB_FILE && $INPUT_RUN_DRC == "true" ]]
then
  kicad-cli pcb drc \
    --output "`dirname $INPUT_PCB_FILE`/$INPUT_DRC_OUTPUT_FILE_NAME" \
    --exit-code-violations \
    "$INPUT_PCB_FILE"
  drc_violation=$?
fi

# Return non-zero exit code for ERC or DRC violations
if [[ $erc_violation -gt 0 ]] || [[ $drc_violation -gt 0 ]]
then
  exit 1
else
  exit 0
fi