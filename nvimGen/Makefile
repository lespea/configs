.PHONY: gen genm clean

CLEAN=
#CLEAN=-m

OUT=../nvim
OUT_CONF=${OUT}/lua
OUT_INIT=${OUT}/init.lua

GEN=./gen
GEN_CONF=${GEN}/confs
GEN_INIT=${GEN}/init.lua

gen: compile move

move:
	xcp -r '${GEN_CONF}' '${OUT_CONF}'
	xcp -r '${GEN_INIT}' '${OUT_INIT}'

compile: clean
	yue ${CLEAN} -t ${GEN} init.yue
	yue ${CLEAN} -t ${GEN_CONF} confs/

clean:
	rm -rf '${GEN}' '${OUT_CONF}' '${OUT_INIT}'
	mkdir -p '${OUT_CONF}'

