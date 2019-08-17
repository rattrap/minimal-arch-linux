call plug#begin()
" Theme
Plug 'chriskempson/base16-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/denite.nvim'

" Golang linter
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Better syntax highlighting
Plug 'vim-scripts/vim-polyglot'

" Tree explorer
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Git plugins
Plug 'vim-scripts/vim-gitgutter'

" Status/tabline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Set colour scheme
colorscheme base16-material-darker

let g:mapleader=','
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Open file commands
call denite#custom#map('insert,normal', "<C-t>", '<denite:do_action:tabopen>')
call denite#custom#map('insert,normal', "<C-v>", '<denite:do_action:vsplit>')
call denite#custom#map('insert,normal', "<C-h>", '<denite:do_action:split>')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ:',
\ 'statusline': 0,
\ 'highlight_matched_char': 'WildMenu',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'StatusLine',
\ 'highlight_prompt': 'StatusLine',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

" === Coc.nvim === "
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif


" === NERDTree === "
" Show hidden files/directories
let g:NERDTreeShowHidden = 1

" Remove bookmarks and help text from NERDTree
let g:NERDTreeMinimalUI = 1

" Custom icons for expandable/expanded directories
let g:NERDTreeDirArrowExpandable = '⬏'
let g:NERDTreeDirArrowCollapsible = '⬎'

" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']

" === Vim airline ==== "
" Enable extensions
let g:airline_extensions = ['branch', 'hunks', 'coc']

" Update section z to just have line number
let g:airline_section_z = airline#section#create(['linenr'])

" Do not draw separators for empty sections (only for the active window) >
let g:airline_skip_empty_sections = 1

" Smartly uniquify buffers names with similar filename, suppressing common parts of paths.
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Custom setup that removes filetype/whitespace from default vim airline bar
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'z', 'warning', 'error']]

let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'

let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

" Configure error/warning section to use coc.nvim
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'

" Hide the Nerdtree status line to avoid clutter
let g:NERDTreeStatusline = ''

" Disable vim-airline in preview mode
let g:airline_exclude_preview = 1

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Enable caching of syntax highlighting groups
let g:airline_highlighting_cache = 1

" Define custom airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '❮'
let g:airline_right_sep = '❯'

" Don't show git changes to current file in airline
let g:airline#extensions#hunks#enabled=0

" === vim-jsx === "
" Highlight jsx syntax even in non .jsx files
let g:jsx_ext_required = 0


" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
endfunction



" === Nerdtree shorcuts === "
"  <leader>n - Toggle NERDTree on/off
"  <leader>f - Opens current file location in NERDTree
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

"   <Space> - PageDown
"   -       - PageUp
noremap <Space> <PageDown>
noremap - <PageUp>

" === coc.nvim === "
nmap <silent> <leader>dd <Plug>(coc-definition)
nmap <silent> <leader>dr <Plug>(coc-references)
nmap <silent> <leader>dj <Plug>(coc-implementation)<Paste>



" === Search === "
" ignore case when searching
set ignorecase

" if the search string has an upper case letter in it, the search will be case sensitive
set smartcase

" Automatically re-read file if a change was detected outside of vim
set autoread

" Enable line numbers
" set number
