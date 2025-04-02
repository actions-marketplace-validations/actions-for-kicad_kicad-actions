#!/bin/bash

set -e

mkdir -p $HOME/.config
cp -r /home/kicad/.config/kicad $HOME/.config/

erc_violation=0 # ERC exit code
drc_violation=0 # DRC exit code

# TODO ADD VERSION CHECK MINIMAL 8.0
# TODO ADD VERSION CHECK FOR SPECIFIC 9.0 COMMANDS


# Check if any schematic output/erc are selected without the file being present
if [[ -z $INPUT_SCHEMATIC_FILE_NAME && (
    $INPUT_RUN_ERC == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_PDF == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_SVG == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_BOM == "true" || 
    $INPUT_SCHEMATIC_OUTPUT_NETLIST == "true" )
]]; then
    echo "::error::Schematic output/ERC options selected without a schematic file."
    exit 1
fi

# Check if any PCB output/drc are selected without the file being present
if [[ -z $INPUT_PCB_FILE_NAME && (
    $INPUT_PCB_OUTPUT_DRILL == "true" )
]]; then
    echo "::error::PCB output/DRC options selected without a PCB file."
    exit 1
fi

# Run schematic outputs
if [[ -n $INPUT_SCHEMATIC_FILE_NAME ]]; then
  if [[ $INPUT_RUN_ERC == "true" ]]; then
    kicad-cli sch erc \
      --output "$INPUT_ERC_OUTPUT_FILE_NAME" \
      --exit-code-violations \
      "$INPUT_SCHEMATIC_FILE_NAME"
    erc_violation=$?
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_PDF == "true" ]]; then
    cmd=(kicad-cli sch export pdf --output "$INPUT_SCHEMATIC_OUTPUT_PDF_FILE_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE_NAME"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_SVG == "true" ]]; then
    cmd=(kicad-cli sch export svg --output "$INPUT_SCHEMATIC_OUTPUT_SVG_FOLDER_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE_NAME"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_DXF == "true" ]]; then
    cmd=(kicad-cli sch export dxf --output "$INPUT_SCHEMATIC_OUTPUT_DXF_FOLDER_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE_NAME"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_HPGL == "true" ]]; then
    cmd=(kicad-cli sch export hpgl --output "$INPUT_SCHEMATIC_OUTPUT_HPGL_FOLDER_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE_NAME"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_PS == "true" ]]; then
    cmd=(kicad-cli sch export ps --output "$INPUT_SCHEMATIC_OUTPUT_PS_FOLDER_NAME")
    [[ $INPUT_SCHEMATIC_OUTPUT_BLACK_WHITE == "true" ]] && cmd+=(--black-and-white)
    "${cmd[@]}" "$INPUT_SCHEMATIC_FILE_NAME"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_BOM == "true" ]]; then
    kicad-cli sch export bom \
      --output "$INPUT_SCHEMATIC_OUTPUT_BOM_FILE_NAME" \
      "$INPUT_SCHEMATIC_FILE_NAME"
  fi

  if [[ $INPUT_SCHEMATIC_OUTPUT_NETLIST == "true" ]]; then
    kicad-cli sch export netlist \
      --output "$INPUT_SCHEMATIC_OUTPUT_NETLIST_FILE_NAME" \
      "$INPUT_SCHEMATIC_FILE_NAME"
  fi
fi

# Run DRC
if [[ -n $INPUT_PCB_FILE_NAME ]]; then
  if [[ $INPUT_RUN_DRC == "true" ]]; then
    kicad-cli pcb drc \
      --output "$INPUT_DRC_OUTPUT_FILE_NAME" \
      --exit-code-violations \
      "$INPUT_PCB_FILE_NAME"
    drc_violation=$?
  fi

  if [[ $INPUT_PCB_OUTPUT_DRILL == "true" ]]; then
    kicad-cli pcb export drill \
      --output "$INPUT_PCB_OUTPUT_DRILL_FOLDER_NAME" \
      --format "$INPUT_PCB_OUTPUT_DRILL_FORMAT" \
      "$INPUT_PCB_FILE_NAME"
  fi

  if [[ $INPUT_PCB_OUTPUT_GERBERS == "true" ]]; then
    cmd=(kicad-cli pcb export gerbers --output "$INPUT_PCB_OUTPUT_GERBERS_FOLDER_NAME")
    [[ -n $INPUT_PCB_OUTPUT_LAYERS ]] && cmd+=(--layers "$pcb_output_layers")
    "${cmd[@]}" "$INPUT_PCB_FILE_NAME"

    if [[ $INPUT_PCB_OUTPUT_GERBERS_ZIP == "true" ]]; then
      zip -r "$INPUT_PCB_OUTPUT_GERBERS_ZIP_FILE_NAME.zip" "$INPUT_PCB_OUTPUT_GERBERS_FOLDER_NAME/*"
      rm -rf "$INPUT_PCB_OUTPUT_GERBERS_FOLDER_NAME"
    fi
  fi

  if [[ $INPUT_PCB_OUTPUT_DXF == "true" ]]; then
    if [[ -z $INPUT_PCB_OUTPUT_LAYERS ]]; then
      echo "::error::No layers set for PCB output."
      exit 1
    fi

    kicad-cli pcb export dxf \
      --output "$INPUT_PCB_OUTPUT_DXF_FILE_NAME" \
      --layers "$INPUT_PCB_OUTPUT_LAYERS" \
      "$INPUT_PCB_FILE_NAME"
  fi
fi

# Return non-zero exit code for ERC or DRC violations
if [[ $erc_violation -gt 0 ]] || [[ $drc_violation -gt 0 ]]; then
  exit 1
else
  exit 0
fi