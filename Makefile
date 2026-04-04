
PROJECTS=lamppsu lampguard
PCBA=

BASENAME=project
BOARDHOUSE=jlc
PARTNO_MARKING=JLCJLCJLCJLC
BOM_JLC_OPTS=--fields='Value,Reference,Footprint,LCSC' --labels='Comment,Designator,Footprint,JLCPCB Part \#' --group-by=LCSC --ref-range-delimiter='' --exclude-dnp

REQUIRE_DRC=y

PCB_VARIABLES=-D PCB_ORDER_NUMBER="$(PARTNO_MARKING)"
GERBER_OPTS=--no-x2 --no-netlist --no-protel-ext $(PCB_VARIABLES)
DRC_OPTS=--exit-code-violations $(PCB_VARIABLES)
DRILL_OPTS=--format=excellon --excellon-oval-format=route --excellon-separate-th
BOM_OPTS=$(BOM_JLC_OPTS)
POS_OPTS=--exclude-dnp --side front --units=mm --format=csv

LAYERS2=F.Cu B.Cu F.Mask B.Mask F.Paste B.Paste F.Silkscreen B.Silkscreen Edge.Cuts
LAYERS4=$(LAYERS2) In1.Cu In2.Cu
LAYERS :=$(LAYERS2)

SCAD_DIR=case
SCAD_DEPS=case/model.scad case/pcb.scad case/wago.scad case/fuse.scad case/mw_irm.scad case/utils.scad
SCAD_PARAM_DIR=case/parameters
SCAD_PARAM_SET=default
SCAD_PARTS=lamppsu/cover lamppsu/clamp_base lamppsu/clamp_clamp lamppsu/cover_latches lamppsu/flute

SCAD_DEFINES=

include rules.mk

