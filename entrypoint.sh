#!/bin/bash

set -e

mkdir -p $HOME/.config
cp -r /home/kicad/.config/kicad $HOME/.config/

erc_violation=0 # ERC exit code
drc_violation=0 # DRC exit code

# TODO ADD VERSION CHECK MINIMAL 8.0
# TODO ADD VERSION CHECK FOR SPECIFIC 9.0 COMMANDS


# Check if any schematic output/erc are selected without the file being present
if [[ -z $INPUT_SCHEMATIC_FILE && (
    $INPUT_RUN_ERC == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_PDF == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_SVG == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_BOM == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_NETLIST == "true" )
]]; then
    echo "::warning::Schematic output/ERC options selected without a schematic file. These output actions will be skipped."
fi

# Check if any PCB output/drc are selected without the file being present
if [[ -z $INPUT_PCB_FILE && (
    $INPUT_RUN_DRC == "true" )
]]; then
    echo "::warning::PCB output/DRC options selected without a PCB file. These output actions will be skipped."
fi

# Run schematic outputs
if [[ -n $INPUT_SCHEMATIC_FILE ]]; then
  if [[ $INPUT_RUN_ERC == "true" ]]; then
    kicad-cli sch erc \
      --output "$INPUT_ERC_OUTPUT_FILE_NAME" \
      --exit-code-violations \
      "$INPUT_SCHEMATIC_FILE"
    erc_violation=$?
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_PDF == "true" ]]; then
    cmd=(kicad-cli sch export pdf --output "$INPUT_SCHEMATIC_OUTPUT_PDF_FILE_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_SVG == "true" ]]; then
    cmd=(kicad-cli sch export svg --output "$INPUT_SCHEMATIC_OUTPUT_SVG_FOLDER_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_BOM == "true" ]]; then
    kicad-cli sch export bom \
      --output "$INPUT_SCHEMATIC_OUTPUT_BOM_FILE_NAME" \
      "$INPUT_SCHEMATIC_FILE"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_NETLIST == "true" ]]; then
    kicad-cli sch export netlist \
      --output "$INPUT_SCHEMATIC_OUTPUT_NETLIST_FILE_NAME" \
      "$INPUT_SCHEMATIC_FILE"
  fi
fi

# Run DRC
if [[ -n $INPUT_PCB_FILE && $INPUT_RUN_DRC == "true" ]]; then
  kicad-cli pcb drc \
    --output "$INPUT_DRC_OUTPUT_FILE_NAME" \
    --exit-code-violations \
    "$INPUT_PCB_FILE"
  drc_violation=$?
fi

# Return non-zero exit code for ERC or DRC violations
if [[ $erc_violation -gt 0 ]] || [[ $drc_violation -gt 0 ]]; then
  exit 1
else
  exit 0
fi