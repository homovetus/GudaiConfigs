set autoread
set clipboard=unnamed
set nowrap
set path+=**
set relativenumber
set wildmenu

set mouse=a
set termguicolors

set hlsearch
set ignorecase
set incsearch
set smartcase

filetype plugin indent on

syntax enable

map <space> <leader>

nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <leader>t :Lexplore<CR>

let g:netrw_banner=0		" hide banner
let g:netrw_liststyle=3		" tree view

