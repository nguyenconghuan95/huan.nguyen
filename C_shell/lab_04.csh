#!/bin/csh

if (-f ../output/output.csv) then
  rm -f ../output/output.csv
endif
touch ../output/output.csv

#echo "From CHECKLIST,,,From RTL,,,," >> ../output/output.csv
#echo "\"Terminal name" >> ../output/output.csv
#echo "(1)\",I/O,Bit width,\"Terminal name" >> ../output/output.csv
#echo "(1)\",I/O,Bit width,Line number in RTL,Judgement" >> ../output/output.csv

set i = 5
set file_len = `wc -l < ../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv`

while ($i <= 20)
  set signal = `sed -n "$i"p ../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv | awk -F ","  '{print $1}'`
  echo "$signal"
  set way    = `sed -n "$i"p ../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv | awk -F ","  '{print $2}'`
  set bit_width = `sed -n "$i"p ../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv | awk -F ","  '{print $3}'`
  @ i = $i + 1
  if ($way == 'I') then
    set direction = "input"
  else if ($way == 'O') 
    set direction = "output"
  endif
  set nu_of_matching = `grep "$signal;" ../input/SCP_AXI.v | grep  "$bit_width" | grep -c "^$direction"`
  echo $nu_of_matching
    grep "$signal;" ../input/SCP_AXI.v | grep "$bit_width" | grep -nr "^$direction"
    #echo "$line_nu\n"
end

  #if ($way == 'I') then
  #  set pattern = `printf "input  %-6s %s" "$bit_width" "$signal"`
  #else if ($way == 'O') 
  #  set pattern = `printf "output %-6s %s" "$bit_width" "$signal"`
  #endif

  #echo $pattern

#set x = `sed -n 18p ../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv | awk '{split($0,a,","); print a[3]}'` 
#set x = `sed -n 18p ../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv | awk -F ","  '{print $3}'`
#echo "$x"

