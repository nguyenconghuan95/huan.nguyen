#!/bin/csh 

set output = "../output/output.csv"
set output_tmp = "../output/output_tmp.csv"

if (-f $output | -f $output_tmp) then
  rm -f $output $output_tmp
endif
touch $output $output_tmp

set checklst = "../input/ESPADA_SCP_AXI_Interface_check_Checklist.csv"
set script = "../input/SCP_AXI.v"

sed -n '5,$p' $checklst >> $output

set nu_of_line = `wc -l < $output`
set i = 1

while ($i <= $nu_of_line)
  set check_signal = `sed -n "$i"p $output | awk -F ',' '{print $1}'`
  set check_direction = `sed -n "$i"p $output | awk -F ',' '{print $2}'`
  set check_b_w = `sed -n "$i"p $output | awk -F ',' '{print $3}'`

  set signal_matching = `grep " $check_signal;" $script | grep -c "^input\|^output"`
  if ("$signal_matching" == '0') then
    awk -F, -v OFS="," -v nu="$i" 'NR==nu {$8="NG"}{print > "../output/output_tmp.csv"}' $output 
  else
    if ($signal_matching == '1') then
      if ($check_direction == "I") then 
        set check_dir_fmt = "input"
      else
        set check_dir_fmt = "output"
      endif
      echo $check_direct_fmt
    endif
    awk -F, -v OFS="," -v nu="$i" 'NR==nu {$8="OK"}{print > "../output/output_tmp.csv"}' $output 
  endif
  cp $output_tmp $output
  wc -l < $output
  @ i = $i + 1
end
