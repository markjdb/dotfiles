"""""""""""""""""""""""""" cscope stuff

if exists("b:did_ftplugin")
    finish
endif

let b:did_ftplugin = 1

set cscopetag
" Suppress an error if .vimrc is sourced after the DB is added.
set nocscopeverbose
if $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif
set cscopeverbose

nnoremap <leader>cadd :call CscopeMgrLoadDB()<CR>
nnoremap <leader>cnew :call CscopeMgrAdd()<CR>
nnoremap <leader>creg :call CscopeMgrRegen()<CR>
nnoremap <leader>csel :call CscopeMgrSelect()<CR>

command -nargs=1 Ca cs find a <args>
nnoremap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>la :cs find a <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ua :cs find a <C-R>=toupper(expand("<cword>"))<CR><CR>
nnoremap <C-@>a :scs find a <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>a :vert scs find a <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cc cs find c <args>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>lc :cs find c <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>uc :cs find c <C-R>=toupper(expand("<cword>"))<CR><CR>
nnoremap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cd cs find d <args>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ld :cs find d <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ud :cs find d <C-R>=toupper(expand("<cword>"))<CR><CR>
nnoremap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>d :vert cs find d <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Ce cs find e <args>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>le :cs find e <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ue :cs find e <C-R>=toupper(expand("<cword>"))<CR><CR>
nnoremap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>e :vert cs find e <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cf cs find f <args>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>lf :cs find f <C-R>=tolower(expand("<cfile>"))<CR><CR>
nnoremap <C-\>uf :cs find f <C-R>=toupper(expand("<cfile>"))<CR><CR>
nnoremap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-@><C-@>f :vert cs find f <C-R>=expand("<cfile>")<CR><CR>

command -nargs=1 Cg cs find g <args>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>lg :cs find g <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>ug :cs find g <C-R>=toupper(expand("<cword>"))<CR><CR>
nnoremap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>g :vert cs find g <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cs cs find s <args>
nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ls :cs find s <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-\>us :cs find s <C-R>=toupper(expand("<cword>"))<CR><CR>
nnoremap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>s :vert cs find s <C-R>=expand("<cword>")<CR><CR>

" Reset the cscope connection.
nnoremap <leader>cr :cs reset<CR>

" Let ctrl-T and ctrl-] use coc.nvim as the provider.  This has to
" be set after enabling cscope, it seems...
"set tagfunc=CocTagFunc
