""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ~/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base
set nobackup                                        "No create backup file.
set noswapfile                                      "No create swap file.
set autoread                                        "Rereading Automatic When the file being edited is changed.
set hidden                                          "Buffer is to be opened in the editing.
set showcmd                                         "To view the command in the input to the status.
set mouse=a                                         "To enable the mouse operation.
set confirm                                         "To make sure when there are unsaved files.
set visualbell t_vb=                                "Disable all the beep.
set noerrorbells                                    "Not sound the beep at the time of display of error messages.
set clipboard=unnamed,autoselect                    "To insert the selected text in visual mode to the clipboard. & Share the clipboard.
set backspace=indent,eol,start                      "Backspace key so as to operate normally.
set history=100                                     "The number of command history
set completeopt=menuone,longest                     "Completion Style (* non preview)
set switchbuf=useopen                               "If already in the buffer, open that file.
set autowrite                                       "Auto save file If there is a change when file move or make command is executed.

" Key
"" Replace j,k to gj, gk
nnoremap j gj
nnoremap k gk

" Tab
set expandtab                                       "Convert tabs to spaces.
set shiftwidth=4                                    "Display width of the Tab character at the beginning of a line.
set tabstop=4                                       "Display width of the Tab character other than the beginning of the line.

" Search
set ignorecase                                      "Search not case sensitive.
set smartcase                                       "If the search string contains upper-case letters, to search by distinguishing.
set incsearch                                       "To enable incremental search.
set wrapscan                                        "Search to the end, go back to the beginning.
set hlsearch                                        "Search result hilight.
"To turn off the highlight in the Esc key * 2.
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

" Completion
set wildmenu wildmode=list:longest,full             "At the time of the command mode, to supplement the command with the Tab key.
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll           "Ignore Pattern when the complement.

" View
set title                                           "To display the name of the file being edited.
set number                                          "View number count.
set ruler                                           "Display ruler.
set cursorline                                      "Currently highlight the line.
set cursorcolumn                                    "Currently highlight the line (column).
set showmatch                                       "Input parentheses, to highlight the corresponding brackets.
set laststatus=2                                    "Display the status line in the second row from the end.

" Plugin see also: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

"" Appearance
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

"" Window
Plug 'simeji/winresizer'

"" File Operation
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'
Plug 'thinca/vim-unite-history'
Plug 'LeafCage/yankround.vim'

"" File Selector
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"" Text Edit
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'Yggdroot/indentLine'

"" Tag
Plug 'szw/vim-tags'
Plug 'majutsushi/tagbar'

"" Lint
Plug 'vim-syntastic/syntastic'

"" Python
Plug 'davidhalter/jedi-vim'
Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }

"" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

"" Frontend
Plug 'mattn/emmet-vim'
Plug 'othree/html5.vim'
Plug 'hokaccha/vim-html5validator'
Plug 'hail2u/vim-css3-syntax'
Plug 'jelera/vim-javascript-syntax'
Plug 'AtsushiM/sass-compile.vim'

"" Markdown
Plug 'jszakmeister/markdown2ctags'
Plug 'kannokanno/previm'
Plug 'wookayin/vim-typora'
Plug 'glidenote/memolist.vim'

"" HashiCorp
Plug 'fatih/vim-hclfmt'

"" Git
Plug 'lambdalisue/gina.vim'
Plug 'airblade/vim-gitgutter'

"" Database
Plug 'vim-scripts/dbext.vim'

"" OS Utility
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/vimshell', { 'tag': '3787e5' }

call plug#end()

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Plugin itchyny/lightline.vim 
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'gitbranch', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gina#component#repo#branch',
    \   'filename': 'LightlineFilename',
    \ },
\ }
function! LightlineFilename()
    let name = winwidth(0) > 105 ? expand('%:p') : expand('%:t') 
    return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==# 'unite' ? unite#get_status_string() :
        \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \ expand('%:t') !=# '' ? name : '[No Name]'
endfunction

" Plugin altercation/vim-colors-solarized
let g:solarized_termtrans=1                                                 "Terminal at the time of the transparent background, to enable transparent background of Solarized.

" Plugin vim-syntastic/syntastic
let g:syntastic_html_tidy_exec = '/usr/local/bin/tidy'                      "HTML5 syntastic check (required: brew install tidy-html5)

" Plugin kannokanno/previm 
let g:previm_open_cmd = 'open -a Safari'                                    "Open Safari when PrevimOpen

" Plugin Shougo/vimfiler
let g:vimfiler_as_default_explorer = 1                                      "Replace vim explorer to vimfiler
let g:vimfiler_enable_auto_cd = 1                                           "vimfiler change Vim current directory
let g:vimfiler_ignore_pattern = '^\%(.DS_Store\)$'                          "ignore pattern, default display dotfiles
nnoremap <silent> <Space>e :<C-u>VimFilerBufferDir<CR>
nnoremap <silent> <Space>E :<C-u>VimFilerBufferDir<Space>-explorer<Space>-direction=rightbelow<CR>
"" vimfiler my settings
autocmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
  "" Press esc twice to exit vimfiler
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

" Plugin majutsushi/tagbar
let g:tagbar_autofocus = 1                                                  "Focus when open tagbar (= 1)
let g:tagbar_left = 1                                                       "tagbar open left side
let g:tagbar_autoshowtag = 1                                                "Show tag auto
nnoremap <silent> <Space>t :<C-u>TagbarToggle<CR>
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : $HOME . '/.cache/dein/repos/github.com/jszakmeister/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }
"" tagbar my settings
autocmd FileType tagbar call s:tagbar_my_settings()
function! s:tagbar_my_settings()
  "" Press esc twice to exit tagbar
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

" Plugin junegunn/fzf.vim 
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'up': '~35%' }
nnoremap <silent> <Space>g :<C-u>FzfBLines<CR>
nnoremap <silent> <Space>gg :<C-u>cd %:p:h<CR> :<C-u>FzfAg<CR>
nnoremap <silent> <Space>c :<C-u>FzfBCommits<CR>
nnoremap <silent> <Space>h :<C-u>FzfHistory<CR>
nnoremap <C-T> :FZF<CR>

" Plugin davidhalter/jedi-vim -> see also: https://github.com/davidhalter/jedi-vim#settings 
let g:jedi#goto_command = "gd"                                              "Jump to definition 
let g:jedi#usages_command = "<leader>c"                                     "List callers
let g:jedi#documentation_command = "<leader>d"                              "Open document
let g:jedi#rename_command = "<leader>r"                                     "Rename all references of selection section

" Plugin lambdalisue/vim-pyenv > see also: https://github.com/lambdalisue/vim-pyenv#using-vim-pyenv-with-jedi-vim
if jedi#init_python()
  function! s:jedi_auto_force_py_version() abort
    let g:jedi#force_py_version = pyenv#python#get_internal_major_version()
  endfunction
  augroup vim-pyenv-custom-augroup
    autocmd! *
    autocmd User vim-pyenv-activate-post   call s:jedi_auto_force_py_version()
    autocmd User vim-pyenv-deactivate-post call s:jedi_auto_force_py_version()
  augroup END
endif

" Plugin fatih/vim-go -> see also: https://github.com/fatih/vim-go#example-mappings
let g:go_highlight_functions = 1                                            "Highlight functions
let g:go_highlight_methods = 1                                              "Highlight methods
let g:go_highlight_structs = 1                                              "Highlight structs
let g:go_highlight_operators = 1                                            "Highlight operators
let g:go_highlight_build_constraints = 1                                    "Highlight build constraints
let g:go_fmt_command = "goimports"                                          "Do goimports when saving.
autocmd FileType go :highlight goErr cterm=bold ctermfg=197                 "Highlight err
autocmd FileType go :match goErr /\<err\>/                                  "Highlight err
au FileType go nmap <Leader>c <Plug>(go-referrers)
au FileType go nmap <Leader>d <Plug>(go-doc)
au FileType go nmap <Leader>db <Plug>(go-doc-browser)
au FileType go nmap <Leader>r <Plug>(go-rename)

" Plugin scrooloose/syntastic
let g:syntastic_go_checkers = ['golint', 'gotype', 'govet', 'go']           "Go Checkers

" Plugin Shougo/neocomplete
let g:neocomplete#enable_at_startup = 1                                     "Enable at startup

" Plugin Shougo/neosnippet
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Plugin airblade/vim-gitgutter
nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

" Plugin glidenote/memolist.vim
let g:memolist_path = "$HOME/memo"
let g:memolist_memo_suffix = "md"
let g:memolist_template_dir_path = "~/.config/memo"

" Plugin LeafCage/yankround.vim
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history = 50
nnoremap <silent> <Space>r :<C-u>Unite<Space>yankround<CR>

" Plugin 'lambdalisue/gina.vim'
nnoremap <silent> ,gb :<C-u>Gina<Space>blame<CR>
nnoremap <silent> ,gl :<C-u>Gina<Space>log<CR>
"" gina my settings
autocmd FileType gina-blame call s:gina_my_settings()
autocmd FileType gina-log call s:gina_my_settings()
function! s:gina_my_settings()
  "" Press esc twice to exit unite
  nmap <silent><buffer> <ESC><ESC> :<C-u>bd<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>bd<CR>
endfunction

" Plugin Shougo/unite.vim
nnoremap <silent> <Space>o :<C-u>Unite<Space>outline<CR>
nnoremap <silent> <Space>T :<C-u>Unite<Space>tab:no-current<CR>
nnoremap <silent> ,h :<C-u>Unite<Space>menu:myshortcut<CR>
"" unite my settings
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  "" Press esc twice to exit unite
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction
"" Upper case and lower case are not distinguished
let g:unite_enable_ignore_case = 1  
let g:unite_enable_smart_case = 1
"" unite:menu
let g:unite_source_menu_menus = get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.myshortcut = {'description': 'my shortcut list'}
let g:unite_source_menu_menus.myshortcut.command_candidates = {
      \ '- [space] VimFilerBufferDir current      <Space>e   ': 'VimFilerBufferDir',
      \ '- [space] VimFilerBufferDir rightbelow   <Space>E   ': 'VimFilerBufferDir -explorer -direction=rightbelow',
      \ '- [space] Unite outline                  <Space>o   ': 'Unite outline',
      \ '- [space] Unite yankround                <Space>r   ': 'Unite yankround',
      \ '- [space] Unite tab:no-current           <Space>T   ': 'Unite tab:no-current',
      \ '- [space] Unite file_mru                 <Space>h   ': 'Unite file_mru',
      \ '- [space] TagbarToggle                   <Space>t   ': 'TagbarToggle',
      \ '- [space] FzfBLines                      <Space>g   ': 'FzfBLines',
      \ '- [space] FzfAg                          <Space>gg  ': 'exe "cd %:p:h | FzfAg"',
      \ '- [,] GitGutterToggle                    ,gg        ': 'GitGutterToggle',
      \ '- [,] GitGutterLineHighlightsToggle      ,gh        ': 'GitGutterLineHighlightsToggle',
      \ '- [python] jedi#goto_command             gd         ': '',
      \ '- [python] jedi#usages_command           <Leader>c  ': '',
      \ '- [python] jedi#documentation_command    <Leader>d  ': '',
      \ '- [python] jedi#rename_command           <Leader>r  ': '',
      \ '- [go] go#go-referrers                   <Leader>c  ': '',
      \ '- [go] go#go-doc                         <Leader>d  ': '',
      \ '- [go] go#go-doc-browser                 <Leader>db ': '',
      \ '- [go] go#go-doc-rename                  <Leader>r  ': '',
      \ }

" SuperTab like snippets behavior.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Command
"" json format 
command! JsonFormat :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)).encode(\"utf-8\"), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :set ft=javascript
  \ | :1
"" Terminal
nnoremap <C-c><C-c> :terminal<CR>
"" tig
nnoremap <silent> ,gs :!tig status<CR>:redraw!<CR>

" Load etc files
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" Path
set runtimepath+=~/.vim/
runtime! userautoload/*.vim
