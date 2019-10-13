" neovim config

" Plugins - require vim-plug
call plug#begin('~/.nvim/plug')
	Plug 'morhetz/gruvbox'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

filetype plugin indent on
syntax on

" Theme
set background=dark
colorscheme gruvbox " gruvbox colors
hi Normal guibg=NONE ctermbg=none
hi Comment gui=italic cterm=italic

set number
set numberwidth=10
set cursorline
" set linebreak
" set textwidth=100
" set showbreak=...

set visualbell

set ruler

set hlsearch
set smartcase
set incsearch

set autoindent
set tabstop=4
set shiftwidth=4
set noexpandtab

set nobackup
set noswapfile

set undolevels=1000
