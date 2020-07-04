" ~/.vimrc

" Notes 
" - origin "https//github.com/jack-0/dotfiles"
" - install vundle (visit "github.com/VundleVim/Vundle.vim") 
" - all settings are best placed after the vundle section
" - Latex plugin requires tex-live/latex system packages
" 
" - ensure a directory is created for backups
"     $ mkdir ~/.vim/tmp
" - remember to clean up ~/.vim/tmp often


" Vundle (Plugin manager)-----------------------------------------------------
set nocompatible              " required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim "include Vundle and initialize
call vundle#begin()

Plugin 'VundleVim/Vundle.vim' " required 
Plugin 'ap/vim-css-color'     " highlights hex and rgb color codes 
"Plugin 'jiangmiao/auto-pairs' " auto completes parentheses 
"Plugin 'vim-latex/vim-latex'  " LaTeX-suite Requires tex-live to be installed
Plugin 'scrooloose/nerdtree'  " Nerd Tree
"Plugin 'doronbehar/vim-ncurses-syntax' " Ncurses syntax highlights
Plugin 'octol/vim-cpp-enhanced-highlight' " cpp and std_lib syntax highlights
Plugin 'Valloric/YouCompleteMe' " YCM code autocomplete
"Plugin 'altercation/vim-colors-solarized' " Solarised Theme

call vundle#end()            " required
filetype plugin indent on    " required
" End Vundle------------------------------------------------------------------


" General---------------------------------------------------------------------

" code settings
syntax on
set number
set showmatch "show matching brace
set background=dark

" space and tab settings (i.e. indent)
set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=2
set tabstop=4

"fold code <z> + <a>
"set foldmethod=indent
"set foldnestmax=10
"set nofoldenable
"set foldlevel=2

" Ensure a file is opened at last known place
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" End General-----------------------------------------------------------------


" Bindings--------------------------------------------------------------------
map<F6> :setlocal spell! spelllang=en_gb<CR>
map<C-n> :NERDTreeToggle<CR>
" End Bindings----------------------------------------------------------------

" Pyhton Settings-------------------------------------------------------------
autocmd FileType python setlocal ts=4 sw=4 expandtab
autocmd FileType python map <F5> :! clear & python % <CR>
" End Python Settings---------------------------------------------------------
