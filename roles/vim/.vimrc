"Setting/Basic
set encoding=utf8                                      ""Encoding
set fileencoding=utf-8                                 ""File Encoding
set showcmd                                            ""To view the command in the input to the status.
set noswapfile                                         ""No create swap file.
set nobackup                                           ""No create backup file.
set clipboard=unnamed,autoselect                       ""To insert the selected text in visual mode to the clipboard. & Share the clipboard.
set hidden                                             ""Buffer is to be opened in the editing.
set autoread                                           ""Rereading Automatic When the file being edited is changed.
set confirm                                            ""To make sure when there are unsaved files.
set visualbell t_vb=                                   ""Disable all the beep.
set noerrorbells                                       ""Not sound the beep at the time of display of error messages.
set switchbuf=useopen                                  ""If already in the buffer, open that file.
set autowrite                                          ""Auto save file If there is a change when file move or make command is executed.
set textwidth=0                                        ""Turn off automatic line breaks.
set history=100                                        ""The number of command history
set completeopt=menuone,noinsert                       ""Completion Style
set ambiwidth=double                                   ""Display double-byte characters normally
set wildignore=*.o,*.obj,*.pyc,*.so,*.dll,*.class,*~   ""Ignore Pattern when the complement, vimgrep.
""Don't perform a line feed when pressing the Enter key on the completion display.
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
augroup autochdir-settings
  autocmd!
  ""Automatically move to the directory of the file being edited
  autocmd BufEnter * silent! lcd %:p:h
augroup END


"Setting/Leader
let mapleader = "\<Space>"
let maplocalleader = ','


"Setting/Tab
set expandtab                                          ""Convert tabs to spaces.
set shiftwidth=2                                       ""Display width of the Tab character at the beginning of a line.
set tabstop=2                                          ""Display width of the Tab character other than the beginning of the line.


"Setting/View
set number                                             ""View number count.
set title                                              ""To display the name of the file being edited.
set ruler                                              ""Display ruler.
set cursorline                                         ""Currently highlight the line.
set showmatch                                          ""Input parentheses, to highlight the corresponding brackets.
set laststatus=2                                       ""Display the status line in the second row from the end. (for lightline.vim)
set signcolumn=yes                                     ""Display signcolumn always


"Setting/Search
set ignorecase                                         ""Search not case sensitive.
set smartcase                                          ""If the search string contains upper-case letters, to search by distinguishing.
set incsearch                                          ""To enable incremental search.
set wrapscan                                           ""Search to the end, go back to the beginning.
set hlsearch                                           ""Search result hilight.
""To turn off the highlight in the Esc key * 2.
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>


"Setting/Key
""Replace j,k to gj, gk
nnoremap j gj
nnoremap k gk
""jj insted of ESC
inoremap <silent> jj <ESC>
""Display current buffer path on the command line
cnoremap <c-x> <c-r>=expand('%:p')<cr>


"Setting/Plugin
call plug#begin('~/.vim/plugged')
""Color"
Plug 'arcticicestudio/nord-vim'
""Selector
Plug 'junegunn/fzf', { 'do': './install --all' }
Plug 'junegunn/fzf.vim'
""Window
Plug 'simeji/winresizer'
Plug 'itchyny/lightline.vim'
Plug 'lambdalisue/fern.vim'
""Edit
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'godlygeek/tabular'
""Git
Plug 'iberianpig/tig-explorer.vim'
Plug 'airblade/vim-gitgutter'
Plug 'itchyny/vim-gitbranch'
""Utility
Plug 'previm/previm'
Plug 'glidenote/memolist.vim'
Plug 'tyru/open-browser.vim'
""Development
"""brew install node && npm i -g yarn
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
call plug#end()


"Setting/Tool/junegunn/vim-plug
autocmd FileType vim-plug call s:vimplug_keymap()
function! s:vimplug_keymap()
  ""Press esc twice to close
  nmap <silent><buffer> <ESC><ESC> :<C-u>bd<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>bd<CR>
endfunction


"Setting/Tool/arcticicestudio/nord-vim
""Disable diff backgroud color
let g:nord_uniform_diff_background = 1
""Set bold vertical split line
let g:nord_bold_vertical_split_line = 1
""Set cursor line number backgroud
let g:nord_cursor_line_number_background = 1
""ref. https://github.com/arcticicestudio/nord-vim/issues/26
""ref. https://www.nordtheme.com/docs/ports/vim/customization
augroup colorscheme-nord-overrides
  autocmd!
  autocmd ColorScheme nord highlight Visual ctermfg=11
  autocmd ColorScheme nord highlight CursorLine ctermfg=14
augroup END
""Set colorscheme (NOTE: Set at the bottom of the color sheme)
colorscheme nord


"Setting/Tool/lambdalisue/fern.vim
let g:fern#default_hidden = 1
let g:fern#disable_default_mappings = 1
nnoremap <silent> <Leader>e :<C-u>Fern .<CR>
autocmd FileType fern call s:fern_keymap()
function! s:fern_keymap()
  ""Press esc twice to close
  nmap <silent><buffer> <ESC><ESC> :<C-u>bd<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>bd<CR>
  ""Fern Keymaps
  nmap <silent><buffer><nowait> <C-h> <Plug>(fern-action-leave)
  nmap <silent><buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <silent><buffer><nowait> <C-r> <Plug>(fern-action-reload)
  nmap <silent><buffer><nowait> o <Plug>(fern-action-open)
  nmap <silent><buffer><nowait> <Return> o
  nmap <silent><buffer><nowait> <Space> <Plug>(fern-action-mark:toggle)
  nmap <silent><buffer><nowait> t <Plug>(fern-action-open:tabedit)
  nmap <silent><buffer><nowait> l <Plug>(fern-action-expand)
  nmap <silent><buffer><nowait> x <Plug>(fern-action-open:system)
  nmap <silent><buffer><nowait> N <Plug>(fern-action-new-file)
  nmap <silent><buffer><nowait> K <Plug>(fern-action-new-dir)
  nmap <silent><buffer><nowait> c <Plug>(fern-action-copy)
  nmap <silent><buffer><nowait> m <Plug>(fern-action-move)
  nmap <silent><buffer><nowait> r <Plug>(fern-action-rename)
  nmap <silent><buffer><nowait> D <Plug>(fern-action-trash)
  nmap <silent><buffer><nowait> C <Plug>(fern-action-clipboard-copy)
  nmap <silent><buffer><nowait> M <Plug>(fern-action-clipboard-move)
  nmap <silent><buffer><nowait> P <Plug>(fern-action-clipboard-paste)
  nmap <silent><buffer> yy <Plug>(fern-action-yank:path)
  ""FZF Keymaps
  nmap <silent><buffer><nowait> <LocalLeader>a :<C-u>FzfAg<CR>
  nmap <silent><buffer><nowait> <LocalLeader>b :<C-u>FzfBuffers<CR>
  nmap <silent><buffer><nowait> <LocalLeader>h :<C-u>FzfHistory<CR>
endfunction


"Setting/Tool/junegunn/fzf.vim
let g:fzf_command_prefix = 'Fzf'
let g:fzf_layout = { 'up': '~35%' }
nmap <silent> <Leader><Leader> :<C-u>FzfFiles<CR>
nnoremap <silent><nowait> <LocalLeader>l :<C-u>FzfBLines<CR>
nnoremap <silent><nowait> <LocalLeader>b :<C-u>FzfBuffers<CR>
nnoremap <silent><nowait> <LocalLeader>a :<C-u>cd %:p:h<CR> :<C-u>FzfAg<CR>
nnoremap <silent><nowait> <LocalLeader>h :<C-u>FzfHistory<CR>


"Setting/Tool/iberianpig/tig-explorer.vim
""git status
nnoremap <silent> <LocalLeader>gs :<C-u>TigStatus<CR>
""git log
nnoremap <silent> <LocalLeader>gl :<C-u>Tig<CR>
""git log of current file
nnoremap <silent> <LocalLeader>gc :<C-u>TigOpenCurrentFile<CR>
""git blame
nnoremap <silent> <LocalLeader>gb :<C-u>TigBlame<CR>


"Setting/Tool/ghq
""cd like ghq
command! -nargs=0 Repo call fzf#run({
\   'source': 'ghq list --full-path',
\   'sink': 'cd'
\ })


"Setting/Tool/previm/previm
let g:previm_open_cmd = 'open -a Google\ Chrome'


"Setting/Tool/glidenote/memolist.vim
let g:memolist_path = "$HOME/memo"
let g:memolist_memo_suffix = "md"
let g:memolist_template_dir_path = "~/.config/memo"


"Setting/Tool/tyru/open-browser.vim
nmap <silent> <LocalLeader>op <Plug>(openbrowser-smart-search)
vmap <silent> <LocalLeader>op <Plug>(openbrowser-smart-search)
nnoremap <silent> <LocalLeader>tl :<C-u>execute 'OpenBrowserSearch -deepl' expand('<cWORD>')<CR>
let g:openbrowser_search_engines = {
\    'deepl': 'https://www.deepl.com/translator#auto/auto/{query}',
\}


"Setting/Tool/neoclide/coc.nvim
let g:coc_global_extensions = [
    \ 'coc-lists',
    \ 'coc-marketplace',
    \ 'coc-json',
    \ 'coc-tsserver',
    \ 'coc-prettier',
    \ 'coc-eslint',
    \ 'coc-python',
    \ 'coc-go',
\ ]
""Show all diagnostics (OR CocList diagnostics)
nnoremap <silent> <Leader>di :<C-u>CocDiagnostics<CR>
""Navigate diagnostics
nmap <silent> <C-j> <Plug>(coc-diagnostic-next)
nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
""Hover
nmap <silent> <Leader>hv :<C-u>call CocAction('doHover')<CR>>
""Definition
nmap <silent> <Leader>gd <Plug>(coc-definition)
""References
nmap <silent> <Leader>rf <Plug>(coc-references)
""Rename
nmap <silent> <Leader>rn <Plug>(coc-rename)
""Show CocList
nnoremap <silent><nowait> <Leader>l  :<C-u>CocList<CR>
""Show commands
nnoremap <silent><nowait> <Leader>c  :<C-u>CocList commands<CR>
""Search workspace symbols
nnoremap <silent><nowait> <Leader>s  :<C-u>CocList -I symbols<CR>


"Setting/Tool/liuchengxu/vista.vim
let g:vista#renderer#enable_icon = 0
let g:vista_sidebar_position = 'vertical topleft'

autocmd FileType markdown call s:vista_keymap_markdown()
function! s:vista_keymap_markdown()
  ""TODO: <Leader>o で、Vista finder fzf:toc がやりたいが、現状できないので操作ミスを考慮して、解決するまで t と同じにしておく。
  nmap <silent><buffer><nowait> <Leader>o :<C-u>Vista toc<CR>
  nmap <silent><buffer><nowait> <Leader>t :<C-u>Vista toc<CR>
endfunction

autocmd FileType vista_markdown call s:vista_keymap_vista_markdown()
function! s:vista_keymap_vista_markdown()
  ""Press esc twice to close
  nmap <silent><buffer> <ESC><ESC> :<C-u>Vista!<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>Vista!<CR>
endfunction

autocmd FileType typescript call s:vista_keymap_development()
autocmd FileType javascript call s:vista_keymap_development()
autocmd FileType go call s:vista_keymap_development()
autocmd FileType python call s:vista_keymap_development()
function! s:vista_keymap_development()
  nmap <silent><buffer><nowait> <Leader>o :<C-u>Vista finder coc<CR>
  nmap <silent><buffer><nowait> <Leader>t :<C-u>Vista coc<CR>
endfunction

autocmd FileType vista call s:vista_keymap()
function! s:vista_keymap()
  ""Press esc twice to close
  nmap <silent><buffer> <ESC><ESC> :<C-u>Vista!<CR>
  imap <silent><buffer> <ESC><ESC> <ESC>:<C-u>Vista!<CR>
endfunction


"Setting/Tool/itchyny/lightline.vim
let g:lightline = {
    \ 'colorscheme': 'nord',
    \ 'active': {
    \   'left': [
    \     [ 'mode', 'paste' ],
    \     [ 'coc_error', 'coc_warn', 'coc_info' ],
    \     [ 'readonly', 'gitbranch', 'filename', 'modified' ],
    \   ],
    \   'right': [
    \     [ 'fileformat', 'fileencoding', 'filetype', 'percent', 'lineinfo' ],
    \   ],
    \ },
    \ 'inactive': {
    \   'left': [
    \     [ 'inactive_filename' ],
    \   ],
    \   'right': [
    \     [ ],
    \   ],
    \ },
    \ 'component_function': {
    \   'gitbranch': 'gitbranch#name',
    \   'filename': 'LightlineFilename',
    \ },
    \ 'component_expand': {
    \   'coc_error': 'LightlineCocError',
    \   'coc_warn': 'LightlineCocWarn',
    \   'coc_info': 'LightlineCocInfo',
    \   'inactive_filename': 'LightlineFilename',
    \ },
    \ 'component_type': {
    \   'coc_error': 'error',
    \   'coc_warn': 'warning',
    \   'coc_info': 'tabsel',
    \   'inactive_filename': 'middle',
    \ },
\ }

""Custom Color Settings
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.right = s:palette.normal.middle

function! LightlineFilename() abort
    return expand('%:p:h:t') . '/' . expand('%:t')
endfunction

function! s:lightline_coc_diagnostic(type, sign) abort
    let info = get(b:, 'coc_diagnostic_info', 0)
    if empty(info) || get(info, a:type, 0) == 0
        return ''
    endif
    return printf('%s %d', a:sign, info[a:type])
endfunction

function! LightlineCocError() abort
    return s:lightline_coc_diagnostic('error', '✘')
endfunction

function! LightlineCocWarn() abort
    return s:lightline_coc_diagnostic('warning', '⚠')
endfunction

function! LightlineCocInfo() abort
    return s:lightline_coc_diagnostic('information', 'i')
endfunction

augroup coc-status-settings
  autocmd!
  autocmd User CocDiagnosticChange call lightline#update()
augroup END


"Setting/ExternalFile
if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif


"Setting/Path
set runtimepath+=~/.vim/
runtime! userautoload/*.vim

