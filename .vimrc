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
set tabstop=2     " Tab文字表示幅

" インデント
set expandtab   " Tabキーでスペース入力
"set autoindent " 前行インデント継続
set smartindent " 少し構文理解してくれる?
"set indentexpr " スクリプトで設定
set shiftwidth=2 " vimが挿入するインデントの幅 

" 画面右端の折り返し
set wrap

" 矩形選択(C^v) で 行末より右にもカーソルを置けるようにする
set virtualedit=block

" Tab Line
" ================================

" タブ操作 prefix key
nnoremap	[Tag]	<Nop>
nmap	t	[Tag]

" t{n} => タブ切替え
for n in range(1, 9)
	execute 'nnoremap <silent> [Tag]'.n	':<C-u>tabnext'.n.'<CR>'
endfor

" tc => 新しいタブ
map <silent> [Tag]c :tablast <bar> tabnew<CR>

" tx => タブを閉じる
map <silent> [Tag]x :tabclose<CR>

" tn => 次のタブへ(→)
map <silent> [Tag]n :tabnext<CR>

" tp => 前のタブへ(←)
map <silent> [Tag]p :tabprevious<CR>

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

" Plugins (using junegunn/vim-plug)
" ================================

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
" --------------------------------
call plug#begin('~/.vim/plugged')

" Completion
" --------------------------------
Plug 'junegunn/vim-easy-align'
Plug 'cohama/lexima.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Filer
" --------------------------------
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
nnoremap <silent><C-e> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1

" Syntax
" --------------------------------

" golang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" kotlin
Plug 'udalov/kotlin-vim'

" GitHub
" --------------------------------
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Initialize plugin system
" --------------------------------
call plug#end()

