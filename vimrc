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
if version >= 700
  set cursorline	" Draw a horizontal line under the line being edited.
endif

set guifont=terminus\ 9
set history=1000
set wildmenu		" Create a nice menu when auto-completing file names.

" Keep track of where my cursor was last positioned when I exit.
set viminfo='10,\"100,:20,%,n~/.viminfo

colorscheme torte

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

" Use <CR> to save a file, squawk at :w.
nmap <CR> :write<CR>
cabbrev w nope

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

autocmd FileType perl,python,sh setl sw=4 expandtab

if $USER == 'mjohnston'
" SV style calls for indentation by 4 spaces.
autocmd FileType cpp setl sw=4 expandtab
else
" In C++ I personally prefer two spaces.
autocmd FileType cpp setl sw=2 expandtab
" FreeBSD style 4 life.
autocmd FileType c call FreeBSD_Style()
endif

" Use the FreeBSD style plugin with FreeBSD code.
autocmd Bufread,BufNewFile /vobs/fw-bsd/*.[ch],~/src/freebsd/*.[ch] call FreeBSD_Style() | set filetype=c

" Wrap commit messages at 76 columns.
au BufNewFile svn-commit\.tmp set wrap tw=76

" sh filetype detection doesn't seem to work if \".sh\" isn't used.
au BufRead * if getline(1) == "#!/bin/sh" | set filetype=sh
