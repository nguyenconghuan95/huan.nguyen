function! LoadVerilogDB()
    for f in split(glob('/proj/$MRVL_PROJECT/wa/$USER/tool/cscope/database/verilog/cscope_*.out'), '\n')
        :exec "cs add " . f
    endfor
    if filereadable(expand("/proj/$MRVL_PROJECT/wa/$USER/tool/cscope/database/verilog/cscope.out"))
        :cs add /proj/$MRVL_PROJECT/wa/$USER/cscope/verilog/cscope.out
    endif
endfunction

if has("cscope")
    set csprg=/bin/cscope
    set csto=1
    set cst
    set notimeout

    autocmd FileType c,cpp,python,verilog,systemverilog :setlocal nocscopeverbose
    autocmd FileType c,cpp  :cs add /proj/$MRVL_PROJECT/wa/$USER/tool/cscope/database/c/cscope.out
    autocmd FileType python :cs add /proj/$MRVL_PROJECT/wa/$USER/tool/cscope/database/python/cscope.out
    autocmd FileType verilog,systemverilog :call LoadVerilogDB()
endif

""" Please use :help cscope for all options
nmap fs :cs find s <C-R>=expand("<cword>")<CR><CR><Tab>
nmap fa :cs find s <C-R>=expand("<cword>")<CR><CR><Tab>
nmap fd :cs find g <C-R>=expand("<cword>")<CR><CR><Tab>

