#!/bin/csh

if (-f checklst_formated.txt) then
  rm -f checklst_formated.txt
endif

set checklst = "../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv"
set script = "../input/SCP_AXI.v"

sed -n '5,$p' $checklst | tr -d ' ' | awk -F ',' '{printf "%s %-6s %s;\n", $2, $3, $1}' > checklst_formated.txt
sed -i "s/^I/input /g" checklst_formated.txt
sed -i "s/^O/output/g" checklst_formated.txt

foreach line (`cat checklst_formated.txt`)
  set pattern = `echo $line | tr -d '\n'`
  grep -x $pattern $script
end 
