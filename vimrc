"""""""""""""""""""""""""""" Plugin stuff

" Specify a directory for plugins
" " - For Neovim: stdpath('data') . '/plugged'
" " - Avoid using standard Vim directory names like 'plugin'
call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'Asheq/close-buffers.vim'
Plug 'preservim/nerdtree'
"Plug 'github/copilot.vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
if has('nvim')
	Plug 'neovim/nvim-lspconfig'

	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
        set completeopt=menu,menuone,noselect
endif

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""""""" Settings

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
if !has('nvim')
	set viminfo='10,\"100,:20,%,n~/.viminfo
endif

" Disable mouse support, it screws up highlighting when running vim in a split
" tmux pane.
set mouse=

" Colours.
set t_Co=256
set background=dark
colorscheme torte
syntax enable

""""""""""""""""""""""""""""""""""" COC plugin stuff

" Is the previous character a whitespace character?
"function! CheckBackspace() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
"inoremap <silent><expr> <Tab>
"      \ pumvisible() ? "\<C-n>" : "\<Tab>"

" Use <CR> to select a menu entry.
"inoremap <expr> <tab> coc#pum#visible() ? coc#pum#confirm() : "\<tab>"

"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gD <Plug>(coc-declaration)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"nnoremap <leader>d :CocList diagnostics<CR>

""""""""""""""""""""""""""""""""""""" Mappings

" Jump to the column of a mark when I hit '<mark>.
nnoremap ' `
nnoremap ` '

" Treat wrapped lines as separate lines when navigating.
nnoremap k gk
nnoremap j gj

" Convert the previous word to upper case.
inoremap <c-u> <esc>hviwUea

" Insert mode sequence to enter normal mode.
inoremap jk <esc>
inoremap <esc> <nop>

" Remove trailing whitespace in the current buffer.
nnoremap <leader>rmws :%s/\s\+$//<CR>

" Reload .vimrc.
nnoremap <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>

" Enter and exit paste mode more easily.
nnoremap <leader>sp :set paste<CR>i
nnoremap <leader>snp :set nopaste<CR>

nnoremap <space> :write<CR>
" Frequent typos.
command W write
command Q quit
command Wq write | quit
command WQ write | quit

" Start FreeBSD development.
nnoremap <leader>cdbsd :cd ~/src/freebsd<CR>:call CscopeMgrLoadDirDB("/usr/home/markj/src/freebsd/sys")<CR>:NERDTree<CR>

" Open help for word under the cursor.
nnoremap <leader>h :execute("help " . expand("<cword>"))<CR>

" Make the "insert" key work in gvim.
if has("gui_running")
    cnoremap <C-S-Insert> <C-r>*
    inoremap <C-S-Insert> <C-r>*
    nnoremap <C-S-Insert> "*p
endif

"""""""""""""""""""""""""""""""""""" Filetype stuff

" Restore the seek position from the last time we edited this file.
let g:lastplace_ignore = "gitcommit,gitrebase,svn"

filetype on
filetype plugin on
filetype indent on

" Enable the spell checker on text files.  Use 'zg' to add to the dictionary.
autocmd BufRead,BufNewFile *.txt,*.email set spell | syn off
autocmd BufRead,BufNewFile *.txt set wrap tw=80
autocmd BufRead,BufNewFile *.email set wrap tw=72
autocmd BufRead,BufNewFile *.gdb set sw=4 expandtab
autocmd FileType perl,python,sh,lua setl sw=4 expandtab
" sh filetype detection doesn't seem to work if \".sh\" isn't used.
au BufRead * if getline(1) == "#!/bin/sh" | set filetype=sh | endif
autocmd FileType c call FreeBSD_Style()
autocmd BufRead,BufNewFile *.[ch] call FreeBSD_Style() | set filetype=c
autocmd BufRead,BufNewFile *.d set filetype=dtrace
" Wrap commit messages at 76 columns.
au BufNewFile svn-commit\.*tmp set wrap tw=76

iabbrev sbff Sponsored by:	The FreeBSD Foundation
iabbrev sbklara Sponsored by:	Klara, Inc.
iabbrev sob Signed-off-by: Mark Johnston <markj@FreeBSD.org>
iabbrev markjcr Copyright (c) 2022 Mark Johnston <markj@FreeBSD.org>
iabbrev debugprint printf("%s:%d\n", __func__, __LINE__);
iabbrev XXX XXX-MJ
iabbrev nfc No functional change intended.
