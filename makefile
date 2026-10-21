#current directory of makefile
makeDir := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
projectName= $(notdir $(makeDir))
$(info project name: $(projectName))

schematicFile=$(wildcard $(makeDir)/*.kicad_sch)
pcbFile=$(wildcard $(makeDir)/*.kicad_pcb)

all: $(makeDir)/exports/gerbers $(makeDir)/images/$(projectName)-front-3dModel.png $(makeDir)/images/$(projectName)-back-3dModel.png $(makeDir)/PDFs/$(projectName)-board.pdf $(makeDir)/images/$(projectName)-routing.svg $(makeDir)/PDFs/$(projectName)-schematic.pdf $(makeDir)/images/$(projectName).svg $(makeDir)/3dModels/$(projectName).glb $(makeDir)/3dModels/$(projectName).stl 

#exports to manufacturing format (gerber)
final_gerbers_zip=$(makeDir)/exports/$(projectName)-gerbers.zip
$(makeDir)/exports/gerbers: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export gerbers $^ -o $@ 
	zip -r $(final_gerbers_zip) $@

#3d model images
$(makeDir)/images/$(projectName)-front-3dModel.png: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb render $^ -o $@

$(makeDir)/images/$(projectName)-back-3dModel.png: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb render --side bottom $^ -o $@

#3d model of pcb
$(makeDir)/3dModels/$(projectName).glb: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export glb $^ -o $@	
$(makeDir)/3dModels/$(projectName).stl: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export stl $^ -o $@	

#pcb copper trace routing
layers=B.Cu,F.SilkS,B.SilkS,F.Mask,B.Mask,F.Paste,B.Paste,F.Fab,B.Fab,F.CrtYd,B.CrtYd,Dwgs.User,Cmts.User,Eco1.User,Eco2.User,Edge.Cuts,F.Cu

$(makeDir)/PDFs/$(projectName)-board.pdf: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export pdf --layers "$(layers)" $^ -o $@
$(makeDir)/images/$(projectName)-routing.svg: $(pcbFile)
	@mkdir -p "$(@D)"
	kicad-cli pcb export svg --fit-page-to-board --layers "$(layers)" $^ -o $@

#pcb schematics
$(makeDir)/PDFs/$(projectName)-schematic.pdf: $(schematicFile)
	@mkdir -p "$(@D)"
	kicad-cli sch export pdf $^ -o $@ 
$(makeDir)/images/$(projectName).svg: $(schematicFile)
	@mkdir -p "$(@D)"
	kicad-cli sch export svg $^ -o $(dir $@)

