# TODO

## README を仕上げる
- vimrc の内容を書く

## Snippet を使いやすくする
- Plugin 選びから考え直す。

```
"Test Snippet
"" C-Space 的なキーで、補完表を出す。
"Ctrl k でスニペット挿入。今だと、ctr + n , p で移動、ctl k で挿入できるみたい。
"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

""Development
"""brew install node && npm i -g yarn
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'liuchengxu/vista.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
```

## その他
- bo term の open 分割幅を固定したい。
- commit から PR をすぐに開きたい（PR 自体は、ブラウザで開いてもいい）
  - 前にどっかで見たので、まずは検索する。
- term の history をもうちょい長くしたい。
- TERMINAL の時は、statusline を表示しない。ブランチと PATH だけでいい。
- key map を group 下して、map したやつを簡単にみれるようにしたい。
  - どっかの tips に書いてあったので探す。
- 不要なプラグインをoffにして起動を早くしたい。
  - ref. https://lambdalisue.hatenablog.com/entry/2015/12/25/000046
- coc.nvim で使いそうな機能がないか一通りマニュアル調べる
- tig の g は使わないので、grep じゃなくて、gg に overide したい。
- json error 時の色をみやすくしたい。

