" === Plugins === "
call plug#begin()
" Base16 Theme
Plug 'chriskempson/base16-vim'
call plug#end()

" === Theme === "
" Set colour scheme
colorscheme base16-horizon-dark

" === Search === "
" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" === Misc === "
" Automatically re-read file if a change was detected outside of vim
set autoread

" Enable line numbers
" set number
