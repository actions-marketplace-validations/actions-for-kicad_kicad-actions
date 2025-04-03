# KiCad actions

A GitHub action that can generate and check KiCad schematics and PCB's.

# Usage

See [action.yml](action.yml)

```yaml
steps:
  - name: Checkout Repository
    uses: actions/checkout@v4

  - name: Run KiCad actions
    uses: actions-for-kicad/kicad-actions@v1-k9.0
    with:
      schematic_file_name: "./file.kicad_sch"
      run_erc: true
      schematic_output_pdf: true

      pcb_file_name: "./file.kicad_pcb"
      run_drc: true
      pcb_output_gerbers_and_drill: true
      pcb_output_gerbers_and_drill_format: "zip"

  - name: Upload schematic
    uses: actions/upload-artifact@v4
    with:
      name: "schematic.pdf"
      path: "./schematic.pdf"

  - name: Upload gerbers and drill file
    uses: actions/upload-artifact@v4
    with:
      name: "gerbers.zip"
      path: "./gerbers.zip"
```

# Inputs

## `schematic_file_name`

Required: `True`

Description: Location of the .kicad_sch file.

## `run_erc`

Required: `False`
Default: `False`

Description: Run the ERC (Electrical Rules Check) on the schematic.

## `erc_output_file_name`

Required: `False`
Default: erc.rpt

Description: Output file name of ERC report.

## `schematic_output_pdf`

Required: `False`
Default: `False`

Description: Run the PDF export of the schematic.

## `schematic_output_pdf_file_name`

Required: `False`
Default: schematic.pdf

Description: Output file name of PDF schematic.

## `schematic_output_black_white`

Required: `False`
Default: `False`

Description: Run the PDF, SVG, DXF, and PS schematic export in black and white.

## `schematic_output_svg`

Required: `False`
Default: `False`

Description: Run the SVG export of the schematic.

## `schematic_output_svg_folder_name`

Required: `False`
Default: `schematics`

Description: Output folder name of SVG schematic.

## `schematic_output_dxf`

Required: `False`
Default: `False`

Description: Run the DXF export of the schematic.

## `schematic_output_dxf_folder_name`

Required: `False`
Default: `schematics`

Description: Output folder name of DXF schematic.

## `schematic_output_hpgl`

Required: `False`
Default: `False`

Description: Run the HPGL export of the schematic.

## `schematic_output_hpgl_folder_name`

Required: `False`
Default: `schematics`

Description: Output folder name of HPGL schematic.

## `schematic_output_ps`

Required: `False`
Default: `False`

Description: Run the PS export of the schematic.

## `schematic_output_ps_folder_name`

Required: `False`
Default: `schematics`

Description: Output folder name of PS schematic.

## `schematic_output_bom`

Required: `False`
Default: `False`

Description: Run the BOM (Bill of Materials) export of the schematic.

## `schematic_output_bom_file_name`

Required: `False`
Default: `bom.csv`

Description: Output file name of the BOM.

## `schematic_output_netlist`

Required: `False`
Default: `False`

Description: Run the netlist export of the schematic.

## `schematic_output_netlist_file_name`

Required: `False`
Default: `netlist.net`

Description: Output file name of the netlist.

## `pcb_file_name`

Required: `True`

Description: Location of the .kicad_pcb file.

## `run_drc`

Required: `False`
Default: `False`

Description: Run the DRC (Design Rules Check) on the PCB.

## `drc_output_file_name`

Required: `False`
Default: `drc.rpt`

Description: Output file name of DRC report.

## `pcb_output_drill`

Required: `False`
Default: `False`

Description: Run the drill export of the PCB.

## `pcb_output_drill_folder_name`

Required: `False`
Default: `drill`

Description: Output folder name of drill file.

## `pcb_output_drill_format`

Required: `False`
Default: `excellon`

Description: Format of the drill file. Options:

- excellon
- gerber

## `pcb_output_gerbers`

Required: `False`
Default: `False`

Description: Run the gerber export of the PCB.

## `pcb_output_gerbers_folder_name`

Required: `False`
Default: `gerbers`

Description: Output folder name of gerber files.

## `pcb_output_gerbers_format`

Required: `False`
Default: `folder`

Description: Format of the gerber files. Options:

- folder
- zip

## `pcb_output_layers`

Required: `False`

Description: Output layers of the PCB.

## `pcb_output_gerbers_and_drill`

Required: `False`
Default: `False`

Description: Run the gerber and drill export of the PCB.

## `pcb_output_gerbers_and_drill_folder_name`

Required: `False`
Default: `gerbers`

Description: Output folder name of gerber and drill files.

## `pcb_output_gerbers_and_drill_format`

Required: `False`
Default: `folder`

Description: Format of the gerber and drill files. Options:

- folder
- zip

## `pcb_output_dxf`

Required: `False`
Default: `False`

Description: Run the DXF export of the PCB.

## `pcb_output_dxf_folder_name`

Required: `False`
Default: `dxf`

Description: Output folder name of DXF PCB.

## `pcb_output_pdf`

Required: `False`
Default: `False`

Description: Run the PDF export of the PCB.

## `pcb_output_pdf_file_name`

Required: `False`
Default: `pcb.pdf`

Description: Output file name of PDF PCB.

## `pcb_output_black_white`

Required: `False`
Default: `False`

Description: Run the PDF and SVG PCB export in black and white.

## `pcb_output_svg`

Required: `False`
Default: `False`

Description: Run the SVG export of the PCB.

## `pcb_output_svg_file_name`

Required: `False`
Default: `pcb.svg`

Description: Output file name of SVG PCB.

## `pcb_output_pos`

Required: `False`
Default: `False`

Description: Run the POS export of the PCB.

## `pcb_output_pos_file_name`

Required: `False`
Default: `pcb.pos`

Description: Output file name of POS PCB.

## `pcb_output_pos_format`

Required: `False`
Default: `ascii`

Description: Format of the POS file. Options:

- ascii
- csv
- gerber

## `pcb_output_pos_side`

Required: `False`
Default: `both`

Description: Side of the POS file. Options:

- front
- back
- both

> **Note:** both is not supported by gerber.

## `pcb_output_ipc2581`

Required: `False`
Default: `False`

Description: Run the IPC-2581 export of the PCB.

## `pcb_output_ipc2581_file_name`

Required: `False`
Default: `pcb.xml`

Description: Output file name of IPC-2581 PCB.

## `pcb_output_step`

Required: `False`
Default: `False`

Description: Run the STEP export of the PCB.

## `pcb_output_step_file_name`

Required: `False`
Default: `pcb.step`

Description: Output file name of STEP PCB.

# License

The scripts and documentation in this project are released under the [MIT license](LICENSE).

# Contributions

Contributions are welcome! Please help me expand and maintain this repository.
