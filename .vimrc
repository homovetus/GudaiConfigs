set autoread
set nowrap
set relativenumber
set clipboard=unnamedplus

set termguicolors
set t_Co=256

set hlsearch
set ignorecase
set incsearch
set smartcase

filetype plugin indent on

syntax enable

if has('win32')
    command! PS terminal ++close ++type=conpty pwsh
    command! PSFull terminal ++close ++type=conpty ++curwin pwsh
else
    command! PS terminal ++close pwsh
    command! PSFull terminal ++close ++curwin pwsh
endif

map <space> <leader>
map <leader>h :noh<cr>

call plug#begin()
Plug 'bkad/CamelCaseMotion'
Plug 'cocopon/iceberg.vim'
Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vimpostor/vim-lumen'
call plug#end()

" CamelCaseMotion
let g:camelcasemotion_key = '<leader>'

" iceberg.vim
colorscheme iceberg

" vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap s <plug>(easymotion-overwin-f)
omap s <plug>(easymotion-s)
vmap s <plug>(easymotion-s)

" lightline
set laststatus=2
set noshowmode
let g:lightline = { 'colorscheme': 'iceberg' }

" fzf
nnoremap <c-p> :Files<cr>
if has('win32')
    let g:fzf_vim = {}
    let g:fzf_vim.preview_bash = 'C:\Program Files\Git\bin\bash.exe'
endif
