""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ~/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Base
set encoding=utf8                                   "Encoding
set fileencoding=utf-8                              "File Encoding
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
set ambiwidth=double                                "Display double-byte characters normally

" Key
"" Replace j,k to gj, gk
nnoremap j gj
nnoremap k gk

" Tab
set expandtab                                       "Convert tabs to spaces.
set shiftwidth=4                                    "Display width of the Tab character at the beginning of a line.
set tabstop=4                                       "Display width of the Tab character other than the beginning of the line.
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.css  setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js   setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vue  setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

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

" Exchange tab, space
autocmd BufEnter *.txt,*.py  setlocal expandtab
autocmd FileType make  setlocal noexpandtab

" Leader
let mapleader = "\<Space>"
let maplocalleader = ','

" Plugin see also: https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

"" Appearance
Plug 'altercation/vim-colors-solarized'
Plug 'itchyny/lightline.vim'

"" Window
Plug 'simeji/winresizer'
Plug 'Valloric/ListToggle'

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
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
Plug 'mtscout6/syntastic-local-eslint.vim'

"" Python
Plug 'davidhalter/jedi-vim'
Plug 'lambdalisue/vim-pyenv', { 'for': 'python' }
"" vim-repl for python
Plug 'sillybun/vim-repl', { 'do': './install.sh' }
Plug 'sillybun/vim-async', { 'do': './install.sh' }
Plug 'sillybun/zytutil'

"" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

"" Vue.js
Plug 'posva/vim-vue'

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
"Plug 'rhysd/github-complete.vim'

"" Database
Plug 'vim-scripts/dbext.vim'

"" Utility
Plug 'tyru/open-browser.vim'
Plug 'haya14busa/vim-open-googletranslate'

"" Vim extension
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/vimshell', { 'tag': '3787e5' }

call plug#end()

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Plugin itchyny/lightline.vim 
" Plugin maximbaz/lightline-ale
let g:lightline = {
    \ 'colorscheme': 'solarized',
    \ 'active': {
    \   'left': [
    \       [ 'mode', 'paste' ],
    \       [ 'readonly', 'gitbranch', 'filename', 'modified' ],
    \   ],
    \   'right': [
    \       [ 'lineinfo' ],
    \       [ 'percent' ],
    \       [ 'fileformat', 'fileencoding', 'filetype' ],
    \       [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
    \   ],
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gina#component#repo#branch',
    \   'filename': 'LightlineFilename',
    \ },
    \ 'component_expand': {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
      \  'linter_checking': 'left',
      \  'linter_warnings': 'warning',
      \  'linter_errors': 'error',
      \  'linter_ok': 'left',
    \ },
\ }
function! LightlineFilename()
    let name = winwidth(0) > 105 ? expand('%:p') : expand('%:t') 
    return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &filetype ==# 'unite' ? unite#get_status_string() :
        \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
        \ expand('%:t') !=# '' ? name : '[No Name]'
endfunction
let g:lightline#ale#indicator_warnings = 'W:'                               "The indicator to use when there are warnings. Default is W:.
let g:lightline#ale#indicator_errors = 'E:'                                 "The indicator to use when there are errors. Default is E:.
let g:lightline#ale#indicator_ok = 'OK'                                     "The indicator to use when there are no warnings or errors. Default is OK.

" Plugin altercation/vim-colors-solarized
let g:solarized_termtrans=1                                                 "Terminal at the time of the transparent background, to enable transparent background of Solarized.

" Plugin w0rp/ale
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
let g:ale_set_loclist = 1                                                   "Location list: on
let g:ale_set_quickfix = 0                                                  "QuickFix: off
let g:ale_open_list = 0                                                     "Keep error/warning window open: off
let g:ale_keep_list_window_open = 0                                         "Keep the window when there are no more errors/warnings: off
let g:ale_sign_column_always = 1                                            "Keep symbol column open: on
let g:ale_lint_on_save = 1                                                  "Lint when file save: on
let g:ale_lint_on_text_changed = 0                                          "Lint when text change: off
let g:ale_lint_on_enter = 1                                                 "Lint when file open: on
let g:ale_fix_on_save = 1                                                   "Fixers when file save: on
let g:ale_echo_msg_error_str = 'Error'                                      "Message serverity Error string
let g:ale_echo_msg_warning_str = 'Warning'                                  "Message serverity Warning string
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'                    "Message format
" gometalinter: go get -u gopkg.in/alecthomas/gometalinter.v2
" flake8: pip install flake8
" yamllint: pip install yamllint
" eslint: npm install -g eslint
let g:ale_linters = {
    \ 'go': ['gometalinter'],
    \ 'python': ['flake8'],
    \ 'yaml': ['yamllint'],
    \ 'javascript': ['eslint'],
\ }
" autopep8: pip install autopep8
" isort: pip install isort
" prettier-eslint: yarn add --dev prettier-eslint-cli
let g:ale_fixers = {
    \ 'python': ['autopep8', 'isort'],
    \ 'javascript': ['prettier-eslint'],
\ }
"" gometalinter for Golang linter see also: https://github.com/alecthomas/gometalinter#installing
let g:ale_go_gometalinter_options = '--fast --enable=staticcheck --enable=gosimple --enable=unused'

" Plugin Valloric/ListToggle
let g:lt_location_list_toggle_map = '<Leader>l'                             "Toggle Location list window
let g:lt_quickfix_list_toggle_map = '<Leader>q'                             "Toggle QuickFix window
let g:lt_height = 10                                                        "Location list/QuickFix window height
"" list my settings
autocmd FileType qf call s:list_my_settings()
function! s:list_my_settings()
  "" Press esc twice to exit
  nmap <silent><buffer> <ESC><ESC> :<C-u>bd<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>bd<CR>
endfunction

" Plugin kannokanno/previm 
let g:previm_open_cmd = 'open -a Safari'                                    "Open Safari when PrevimOpen

" Plugin Shougo/vimfiler
let g:vimfiler_ignore_pattern = '^\%(.DS_Store\)$'                          "ignore pattern, default display dotfiles
call vimfiler#custom#profile('default', 'context', {
    \   'explorer': 1,
    \   'auto-cd': 1,
    \   'safe': 0
\ })
nnoremap <silent> <Leader>e :<C-u>VimFilerBufferDir<CR>
nnoremap <silent> <Leader>E :<C-u>VimFilerBufferDir<Space>-explorer<Space>-direction=rightbelow<CR>
"" vimfiler my settings
autocmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()
  "" Press esc twice to exit
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

" Plugin majutsushi/tagbar
let g:tagbar_autofocus = 1                                                  "Focus when open tagbar (= 1)
let g:tagbar_left = 1                                                       "tagbar open left side
let g:tagbar_autoshowtag = 1                                                "Show tag auto
nnoremap <silent> <Leader>t :<C-u>TagbarToggle<CR>
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : $HOME . '/.vim/plugged/markdown2ctags/markdown2ctags.py',
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
  "" Press esc twice to exit
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

" Plugin junegunn/fzf.vim 
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'up': '~35%' }
nnoremap <silent> <Leader>g :<C-u>FzfBLines<CR>
nnoremap <silent> <Leader>gg :<C-u>cd %:p:h<CR> :<C-u>FzfAg<CR>
nnoremap <silent> <Leader>h :<C-u>FzfHistory<CR>
nnoremap <C-T> :FZF<CR>

" Plugin davidhalter/jedi-vim -> see also: https://github.com/davidhalter/jedi-vim#settings 
let g:jedi#goto_command = "gd"                                              "Jump to definition 
let g:jedi#usages_command = "<LocalLeader>c"                                "List callers
let g:jedi#documentation_command = "<LocalLeader>d"                         "Open document
let g:jedi#rename_command = "<LocalLeader>rn"                               "Rename all references of selection section

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
let g:go_list_type = "quickfix"                                             "All quickfix window
autocmd FileType go :highlight goErr cterm=bold ctermfg=197                 "Highlight err
autocmd FileType go :match goErr /\<err\>/                                  "Highlight err
autocmd FileType go nmap <LocalLeader>c <Plug>(go-referrers)
autocmd FileType go nmap <LocalLeader>d <Plug>(go-doc)
autocmd FileType go nmap <LocalLeader>db <Plug>(go-doc-browser)
autocmd FileType go nmap <LocalLeader>rn <Plug>(go-rename)
autocmd FileType go nmap <LocalLeader>r <Plug>(go-run)
autocmd FileType go nmap <LocalLeader>t <Plug>(go-test)
"" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
autocmd FileType go nmap <LocalLeader>b :<C-u>call <SID>build_go_files()<CR>

" Plugin Shougo/neocomplete
let g:neocomplete#enable_at_startup = 1                                     "Enable at startup

" Plugin Shougo/neosnippet
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Plugin airblade/vim-gitgutter
nnoremap <silent> <LocalLeader>gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> <LocalLeader>gh :<C-u>GitGutterLineHighlightsToggle<CR>

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
nnoremap <silent> <Leader>r :<C-u>Unite<Space>yankround<CR>

" Plugin 'lambdalisue/gina.vim'
nnoremap <silent> <LocalLeader>gb :<C-u>Gina<Space>blame<CR>
"" gina my settings
autocmd FileType gina-blame call s:gina_my_settings()
autocmd FileType gina-log call s:gina_my_settings()
function! s:gina_my_settings()
  "" Press esc twice to exit
  nmap <silent><buffer> <ESC><ESC> :<C-u>bd<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>bd<CR>
endfunction

" Plugin Shougo/unite.vim
nnoremap <silent> <Leader>o :<C-u>Unite<Space>outline<CR>
nnoremap <silent> <Leader>T :<C-u>Unite<Space>tab:no-current<CR>
nnoremap <silent> <LocalLeader><LocalLeader>h :<C-u>Unite<Space>menu:myshortcut<CR>
"" unite my settings
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  "" Press esc twice to exit
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
      \ '- [Leader]                                                          <Space>                       ': '',
      \ '- [LocalLeader]                                                     ,                             ': '',
      \ '- [flie]          Next error/warning                                <C-j>                         ': '',
      \ '- [file]          Previous error/warning                            <C-k>                         ': '',
      \ '- [file]          Toggle Location list                              <Leader>l                     ': '',
      \ '- [file]          Toggle QuickFix list                              <Leader>q                     ': '',
      \ '- [file]          Open filer current window                         <Leader>e                     ': '',
      \ '- [file]          Open filer right window                           <Leader>E                     ': '',
      \ '- [unite]         Open tagbar left window                           <Leader>t                     ': '',
      \ '- [file]          Fzf current file                                  <Leader>g                     ': '',
      \ '- [file]          Fzf files under the current dirs                  <Leader>gg                    ': '',
      \ '- [file]          Fzf file history                                  <Leader>h                     ': '',
      \ '- [file]          Fzf filepath under the current dir                <C-T>                         ': '',
      \ '- [python]        Go to local/global Declaration                    gd                            ': '',
      \ '- [python]        Open referrers in QuickFix                        <LocalLeader>c                ': '',
      \ '- [python]        Open doc                                          <LocalLeader>d                ': '',
      \ '- [python]        Rename object                                     <LocalLeader>rn               ': '',
      \ '- [golang]        Go to local/global Declaration                    gd                            ': '',
      \ '- [golang]        Open referrers in QuickFix                        <LocalLeader>c                ': '',
      \ '- [golang]        Open doc                                          <LocalLeader>d                ': '',
      \ '- [golang]        Oepn doc in browser                               <LocalLeader>db               ': '',
      \ '- [golang]        Rename object                                     <LocalLeader>rn               ': '',
      \ '- [golang]        go run                                            <LocalLeader>r                ': '',
      \ '- [golang]        go test                                           <LocalLeader>t                ': '',
      \ '- [golang]        go build/test on file type                        <LocalLeader>b                ': '',
      \ '- [git]           Toggle git diff column                            <LocalLeader>gg               ': '',
      \ '- [git]           Toggle git diff line highlights                   <LocalLeader>gh               ': '',
      \ '- [unite]         Open yankround window                             <Leader>r                     ': '',
      \ '- [git]           Open git blame                                    <LocalLeader>gb               ': '',
      \ '- [git]           Open git log use tig                              <LocalLeader>gl               ': '',
      \ '- [git]           Open git log of the current file use tig          <LocalLeader>gll              ': '',
      \ '- [unite]         Open outline list                                 <Leader>o                     ': '',
      \ '- [unite]         Open tab list                                     <Leader>T                     ': '',
      \ '- [unite]         Open myshortcut list                              <LocalLeader><LocalLeader>h   ': '',
      \ '- [command]       Open Terminal                                     <LocalLeader><LocalLeader>t   ': '',
      \ '- [git]           Open git status window use tig                    <LocalLeader>gs               ': '',
      \ '- [git]           Completion for GitHub(username,emoji,etc...)      <C-x><C-o>                    ': '',
      \ '- [html]          Expand html tag with Emmet                        <C-y>,                        ': '',
      \ '- [src]           Surroundings: parentheses,brackets,quotes,tags    Select + <S-s>                ': '',
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
nnoremap <LocalLeader><LocalLeader>t :terminal<CR>
"" tig
""" git status
nnoremap <silent> <LocalLeader>gs :!tig status<CR>:redraw!<CR>
""" git log
nnoremap <silent> <LocalLeader>gl :!tig<CR>:redraw!<CR>
""" git log of current file
nnoremap <silent> <LocalLeader>gll :!tig %<CR>:redraw!<CR>

" Load etc files
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" Path
set runtimepath+=~/.vim/
runtime! userautoload/*.vim
