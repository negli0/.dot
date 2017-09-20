""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" general setting
""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
set enc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,sjis

set ts=4
set sw=4
set hlsearch

set colorcolumn=80
set formatoptions+=mM
set ignorecase
set cindent
inoremap /* /**/<left><left>

set number
imap <C-j> <C-[>

set statusline=%<%f\ %m%r%h%w
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}
set statusline+=%=%l/%L,%c%V%8P

set backspace=indent,eol,start

if has("autocmd")
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal! g'\"" |
\ endif
endif

""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" NeoBundle 
""""""""""""""""""""""""""""""""""""""""""""

" neobundle settings {{{
if has('vim_starting')
set nocompatible
" neobundle をインストールしていない場合は自動インストール
if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
echo "install neobundle..."
" vim からコマンド呼び出しているだけ neobundle.vim のクローン
:call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
endif
" runtimepath の追加は必須
set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" neobundle#begin - neobundle#end の間に導入するプラグインを記載します。
NeoBundleFetch 'Shougo/neobundle.vim'
" ↓こんな感じが基本の書き方
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'Shougo/vimproc', {
	\ 'build' : {
    \     'windows' : 'make -f make_mingw32.mak',
	\     'cygwin' : 'make -f make_cygwin.mak',
	\     'mac' : 'make -f make_mac.mak',
	\     'unix' : 'make -f make_unix.mak',
	\    },
	\ }
NeoBundleLazy 'Shougo/vimshell', {
	\ 'depends' : 'Shougo/vimproc',
	\ 'autoload' : {
	\   'commands' : [{ 'name' : 'VimShell', 'complete' : 'customlist,vimshell#complete'},
	\                 'VimShellExecute', 'VimShellInteractive',
	\                 'VimShellTerminal', 'VimShellPop'],
	\   'mappings' : ['<Plug>(vimshell_switch)']
	\ }}

" vimshell {{{
	nmap <silent> vs :<C-u>VimShell<CR>
	nmap <silent> vp :<C-u>VimShellPop<CR>
" }}}
NeoBundle 'Townk/vim-autoclose'
NeoBundleLazy 'thinca/vim-quickrun', {
	\ 'autoload' : {
	\   'mappings' : [['n', '\r']],
	\   'commands' : ['QuickRun']
	\ }}

	" quickrun {{{
	let g:quickrun_config = {}
	let g:quickrun_config._ = { 'runner' : 'vimproc',
	\ 'runner/vimproc/updatetime' : 200,
	\ 'outputter/buffer/split' : ':botright 8sp',
	\ 'outputter' : 'multi:buffer:quickfix',
	\ 'hook/close_buffer/enable_empty_data' : 1,
	\ 'hook/close_buffer/enable_failure' : 1,
	\ }
	nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
	" }}}
" Python
"NeoBundleLazy "davidhalter/jedi-vim", {
"  \ "autoload": {
"    \   "filetypes": ["python", "python3", "djangohtml"],
"    \ },
"  \ "build" : {
"    \   "mac"  : "pip install jedi",
"    \   "unix" : "pip install jedi",
"    \ }}
"	" jedi-vim {{{
"	let g:jedi#rename_command = '<Leader>R'
"	let g:jedi#goto_assignments_command = '<Leader>G'
"	autocmd FileType python setlocal omnifunc=jedi#completions
"	let g:jedi#completions_enabled = 0
"	let g:jedi#auto_vim_configuration = 0
"	" }}}

NeoBundle 'vitalk/vim-shebang'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'awk.vim'
NeoBundle 'fatih/vim-go'
" 代入 スコープ: 変数名   = 値
" " let  g:     synta..  = ['pyflakes']
 let g:syntastic_python_checkers = ['pyflakes']
" " g ... Global, l ... Local
"


" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
	NeoBundleCheck
call neobundle#end()
	filetype plugin indent on
	
""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""" Syntax
""""""""""""""""""""""""""""""""""""""""""""

syntax on
syntax enable
hi ColorColumn ctermbg=darkgray
hi FoldColumn ctermfg=black ctermbg=darkgray
hi Folded ctermfg=darkgray ctermbg=none
hi LineNr  ctermfg=darkgray
hi Comment ctermfg=darkgray
hi Visual ctermbg=black

filetype plugin indent on


inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

"" python determination
augroup SetShebang
	autocmd! SetShebang
	autocmd BufNewFile *.py 0put =\"#! /usr/bin/env python\n# -*- coding: utf-8 -*-\n\n# \" .expand('%') .\"\n# nelio\"|$
augroup END
