" OSのクリップボードを使用する
set clipboard+=unnamed

" ファイルフォーマット自動判別
set fileformats=unix,dos,mac

" 文字列検索ハイライト
set hlsearch

" Editor
" ================================

" 行番号,ルーラー 表示
set number
set ruler

" タブ
set tabstop=4     " Tab文字表示幅

" インデント
"set autoindent " 前行インデント継続
set smartindent " 少し構文理解してくれる?
"set indentexpr " スクリプトで設定

" 画面右端の折り返し
set wrap

" 矩形選択(C^v) で 行末より右にもカーソルを置けるようにする
set virtualedit=block

" Tab Line
" ================================

" タブラインを常に表示
set showtabline=2

" Status Line
" ================================

" ステータスラインを常に表示
set laststatus=2

" ステータスラインにコマンドを表示
set showcmd

" ファイル名表示
set statusline+=%<%F

" 変更有無
set statusline+=%m

" 読込専用かどうか
set statusline+=%r

" ファイルフォーマット
set statusline+=[%{&fileformat}]

" 文字コード
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}]

"ファイルタイプ表示
set statusline+=%y

" vim-plug
" https://github.com/junegunn/vim-plug
" ================================

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

Plug 'mhinz/vim-startify'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" golang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Initialize plugin system
call plug#end()

