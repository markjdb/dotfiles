set autoindent
set smartindent
set nobackup		" Don't back up my file when I save.
set shiftwidth=8
set tabstop=8
set autowrite		" Automatically save if the buffer is changed (e.g. with cscope).
set hlsearch		" Highlight search terms.
set ruler		" Display my position in the bottom right of the window.
set nu			" Turn on line numbering.
set lbr!		" Wrap lines at word boundaries.
set foldmethod=manual	" Folds must be created manually.
set cursorline		" Draw a horizontal line under the line being edited.
set noincsearch		" Disable incremental searching.
set history=10000
set wildmenu		" Create a nice menu when auto-completing file names.
set scrolloff=5		" Keep a minimum of 5 lines above and below the cursor.

" Default split layout, these feel more natural than the defaults.
set splitbelow
set splitright

" Keep track of where my cursor was last positioned when I exit.
set viminfo='10,\"100,:20,%,n~/.viminfo

" Colours.
set t_Co=256
set background=dark
colorscheme molokayo
let g:molokayo#focus_variant = 1

syntax enable
filetype on
filetype plugin on
filetype indent on

" Jump to the column of a mark when I hit '<mark>.
nnoremap ' `
nnoremap ` '

" Treat wrapped lines as separate lines.
map k gk
map j gj

" Convert the previous word to upper case.
inoremap <c-u> <esc>hviwUea

" Insert mode sequence to enter normal mode.
inoremap jk <esc>
inoremap <esc> <nop>

" Reload .vimrc.
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

nnoremap <space> :write<CR>
" Frequent typos.
command W write
command Q quit
command Wq write | quit
command WQ write | quit

" Restore the seek position from the last time we edited this file.
let g:lastplace_ignore = "gitcommit,gitrebase,svn"

" Enable the spell checker on text files.  Use 'zg' to add to the dictionary.
autocmd BufRead,BufNewFile *.txt,*.email set spell | syn off

autocmd BufRead,BufNewFile *.txt set wrap tw=80
autocmd BufRead,BufNewFile *.email set wrap tw=72

autocmd BufRead,BufNewFile *.gdb set sw=4 expandtab
autocmd FileType perl,python,sh setl sw=4 expandtab
autocmd FileType c call FreeBSD_Style()
autocmd BufRead,BufNewFile *.[ch] call FreeBSD_Style() | set filetype=c
autocmd BufRead,BufNewFile *.d set filetype=dtrace

" Wrap commit messages at 76 columns.
au BufNewFile svn-commit\.*tmp set wrap tw=76

" sh filetype detection doesn't seem to work if \".sh\" isn't used.
au BufRead * if getline(1) == "#!/bin/sh" | set filetype=sh | endif

iabbrev sbff Sponsored by:	The FreeBSD Foundation
iabbrev sob Signed-off-by: Mark Johnston <markj@FreeBSD.org>
iabbrev debugprint printf("%s:%d\n", __func__, __LINE__);

" XXX add command to remove trailing whitespace

" cscope stuff.
set cscopetag
" Suppress an error if .vimrc is sourced after the DB is added.
set nocscopeverbose
if $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif
set cscopeverbose

command -nargs=1 Ca cs find a <args>
nnoremap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>la :cs find a <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-@>a :scs find a <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>a :vert scs find a <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cc cs find c <args>
nnoremap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>lc :cs find c <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cd cs find d <args>
nnoremap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ld :cs find d <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>d :vert cs find d <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Ce cs find e <args>
nnoremap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>le :cs find e <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>e :vert cs find e <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cf cs find f <args>
nnoremap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-\>lf :cs find f <C-R>=tolower(expand("<cfile>"))<CR><CR>
nnoremap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-@><C-@>f :vert cs find f <C-R>=expand("<cfile>")<CR><CR>

command -nargs=1 Cg cs find g <args>
nnoremap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>lg :cs find g <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>g :vert cs find g <C-R>=expand("<cword>")<CR><CR>

command -nargs=1 Cs cs find s <args>
nnoremap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-\>ls :cs find s <C-R>=tolower(expand("<cword>"))<CR><CR>
nnoremap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-@><C-@>s :vert cs find s <C-R>=expand("<cword>")<CR><CR>

" Reset the cscope connection.
nnoremap \ :cs reset<CR>
