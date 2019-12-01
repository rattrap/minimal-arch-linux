call plug#begin()
Plug 'ayu-theme/ayu-vim'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" === Theme and Fonts === "
" let ayucolor="light"  " for light version of theme
" let ayucolor="dark"   " for dark version of theme
set termguicolors     " enable true colors support
let ayucolor="mirage" " for mirage version of theme
colorscheme ayu
let g:airline_theme='ayu-mirage'

let g:airline_powerline_fonts = 1
set guifont=FiraCode 14