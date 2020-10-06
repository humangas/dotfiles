# vim



## vim 力 UP
- [VimGolf - real Vim ninjas count every keystroke!](https://www.vimgolf.com/)



## .vimrc の設定
### Setting/Basic
#### vim の内部エンコーディングを UTF-8 に設定する
- `set encoding=utf8`

#### File Encoding
- `set fileencoding=utf-8`

#### To view the command in the input to the status.
- `set showcmd`

#### No create swap file.
- `set noswapfile`

#### No create backup file.
- `set nobackup`

#### To insert the selected text in visual mode to the clipboard. & Share the clipboard.
- `set clipboard=unnamed,autoselect`

#### Buffer is to be opened in the editing.
- `set hidden`

#### Rereading Automatic When the file being edited is changed.
- `set autoread`

#### To make sure when there are unsaved files.
- `set confirm`

#### Disable all the beep.
- `set visualbell t_vb=`

#### Not sound the beep at the time of display of error messages.
- `set noerrorbells`

#### If already in the buffer, open that file.
- `set switchbuf=useopen`

#### Auto save file If there is a change when file move or make command is executed.
- `set autowrite`

#### Turn off automatic line breaks.
- `set textwidth=0`

#### The number of command history
- `set history=100`

#### Completion Style
- `set completeopt=menuone,noinsert`

#### Display double-byte characters normally
- `set ambiwidth=double`
- '※' などの記号が潰れないようにする。

#### Ignore Pattern when the complement, vimgrep.
- `set wildignore=*.o,*.obj,*.pyc,*.so,*.dll,*.class,*~`

#### 補完表示時の Enter で改行をしない
- `inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"`
- ref. [Vimの補完を他エディタやIDEのような挙動にするようにする｜yasukotelin｜note](https://note.com/yasukotelin/n/na87dc604e042)

#### 作業ディレクトリを現在のファイルのディレクトリに自動で設定する
- 動作: 自動で編集ファイルがあるディレクトリに移動する
- ref. [Set working directory to the current file | Vim Tips Wiki | Fandom](https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file)

```
augroup autochdir-settings
  autocmd!
  autocmd BufEnter * silent! lcd %:p:h
augroup END
```

