" ================================
" Plugins (using junegunn/vim-plug)
" ================================

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

" --------------------------------
" Color Scheme
" --------------------------------
Plug 'altercation/vim-colors-solarized', { 'do': '[ ! -e ~/.vim/colors ] && mkdir -p ~/.vim/colors; ln -s ~/.vim/plugged/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/solarized.vim' }

" --------------------------------
" Completion
" --------------------------------
Plug 'junegunn/vim-easy-align'
Plug 'cohama/lexima.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'

" --------------------------------
" Filer
" --------------------------------
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
nnoremap <silent><C-e> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1
autocmd VimEnter * execute 'NERDTree'

Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" --------------------------------
" Syntax
" --------------------------------

" markdown
Plug 'plasticboy/vim-markdown'
Plug 'kannokanno/previm'
Plug 'tyru/open-browser.vim'
autocmd BufRead,BufNewFile *.md set filetype=markdown
" C^p でプレビュー
nnoremap <silent><C-p> :PrevimOpen<CR>
" 折りたたみ無効
let g:vim_markdown_folding_disabled=1

" golang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
autocmd BufNewFile,BufRead *.go nmap <F9> :GoBuild<CR>
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

" kotlin
Plug 'udalov/kotlin-vim'

" --------------------------------
" GitHub
" --------------------------------
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

call plug#end()
" -> Initialize plugin system


" ================================
" Options
" ================================

" OSのクリップボードを使用する
set clipboard+=unnamed

" ファイルフォーマット自動判別
set fileformats=unix,dos,mac

" 文字列検索ハイライト
set hlsearch

" Color Scheme
syntax enable
set background=light
colorscheme solarized

" --------------------------------
" Editor
" --------------------------------

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

" --------------------------------
" Tab Line
" --------------------------------

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

" --------------------------------
" Status Line
" --------------------------------

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

set rtp+=/usr/local/opt/fzf

