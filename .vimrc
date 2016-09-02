" OSのクリップボードを使用する
set clipboard+=unnamed

" ファイルフォーマット自動判別
set fileformats=unix,dos,mac

" ================================
" Editor
" ================================

" 行番号,ルーラー 表示
set number
set ruler

" タブ
set tabstop=4

" 矩形選択(C^v) で 行末より右にもカーソルを置けるようにする
set virtualedit=block

" ================================
" Tab Line
" ================================

" タブラインを常に表示
set showtabline=2

" ================================
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
