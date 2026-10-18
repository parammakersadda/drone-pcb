makeDir=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

schematicFile=$(makeDir)/drone-pcb.kicad_sch
pcbFile=$(makeDir)/drone-pcb.kicad_pcb

kicadFiles=$(makeDir)/drone-pcb.kicad_pro $(schematicFile) $(pcbFile)

$(makeDir)/PDFs/drone-pcb-board.pdf: $(pcbFile)

$(makeDir)/images/drone-pcb-F_Cu.svg: $(pcbFile)

$(makeDir)/images/drone-pcb-front-3dModel.png: $(pcbFile)

$(makeDir)/PDFs/drone-pcb-schematic.pdf: $(schematicFile)

$(makeDir)/images/drone-pcb.svg: $(schematicFile)

