SHELL = /bin/csh 

# Path to simulation directory
# In this case, I point to "tuantran" folder because he runs sanity check periodically
# so that I always have latest _info files
SIM_WORK_DIR = /proj/${MRVL_PROJECT}/wa/${USER}/training/frontend/uvm/lab6

# Path to "cscope". Use the built inside soctool0v for newer version
# CSCOPE_CMD = /proj/soctool0v/wa/${USER}/tool/cscope/latest/bin/cscope"
CSCOPE_CMD = /bin/cscope

tmpfile = links.lst

all: gen_list_from_build gen_list gen_cscope

#Origin gen_list_from_build:
#Origin 	@egrep "^F"         ${SIM_WORK_DIR}/rtllib/_info | sed 's/^F//' > v_list
#Origin 	@egrep " F\/proj\/" ${SIM_WORK_DIR}/rtllib/_info | sed 's/.* F\/proj\//\/proj\//' >> v_list
#Origin 	@egrep "^F"         ${SIM_WORK_DIR}/dvlib/_info | sed 's/^F//' >> v_list
#Origin 	@egrep " F\/proj\/" ${SIM_WORK_DIR}/dvlib/_info | sed 's/.* F\/proj\//\/proj\//' >> v_list

gen_list_from_build:
	@-egrep "^F"         ${SIM_WORK_DIR}/work/_info | sed 's/^F//' > v_list
	@-egrep " F\/proj\/" ${SIM_WORK_DIR}/work/_info | sed 's/.* F\/proj\//\/proj\//' >> v_list

gen_list:
	@echo "[INFO] create tmpfile"
	@cat ./v_list > ${tmpfile}
#	@echo "[INFO] append .v, .bv and .sv from design folder to tmpfile"
#	@-find /proj/${MRVL_PROJECT}/wa/${USER}/sbox0/design/              -maxdepth 5 -type f -or -type l | egrep "\.v|\.bv|\.sv" >> $(tmpfile)
#	@echo "[INFO] append .v, .bv and .sv from sim folder to tmpfile"
#	@-find /proj/${MRVL_PROJECT}/wa/${USER}/sbox0/design/top/sim/model -maxdepth 5 -type f -or -type l | egrep "\.v|\.bv|\.sv" >> $(tmpfile)
#	@echo "[INFO] append .v, .bv and .sv from dv folder to tmpfile"
#	@-find /proj/${MRVL_PROJECT}/wa/${USER}/sbox0/dv/                  -maxdepth 5 -type f -or -type l | egrep "\.v|\.bv|\.sv" >> $(tmpfile)
##	@echo "[INFO] append .v, .bv and .sv from libset folder to tmpfile"
##	@-find /proj/vail1/libset/current_libset/       -maxdepth 5 -type f -or -type l | egrep "\.v|\.bv|\.sv" >> $(tmpfile)
	@echo "[INFO] sort tmpfile"
	@cat ${tmpfile} | sort -u > _${tmpfile}
	@mv _${tmpfile} ${tmpfile}
	@echo "[INFO] looking for all links"
	@-cat ${tmpfile} | xargs -ixx readlink -f xx > cscope.files
	@echo "[INFO] generating filepaths"
	@paste cscope.files ${tmpfile} > filepaths.lst

gen_cscope:
	find -maxdepth 1 -name "x*" | xargs rm -rf 
	split -l 1000 cscope.files
	find -maxdepth 1 -name "x*" | sed "s/^..//" | xargs -ixx echo "cscope -b -q -k -i xx -f cscope_xx.out &" > script
	echo "wait" >> script
	source script

