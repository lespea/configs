.PHONY: gen genm clean

#CLEAN=-W
CLEAN=-m -W

OUT=../nvim
OUT_CONF=${OUT}/lua
OUT_INIT=${OUT}/init.lua

GEN=./gen
GEN_CONF=${GEN}/confs
GEN_INIT=${GEN}/init.lua

#MV=xcp -r
MV=mv

gen: compile move

move:
	${MV} '${GEN_CONF}' '${OUT_CONF}'
	${MV} '${GEN_INIT}' '${OUT_INIT}'

compile: clean
	yue ${CLEAN} -t ${GEN} init.yue
	yue ${CLEAN} -t ${GEN_CONF}/bla confs/

clean:
	rm -rf '${GEN}' '${OUT_CONF}' '${OUT_INIT}'
	mkdir -p '${OUT_CONF}'

