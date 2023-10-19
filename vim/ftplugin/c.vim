"""""""""""""""""""""""""" cscope stuff

set cscopetag
" Suppress an error if .vimrc is sourced after the DB is added.
set nocscopeverbose
if $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif
set cscopeverbose

nnoremap <leader>cadd :Cscope open<CR>
nnoremap <leader>cnew :Cscope add<CR>
nnoremap <leader>creg :Cscope regen<CR>
nnoremap <leader>csel :Cscope select<CR>

command -nargs=1 Ca Cscope find a <args>
nnoremap <C-\>a :Cscope find a <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>la :Cscope find a <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ua :Cscope find a <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <C-@>a :scs find a <C-R>=expand("<cword>")<CR><CR>
"nnoremap <C-@><C-@>a :vert scs find a <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cc Cscope find c <args>
nnoremap <C-\>c :Cscope find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>lc :Cscope find c <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>uc :Cscope find c <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"nnoremap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cd Cscope find d <args>
nnoremap <C-\>d :Cscope find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ld :Cscope find d <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ud :Cscope find d <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <C-@>d :Cscope find d <C-R>=expand("<cword>")<CR><CR>
"nnoremap <C-@><C-@>d :vert cs find d <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Ce Cscope find e <args>
nnoremap <C-\>e :Cscope find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>le :Cscope find e <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ue :Cscope find e <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <C-@>e :Cscope find e <C-R>=expand("<cword>")<CR><CR>
"nnoremap <C-@><C-@>e :vert cs find e <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cf Cscope find f <args>
nnoremap <C-\>f :Cscope find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>lf :Cscope find f <C-R>=tolower(expand("<cfile>"))<CR><CR>
nnoremap <C-\>uf :Cscope find f <C-R>=toupper(expand("<cfile>"))<CR><CR>
"nnoremap <C-@>f :Cscope find f <C-R>=expand("<cfile>")<CR><CR>
"nnoremap <C-@><C-@>f :vert cs find f <C-R>=expand("<cfile>")<CR><CR>

command -nargs=1 Cg Cscope find g <args>
nnoremap <C-\>g :Cscope find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>lg :Cscope find g <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ug :Cscope find g <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <C-@>g :Cscope find g <C-R>=expand("<cword>")<CR><CR>
"nnoremap <C-@><C-@>g :vert cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-]> :Cscope find g <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cs Cscope find s <args>
nnoremap <C-\>s :Cscope find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ls :Cscope find s <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>us :Cscope find s <C-R>=toupper(expand("<cword>"))<CR><CR>
"nnoremap <C-@>s :Cscope find s <C-R>=expand("<cword>")<CR><CR>
"nnoremap <C-@><C-@>s :vert cs find s <C-R>=expand("<cword>")<CR><CR>

" Reset the cscope connection.
nnoremap <leader>cr :Cscope reset<CR>
