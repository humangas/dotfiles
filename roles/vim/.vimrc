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

" Key
"Replace j,k to gj, gk
nnoremap j gj
nnoremap k gk
nnoremap <C-c><C-c> :terminal<CR>

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

" Plugin Shougo/dein.vim
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Add or remove your plugins here:
call dein#add('Shougo/neosnippet.vim')                                      "Adds snippet support to Vim.
call dein#add('Shougo/neosnippet-snippets')                                 "The standard snippets repository for 'neosnippet.vim'.
call dein#add('Shougo/neocomplete.vim')                                     "Next generation completion framework after neocomplcache
call dein#add('Shougo/vimproc.vim', {'build': 'make'})                      "Great asynchronous execution library for Vim.
call dein#add('Shougo/vimfiler')                                            "Powerful file explorer implemented by Vim script
call dein#add('Shougo/unite.vim')                                           "Search and display information from arbitrary sources like files, buffers, etc.
call dein#add('Shougo/neomru.vim')                                          "MRU plugin includes unite.vim MRU sources
call dein#add('Shougo/unite-outline')                                       "Vim's buffer with the outline view.
call dein#add('thinca/vim-unite-history')                                   "A source of unite.vim for history of command/search.
call dein#add('altercation/vim-colors-solarized')                           "Colorscheme: solarized
call dein#add('itchyny/lightline.vim')                                      "A light and configurable statusline/tabline for Vim
call dein#add('junegunn/fzf', {'build': './install --all', 'merged': 0})    "General-purpose command-line fuzzy finder.
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})                       "Vim plugin fzf
call dein#add('kannokanno/previm')                                          "Realtime preview by Vim. (Markdown, reStructuredText, textile)
call dein#add('davidhalter/jedi-vim', {'on_source': ['vim-pyenv']})         "VIM binding to the autocompletion library Jedi(for Python).
call dein#add('lambdalisue/vim-pyenv', {'on_ft': ['python']})               "Allows you to activate and deactivate the pyenv Python correctly in a live Vim session.
call dein#add('fatih/vim-go')                                               "Go development plugin for Vim
call dein#add('szw/vim-tags')                                               "The Ctags generator for Vim
call dein#add('majutsushi/tagbar')                                          "A class outline viewer for Vim
call dein#add('ConradIrwin/vim-bracketed-paste')                            "Enables transparent pasting into vim. (i.e. no more :set paste!)
call dein#add('Yggdroot/indentLine')                                        "Displaying thin vertical lines at each indentation level for code indented with spaces.
call dein#add('vim-syntastic/syntastic')                                    "Syntax checking plugin for Vim. ('pip install flake8', brew install tidy-html5 is required separately.)
call dein#add('vim-scripts/dbext.vim')                                      "functions/mappings/commands to enable Vim to access several databases.
call dein#add('airblade/vim-gitgutter')                                     "Shows a git diff in the gutter (sign column) and stages/undoes hunks.
call dein#add('mattn/emmet-vim')                                            "emmet for vim: http://emmet.io/ http://mattn.github.io/emmet-vim
call dein#add('tpope/vim-surround')                                         "surround.vim: quoting/parenthesizing made simple
call dein#add('tomtom/tcomment_vim')                                        "An extensible & universal comment vim-plugin that also handles embedded filetypes
call dein#add('othree/html5.vim')                                           "HTML5 omnicomplete and syntax
call dein#add('hokaccha/vim-html5validator')                                "html5 validator vim plugin using validator.nu API.
call dein#add('hail2u/vim-css3-syntax')                                     "CSS3 syntax (and syntax defined in some foreign specifications) support for Vim's built-in syntax/css.vim
call dein#add('jelera/vim-javascript-syntax')                               "Enhanced javascript syntax file for Vim
call dein#add('AtsushiM/sass-compile.vim')                                  "Add Sass compile & utility commands.
call dein#add('glidenote/memolist.vim')                                     "simple memo plugin for Vim.
call dein#add('wookayin/vim-typora')                                        "Open Typora from vim.
call dein#add('fatih/vim-hclfmt')                                           "Vim plugin for hclfmt, If hclfmt is not already installed: go get github.com/fatih/hclfmt
call dein#add('LeafCage/yankround.vim')                                     "logging registers and reusing them.
call dein#add('jszakmeister/markdown2ctags')                                "Generate ctags-compatible tags files for Markdown documents.

" You can specify revision/branch/tag.
call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Plugin itchyny/lightline.vim 
let g:lightline = {}
let g:lightline.colorscheme = 'solarized'                                   "Use ColorScheme: Solarized

" Plugin altercation/vim-colors-solarized
let g:solarized_termtrans=1                                                 "Terminal at the time of the transparent background, to enable transparent background of Solarized.

" Plugin vim-syntastic/syntastic
let g:syntastic_html_tidy_exec = '/usr/local/bin/tidy'                      "HTML5 syntastic check (required: brew install tidy-html5)

" Plugin kannokanno/previm 
let g:previm_open_cmd = 'open -a Safari'                                    "Open Safari when PrevimOpen

" Plugin Shougo/vimfiler
let g:vimfiler_as_default_explorer = 1                                      "Replace vim explorer to vimfiler
let g:vimfiler_enable_auto_cd = 1                                           "vimfiler change Vim current directory
nnoremap <silent> <Space>e :<C-u>VimFilerBufferDir<CR>
nnoremap <silent> <Space>E :<C-u>VimFilerBufferDir<Space>-explorer<Space>-direction=rightbelow<CR>

" Plugin majutsushi/tagbar
let g:tagbar_autofocus = 0                                                  "Focus when open tagbar (= 1)
let g:tagbar_left = 1                                                       "tagbar open left side
let g:tagbar_autoshowtag = 1                                                "Show tag auto
" autocmd FileType python,go,vim,zsh nested :TagbarOpen
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

" Plugin junegunn/fzf.vim 
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'down': '~30%' }
nnoremap <silent> fff :<C-u>FzfBLines<CR>
nnoremap <silent> ffg :<C-u>cd %:p:h<CR> :<C-u>FzfAg<CR>
nnoremap <silent> ffc :<C-u>cd %:p:h<CR> :<C-u>FzfFiles<CR>
nnoremap <silent> ffs :<C-u>FzfFiles<Space>~/src<CR>

" Plugin davidhalter/jedi-vim -> see also: https://github.com/davidhalter/jedi-vim#settings 
let g:jedi#goto_command = "gd"                                              "Jump to definition 
let g:jedi#usages_command = "<leader>c"                                     "List callers
let g:jedi#documentation_command = "<leader>d"                              "Open document
let g:jedi#rename_command = "<leader>r"                                     "Rename all references of selection section

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
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Plugin airblade/vim-gitgutter
nnoremap <silent> ,gg :<C-u>GitGutterToggle<CR>
nnoremap <silent> ,gh :<C-u>GitGutterLineHighlightsToggle<CR>

" Plugin glidenote/memolist.vim
let g:memolist_path = "$HOME/memo"
let g:memolist_memo_suffix = "md"

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

" Plugin Shougo/unite.vim
nnoremap <silent> <Space>o :<C-u>Unite<Space>outline<CR>
nnoremap <silent> ffl :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> ffb :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> fbb :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> fft :<C-u>Unite<Space>tab:no-current<CR>
nnoremap <silent> ffh :<C-u>Unite<Space>file_mru<CR>
nnoremap ffx :<C-u>cd %:p:h<CR> :<C-u>Unite<Space>output/shellcmd:
nnoremap <silent> fxx :<C-u>Unite<Space>output/shellcmd:<Up><CR>
nnoremap <silent> ffy :<C-u>Unite<Space>history/command<CR>
nnoremap <silent> ,m :<C-u>Unite<Space>menu:mycmd<CR>
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
let g:unite_source_menu_menus.mycmd = {'description': 'my command list'}
let g:unite_source_menu_menus.mycmd.command_candidates = {
      \ '- Unite mapping source                          ': 'Unite mapping source',
      \ '- VimFilerBufferDir current          <Space>e   ': 'VimFilerBufferDir',
      \ '- VimFilerBufferDir rightbelow       <Space>E   ': 'VimFilerBufferDir -explorer -direction=rightbelow',
      \ '- Unite outline                      <Space>o   ': 'Unite outline',
      \ '- Unite yankround                    <Space>r   ': 'Unite yankround',
      \ '- Unite buffer                       ffl        ': 'Unite buffer',
      \ '- Unite bookmark                     ffb        ': 'Unite bookmark',
      \ '- UniteBookmarkAdd                   fbb        ': 'UniteBookmarkAdd',
      \ '- Unite tab:no-current               fft        ': 'Unite tab:no-current',
      \ '- Unite file_mru                     ffh        ': 'Unite file_mru',
      \ '- Unite output/shellcmd:             ffx        ': 'exe "cd %:p:h | Unite output/shellcmd"',
      \ '- Unite output/shellcmd:<Up>         fxx        ': 'Unite output/shellcmd',
      \ '- Unite history/command              ffy        ': 'Unite history/command',
      \ '- TagbarToggle                       <Space>t   ': 'TagbarToggle',
      \ '- FzfBLines                          fff        ': 'FzfBLines',
      \ '- FzfAg                              ffg        ': 'exe "cd %:p:h | FzfAg"',
      \ '- FzfFiles                           ffc        ': 'exe "cd %:p:h | FzfFiles"',
      \ '- FzfFiles ~/src                     ffs        ': 'exe "FzfFiles ~/src"',
      \ '- GitGutterToggle                    ,gg        ': 'GitGutterToggle',
      \ '- GitGutterLineHighlightsToggle      ,gh        ': 'GitGutterLineHighlightsToggle',
      \ '- [help] jedi#goto_command           gd         ': '',
      \ '- [help] jedi#usages_command         <Leader>c  ': '',
      \ '- [help] jedi#documentation_command  <Leader>d  ': '',
      \ '- [help] jedi#rename_command         <Leader>r  ': '',
      \ '- [help] go#go-referrers             <Leader>c  ': '',
      \ '- [help] go#go-doc                   <Leader>d  ': '',
      \ '- [help] go#go-doc-browser           <Leader>db ': '',
      \ '- [help] go#go-doc-rename            <Leader>r  ': '',
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

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

set runtimepath+=~/.vim/
runtime! userautoload/*.vim
