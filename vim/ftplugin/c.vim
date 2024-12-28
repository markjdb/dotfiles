"""""""""""""""""""""""""" cscope stuff

nnoremap <buffer> <leader>cadd :Cscope open<CR>
nnoremap <buffer> <leader>cnew :Cscope add<CR>
nnoremap <buffer> <leader>creg :Cscope regen<CR>
nnoremap <buffer> <leader>csel :Cscope select<CR>

command -buffer -nargs=1 Ca Cscope find a <args>
nnoremap <buffer> <C-\>a :Cscope find a <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>la :Cscope find a <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <buffer> <C-\>ua :Cscope find a <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <buffer> <C-@>a :scs find a <C-R>=expand("<cword>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>a :vert scs find a <C-R>=expand("<cword>")<CR><CR>

command -buffer -nargs=1 Cc Cscope find c <args>
nnoremap <buffer> <C-\>c :Cscope find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>lc :Cscope find c <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <buffer> <C-\>uc :Cscope find c <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <buffer> <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>

command -buffer -nargs=1 Cd Cscope find d <args>
nnoremap <buffer> <C-\>d :Cscope find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>ld :Cscope find d <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <buffer> <C-\>ud :Cscope find d <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <buffer> <C-@>d :Cscope find d <C-R>=expand("<cword>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>d :vert cs find d <C-R>=expand("<cword>")<CR><CR>

command -buffer -nargs=1 Ce Cscope find e <args>
nnoremap <buffer> <C-\>e :Cscope find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>le :Cscope find e <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <buffer> <C-\>ue :Cscope find e <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <buffer> <C-@>e :Cscope find e <C-R>=expand("<cword>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>e :vert cs find e <C-R>=expand("<cword>")<CR><CR>

command -buffer -nargs=1 Cf Cscope find f <args>
nnoremap <buffer> <C-\>f :Cscope find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <buffer> <C-\>lf :Cscope find f <C-R>=tolower(expand("<cfile>"))<CR><CR>
nnoremap <buffer> <C-\>uf :Cscope find f <C-R>=toupper(expand("<cfile>"))<CR><CR>
"nnoremap <buffer> <C-@>f :Cscope find f <C-R>=expand("<cfile>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>f :vert cs find f <C-R>=expand("<cfile>")<CR><CR>

command -buffer -nargs=1 Cg Cscope find g <args>
nnoremap <buffer> <C-\>g :Cscope find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>lg :Cscope find g <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <buffer> <C-\>ug :Cscope find g <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <buffer> <C-@>g :Cscope find g <C-R>=expand("<cword>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>g :vert cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-]> :Cscope find g <C-R>=expand("<cword>")<CR><CR>

command -buffer -nargs=1 Cs Cscope find s <args>
nnoremap <buffer> <C-\>s :Cscope find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <buffer> <C-\>ls :Cscope find s <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <buffer> <C-\>us :Cscope find s <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <buffer> <C-@>s :Cscope find s <C-R>=expand("<cword>")<CR><CR>
"nnoremap <buffer> <C-@><C-@>s :vert cs find s <C-R>=expand("<cword>")<CR><CR>

" Reset the cscope connection.
nnoremap <buffer> <leader>cr :Cscope reset<CR>
