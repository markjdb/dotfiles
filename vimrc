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
set history=1000
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

" Enable the spell checker on text files.  Use 'zg' to add to the dictionary.
autocmd BufRead,BufNewFile *.txt,*.email set spell | syn off

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
inoremap <c-u> <esc>lviwUea

" Insert mode sequence to enter normal mode.
inoremap jk <esc>
inoremap <esc> <nop>

inoremap ( ()<esc>i
inoremap [ []<esc>i
inoremap { {}<esc>i

" Reload .vimrc.
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

nnoremap <space> :write<CR>

" Restore the seek position from the last time we edited this file.
let g:lastplace_ignore = "gitcommit,gitrebase,svn"

au BufRead,BufNewFile *.txt set wrap tw=80
au BufRead,BufNewFile *.email set wrap tw=72

au BufRead,BufNewFile *.gdb set sw=4 expandtab
autocmd FileType perl,python,sh setl sw=4 expandtab
autocmd FileType c call FreeBSD_Style()
autocmd BufRead,BufNewFile *.[ch] call FreeBSD_Style() | set filetype=c
autocmd BufRead,BufNewFile *.d set filetype=dtrace

" Wrap commit messages at 76 columns.
au BufNewFile svn-commit\.tmp set wrap tw=76

" sh filetype detection doesn't seem to work if \".sh\" isn't used.
au BufRead * if getline(1) == "#!/bin/sh" | set filetype=sh | endif

" Reset the cscope connection.
nnoremap \ :cs reset<CR>
