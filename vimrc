syn on
set ai
set si
set sw=8
set nobackup
set tabstop=8
set autowrite	"autosave if the buffer is changed
set hlsearch	"highlight search terms
set ruler
set nu          "line numbering
set lbr!	"wrap lines at word boundaries
set foldmethod=manual
if version >= 700
  set cursorline
endif
set guifont=terminus\ 9
set history=1000
"set wildmode=longest:full
set wildmenu

set viminfo='10,\"100,:20,%,n~/.viminfo

let w:buftabs_enabled = 0

colorscheme koehler

filetype plugin on

runtime macros/machit.vim

" Jump to the column of a mark when I hit '<mark>.
nnoremap ' `
nnoremap ` '

map :W :w<CR>
map :Q :q<CR>

" Treat wrapped lines as separate lines.
map k gk
map j gj

" Restore the seekpos from the last time we edited this file.
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

function! ResCur()
  if line("'\"") <= line("$")
    normal! g'"
    return 1
  endif
endfunction

"au VimEnter * NERDTree

" Never start with the cursor in the NERDTree buffer.
"autocmd VimEnter * wincmd l

"autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer.
"function! s:CloseIfOnlyNerdTreeLeft()
"  if exists("t:NERDTreeBufName")
"    if bufwinnr(t:NERDTreeBufName) != -1
"      if winnr("$") == 1
"        q
"      endif
"    endif
"  endif
"endfunction

au Bufread,BufNewFile *.go set filetype=go
au BufRead,BufNewFile *.txt set wrap tw=80
au BufRead,BufNewFile *.email set wrap tw=72

au FileType python,sh setl sw=4 expandtab
au FileType cpp setl sw=2 expandtab
au FileType perl setl sw=4 expandtab
au FileType c call FreeBSD_Style()

" Mark files that start with '#!' as executable
au BufWritePost * if getline(1) =~ "^#!" | silent !chmod u+x %

set rtp+=$GOROOT/misc/vim
filetype plugin indent on
