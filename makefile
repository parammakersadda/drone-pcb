#current directory of makefile
makeDir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
projectName= $(notdir $(makeDir))
$(info project name: $(projectName))

schematicFile=$(wildcard $(makeDir)/*.kicad_sch)
pcbFile=$(wildcard $(makeDir)/*.kicad_pcb)

all: $(makeDir)/exports/gerbers $(makeDir)/images/$(projectName)-front-3dModel.png $(makeDir)/PDFs/$(projectName)-board.pdf $(makeDir)/images/$(projectName)-routing.svg $(makeDir)/PDFs/$(projectName)-schematic.pdf $(makeDir)/images/$(projectName).svg $(makeDir)/3dModels/$(projectName).glb $(makeDir)/3dModels/$(projectName).stl 

#exports to manufacturing format (gerber)
final_gerbers_zip=$(makeDir)/exports/$(projectName)-gerbers.zip
$(makeDir)/exports/gerbers: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export gerbers $^ -o $@ 
	zip -r $(final_gerbers_zip) $@

#3d model of pcb
$(makeDir)/images/$(projectName)-front-3dModel.png: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb render $^ -o $@

$(makeDir)/3dModels/$(projectName).glb: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export glb $^ -o $@	
$(makeDir)/3dModels/$(projectName).stl: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export stl $^ -o $@	

#pcb copper trace routing
$(makeDir)/PDFs/$(projectName)-board.pdf: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export pdf --layers "*" $^ -o $@
$(makeDir)/images/$(projectName)-routing.svg: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export svg -l "*" $^ -o $@

#pcb schematics
$(makeDir)/PDFs/$(projectName)-schematic.pdf: $(schematicFile)
	@mkdir -p "$(@D)"
	kicad-cli sch export pdf $^ -o $@ 
$(makeDir)/images/$(projectName).svg: $(schematicFile)
	@mkdir -p "$(@D)"
	kicad-cli sch export svg $^ -o $(dir $@)
