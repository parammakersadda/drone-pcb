# PEXADRONE (PARAM + HEXADRONE)

(under early stage development)

open source drone with 6 coreless motors, using stm32f030c8t6 chip, and nrf24l01+ for radio

# LICENSE

Licensed under CERN Open Hardware Licence Version 2 - Weakly Reciprocal  
check "LICENSE" file for the license

# Images

There are 3d model files available in the 3dModels folder, in both stl and glb file formats.

> Note:
> "makefile" can be used by typing ```make``` in the project root directory, to automatically update the svg images, PDFs and 3d models as the kicad files change.  
> The makefile uses kicad-cli to generate the resources.

[3d model](3dModels/drone-pcb.stl)
![3d rendering of the front view of the pcb](images/drone-pcb-front-3dModel.png)

[schematic](PDFs/drone-pcb-schematic.pdf)
![schematic view](images/drone-pcb.svg)

[pcb routing](PDFs/drone-pcb-board.pdf)
![pcb view](images/drone-pcb-routing.svg)
