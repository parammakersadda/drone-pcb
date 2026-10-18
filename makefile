#current directory of makefile
makeDir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

schematicFile=$(makeDir)/drone-pcb.kicad_sch
pcbFile=$(makeDir)/drone-pcb.kicad_pcb

kicadFiles=$(makeDir)/drone-pcb.kicad_pro $(schematicFile) $(pcbFile)

all: $(makeDir)/images/drone-pcb-front-3dModel.png $(makeDir)/PDFs/drone-pcb-board.pdf $(makeDir)/images/drone-pcb-routing.svg $(makeDir)/PDFs/drone-pcb-schematic.pdf $(makeDir)/images/drone-pcb.svg $(makeDir)/3dModels/drone-pcb.glb $(makeDir)/3dModels/drone-pcb.stl 

#3d model of pcb
$(makeDir)/images/drone-pcb-front-3dModel.png: $(pcbFile)
	kicad-cli pcb render $^ -o $@

$(makeDir)/3dModels/drone-pcb.glb: $(pcbFile)
	kicad-cli pcb export glb $^ -o $@	
$(makeDir)/3dModels/drone-pcb.stl: $(pcbFile)
	kicad-cli pcb export stl $^ -o $@	

#pcb copper trace routing
$(makeDir)/PDFs/drone-pcb-board.pdf: $(pcbFile)
	kicad-cli pcb export pdf --layers "*" $^ -o $@
$(makeDir)/images/drone-pcb-routing.svg: $(pcbFile)
	kicad-cli pcb export svg -l "*" $^ -o $@

#pcb schematics
$(makeDir)/PDFs/drone-pcb-schematic.pdf: $(schematicFile)
	kicad-cli sch export pdf $^ -o $@ 
$(makeDir)/images/drone-pcb.svg: $(schematicFile)
	kicad-cli sch export svg $^ -o $(dir $@)
