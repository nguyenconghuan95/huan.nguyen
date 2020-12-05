SHELL = /bin/csh 

DV_ROOT = /proj/${MRVL_PROJECT}/wa/${USER}/training/frontend

all:
	@-find ${DV_ROOT} -maxdepth 5 -type f -or -type l | egrep '\.c$$|\.cpp$$|\.h$$' | xargs readlink -f > cscope.files
	@-cscope -b -q -k
