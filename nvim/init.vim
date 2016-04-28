call plug#begin('~/.vimplugged')

Plug 'mileszs/ack.vim' " {{{
nnoremap <Leader>q :cclose<CR>
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>p :cprev<CR>
nnoremap <Leader>o :copen<CR>
nnoremap <Leader>g :Ack<CR>
command -nargs=* AckWord :Ack <cword> <args>
" }}}
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar' " {{{
nmap <Leader>t :TagbarToggle<cr>
let g:tagbar_left = 1
let g:tagbar_autoclose = 1
" }}}
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/buftabs' " {{{
set laststatus=2
"let g:buftabs_in_statusline = 0
let g:buftabs_only_basename = 1
let g:buftabs_separator = ":"
let g:buftabs_marker_start = "["
let g:buftabs_marker_end = "]"
let g:buftabs_marker_modified = ""
"set statusline=%{buftabs#statusline()}\ %=%h%m%r\ %-14.(%l,%c%V%)\ %P
" }}}
Plug 'vim-scripts/unite.vim'
Plug 'gregsexton/VimCalc' " {{{
au FileType vimcalc setlocal nolist
" }}}
Plug 'kien/ctrlp.vim' " {{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
      \ 'file': '\v\.(exe|so|dll)$',
      \ }
" }}}
Plug 'troydm/easybuffer.vim' " {{{
nmap <Leader>b :EasyBuffer<CR>
" }}}
Plug 'AndrewRadev/linediff.vim'
Plug 'vim-scripts/Align'
Plug 'Lokaltog/vim-easymotion'
Plug 'embear/vim-localvimrc' " {{{
let g:localvimrc_sandbox = 0
let g:localvimrc_ask = 0
let g:localvimrc_name = [ ".lvimrc", ".git/localvimrc" ]
" }}}
Plug 'tyru/restart.vim' " {{{
let g:restart_sessionoptions = 'buffers,curdir,folds,help,options'
let g:restart_command = 'PureRestart'
command! -nargs=* Restart PureRestart --cmd "let g:vim_server_loaded = 1" <args>
set guiheadroom=0
" }}}
Plug 'igsha/vim-server' " {{{
let g:vim_server_ignore_servernames = ["VIM", "VS_NET"]
" }}}
Plug 'duellj/DirDiff.vim'
Plug 'bling/vim-airline' " {{{
let g:airline_section_z = '%3p%% (0x%2B) %#__accent_bold#%4l%#__restore__#:%3c'
"}}}
Plug 'AndrewRadev/simple_bookmarks.vim'
Plug 'fidian/hexmode'
Plug 'Shougo/vimshell.vim'
Plug 'PProvost/vim-ps1'
Plug 'chrisbra/csv.vim'
Plug 'palopezv/vim-nroff'
Plug 'awagner-mainz/vim-homekey'
Plug 'bruno-/vim-man'
Plug 'w0ng/vim-hybrid' " {{{
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1
"}}}


call plug#end()

scriptencoding utf-8

if has("win32") || has("win64") " {{{ TMPDIR
  let $TMPDIR = $TEMP
  au GUIEnter * simalt ~x
else
  if empty($TMPDIR)
    let $TMPDIR = "/tmp"
  endif
endif
set directory=$TMPDIR
set backupdir=$TMPDIR
" }}}

let $VIMBUNDLE = expand("~/.vimbundle")
runtime neobundlelist.vim
let g:netrw_home = $VIMBUNDLE

set number
set softtabstop=4
set shiftwidth=4
set tabstop=4
set expandtab
set cindent
set smarttab
set ruler
set autoindent
set smartindent
set backspace=2
set modeline
set mouse=a

let g:netrw_list_hide = '^\.'
let g:netrw_liststyle = 1

if has("gui_running") " {{{ Font
  if has("unix")
    set guifont=Terminus\ 12
  else
    set guifont=Terminus:h12:cRUSSIAN
  endif
  set guioptions=aPc
endif " }}}

set list
set listchars=tab:»»,trail:·,nbsp:º

set hlsearch
set incsearch
set ignorecase
set smartcase
set vb t_vb= novb
syntax on
set hidden
set autochdir
set textwidth=130

" {{{ Key mapping
map k <c-y>
map j <c-e>
map h zh
map l zl
map <c-tab> :bn<CR>
map <c-s-tab> :bp<CR>
map gt :bn<CR>
map gT :bp<CR>
map <F3> :noh<CR>
map <C-Left> <C-W><Left>
map <C-Right> <C-W><Right>
map <C-Up> <C-W><Up>
map <C-Down> <C-W><Down>
" }}}

set wildmode=longest,list,full
set wildmenu
set fileencodings=utf8,cp1251,koi8-r,cp866

" omni completion
set completeopt=menu

set background=dark
colorscheme hybrid

set fileformats+=dos " http://stackoverflow.com/questions/14171254/why-would-vim-add-a-new-line-at-the-end-of-a-file

checktime

" vim: fdm=marker: