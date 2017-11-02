" Modeline and Notes { vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,}
" foldlevel=0 foldmethod=marker spell:
"
"   This is the personal .vimrc file of fgle. While much of it is beneficial
"   for general use, I would recommend picking out the parts you want and
"   understand.
"
"   Licensed under the Apache License, Version 2.0 (the "License"); you may
"   not use this file except in compliance with the License. You may obtain a
"   copy of the License at
"
"       http://www.apache.org/licenses/LICENSE-2.0
"
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
"   WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
"   License for the specific language governing permissions and limitations
"   under the License. }

" Basics {
    set nocompatible        " Must be first line
    set shell=/bin/sh
" }

" Use plugs config {
    if filereadable(expand("~/.vimrc.plugs"))
        source ~/.vimrc.plugs
    endif
" }

" General {

    set background=dark         " Assume a dark background
    set helplang=cn

    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    filetype on                 " 开启文件类型检测
    filetype plugin on          " 载入文件类型插件
    filetype indent on          " 为特定文件类型载入相关缩进
    syntax on                   " 语法 高亮
    set nocompatible            " 禁用vi的键盘模式
    set mouse=a                 " 使用鼠标
    set mousehide               " 打字时隐藏鼠标光标
    scriptencoding utf-8

    if has('clipboard')         "使用系统缓冲区和粘贴板复制粘贴
        if has('unnamedplus')
            set clipboard=unnamed,unnamedplus
        else         " mac and Windows
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:fgle_no_autochdir = 1
    if !exists('g:fgle_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    set autowrite                       " 自动备份
    set shortmess+=aTI                  " hit-enter提O示消息缩写
    set virtualedit=onemore             " 允许光标移动到刚刚超过行尾的位置
    set history=100                     " 历史命令
    set spell                           " 拼写检测
    set hidden                          " 允许在未保存时切换缓冲区
    set iskeyword-=.                    " . 作为单词结束
    set iskeyword-=#                    " # 作为单词结束
    set iskeyword+=$,@,_,-              "这些符号作为单词内容(使用单词移动时)

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " 备份和撤销 {
        if has("vms")
            set nobackup
        else
            set backup                      " 备份文件
        endif
        if has('persistent_undo')       " 撤销操作
            set undofile
            set undolevels=100
            set undoreload=1000
            set undodir="$HOME/.undodir"
        endif
    " }

" }

" Vim UI {
    if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        colorscheme solarized             " vim主题
    endif

    set tabpagemax=15               " 最大标签页数
    set showmode                    " 显示模式(normal,insert,visual)

    set cursorline                  " 高亮光标所在行

    set cmdheight=1                 "命令行高度

    if has('statusline')
        set laststatus=2

        set statusline=%<%f\                     " 文件名
        set statusline+=%w%h%m%r                 " Options
        if isdirectory(expand("~/.vim/plugged/vim-fugitive"))
            set statusline+=%{fugitive#statusline()} " Git
        endif
        set statusline+=\ [%{&ff}/%Y]            " 文件类型
        set statusline+=\ [%{getcwd()}]          " 当前目录
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  "
    set linespace=0                 " 字符之间插入的像素行数
    set number                      " 显示行号
    set showmatch                   " 显示括号配对
    set incsearch                   " 实时搜索
    set hlsearch                    " 搜索高亮匹配字符
    set winminheight=0              " 非当前窗口的最小高度。
    set ignorecase                  " 查找忽略大小写
    set smartcase                   " 如果搜索模式包含大写字符，不使用 'ignorecase' 选项.只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
    set wildmenu                    " 增强模式运行命令自动补全
    set wildmode=list:longest,full  " <Tab>补全命令,列出所有完整匹配并用最长的字串补全
    set whichwrap=b,s,h,l,<,>,[,]   " 使指定的左右移动光标的键在行首或行尾可以移到前一行或者后一行
    set scrolljump=5                " 光标离开屏幕时,最少的滚动行数
    set scrolloff=3                 " 光标上下两侧最少保留的屏幕行数
    set foldenable                  " 允许折叠
    set foldmethod=indent           " 折叠方式
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " list设置

" }

" Formatting {

    set nowrap                      " 关闭自动换行`
    set autoindent                  " 自动缩进
    set shiftwidth=4                " 设置缩进为4个空格
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " backspace 删除缩进
    set nojoinspaces                " 使用连接命令时，不在 '.'、'?' 和 '!' 之后插入两个空格
    set splitright                  " 垂直分屏在当前窗口的右边
    set splitbelow                  " 水平分屏在当前窗口的下面
    set matchpairs+=<:>             "  形成配对的字符, %命令从其中一个跳转到另一个
    "让配置变更立即生效
    "autocmd BufWritePost $MYVIMRC source $MYVIMRC
    "移除尾后空白字符
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee
    autocmd BufNewFile,BufRead *.md set filetype=markdown
    autocmd Filetype text setlocal textwidth=78

    "新建x,h,sh,java,python文件，自动插入文件头{
    autocmd BufNewFile *.[ch],*.cpp,*.sh,*java execute ":call SetTitle()"
    autocmd BufNewFile *.py execute ":call SetTPythonTitle()"
    autocmd BufNewFile * normal! G "新建文件后，自动定位到文件末尾
" }

" Key (re)Mappings {

    let mapleader = ','
    let maplocalleader = '_'

    "自动补全{

        inoremap ' <C-r>=AutoPair("'","'")<CR>
        inoremap " <C-r>=AutoPair('"','"')<CR>
        inoremap < <C-r>=AutoPair('<','>')<CR>
        inoremap > <C-r>=ClosePair('>')<CR>
        inoremap [ <C-r>=AutoPair('[',']')<CR>
        inoremap ] <C-r>=ClosePair(']')<CR>
        inoremap ( <C-r>=AutoPair('(',')')<CR>
        inoremap ) <C-r>=ClosePair(')')<CR>
        inoremap { <C-r>=AutoPair('{','}')<CR>
        inoremap } <C-r>=ClosePair('}')<CR>
        autocmd Filetype c,cpp,java,shell inoremap { {<CR>}<Esc>k$a<CR>
    "}

    "窗口间跳转
    "let g:fgle_no_easyWindows = 1
    if !exists('g:fgle_no_easyWindows')
        noremap <C-J> <C-W>j<C-W>_
        noremap <C-K> <C-W>k<C-W>_
        noremap <C-L> <C-W>l<C-W>_
        noremap <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " 适配部分大小写
    if !exists('g:fgle_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cnoremap Tabe tabe
    endif

    nnoremap Y y$                   "复制从光标到行尾
    vnoremap <leader>y "+y          "将选中文本复制到系统剪贴板
    nnoremap <leader>p "+p          "将系统剪贴板内容粘贴至vim

    " Find merge conflict markers
    noremap <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " 改变工作目录到光标所在文件
    cnoremap cwd lcd %:p:h
    cnoremap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " 在视图模式允许“.”操作(!)
    vnoremap . :normal .<CR>

    " sudo写入文件
    cnoremap w!! w !sudo tee % >/dev/null

    "显示所有带有关键字（光标所在字）的行
    nnoremap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " 更容易水平滚屏
    noremap zl zL
    noremap zh zH

    "在当前行末添加分号，并保持光标不动
    nnoremap <silent> <leader>; :execute "normal! mqA;<C-v><Esc>`q"<CR>

    " Easier formatting
    nnoremap <silent> <leader>q gwip

" }

" Functions {
    "Alt映射{
        function! Terminal_MetaMode(mode)
            if has('nvim') || has('gui_running')
                return
            endif
            function! s:metacode(mode, key)
                if a:mode == 0
                    execute "set <M-".a:key.">=/e".a:key
                else
                    execute "set <M-".a:key.">=/e]{0}".a:key."~"
                endif
            endfunction
            for i in range(10)
                call s:metacode(a:mode, nr2char(char2nr('0')+i))
            endfor
            for i in range(26)
                call s:metacode(a:mode, nr2char(char2nr('a')+i))
                call s:metacode(a:mode, nr2char(char2nr('A')+i))
            endfor
            if a:mod != 0
                for c in [',','.','/',';','[',']','{','}']
                    call s:metacode(a:mode, c)
                endfor
                for c in ['?',':','-','_']
                    call s:metacode(a:mode, c)
                endfor
            else
                for c in [',','.','/',';','{','}']
                    call s:metacode(a:mode, c)
                endfor
                for c in ['?',':','-','_']
                call s:metacode(a:mode, c)
                endfor
            endif
            if &ttimeout == 0
                set ttimeout
            endif
            if &ttimeoutlen <= 0
                set ttimeoutlen=100
            endif
        endfunction

        command! -nargs=0 -bang VimMetaInit call Terminal_MetaMode(<bang>0)
         "}

    "自动补全{
        function! AutoPair(open, close)
            let line = getline('.')
            if col('.') > strlen(line)
                if a:open == '{'
                    return a:open.a:close."\<Esc>o"
                else
                    return a:open.a:close."\<ESC>i"
                endif
            elseif line[col('.') - 1] == ' ' || line[col('.') - 1] == ')'|| line[col('.') - 1] == ']'
                return a:open.a:close."\<ESC>i"
            elseif a:open == '<' && line[col('.') - 2] == '<'        "适应c++
                return a:open."\<Esc>lxi"
            elseif line[col('.') - 1] == '>'
                return a:open.a:close."\<Esc>i"
            else
                 return a:open
            endif
        endfunction

        function! ClosePair(char)
            if getline('.')[col('.') - 1] == a:char
                return "\<Right>"
            else
                return a:char
            endif
        endfunction
    "}

    "补全头文件{
        function SetTitle()
            if &filetype=='sh'
                call setline(1,"\#################################################")
                call append(line("."),"\# File Name: ".expand("%"))
                call append(line(".")+1,"\# Author: fgle")
                call append(line(".")+2,"\# mail: fgle.sky@gmail.com")
                call append(line(".")+3,"\# Created Time: ".strftime("%c"))
                call setline(line(".")+4,"\#################################################")
                call append(line(".")+5,"\#!/bin/bash")
                call append(line(".")+6,"")
            else
                call setline(1,"/*************************************************")
                call append(line(".")," >File Name: ".expand("%"))
                call append(line(".")+1," >Author: fgle")
                call append(line(".")+2," >mail: fgle.sky@gmail.com")
                call append(line(".")+3," >Created Time: ".strftime("%c"))
                call setline(line(".")+4,"*************************************************/")
                call append(line(".")+5,"")
            endif
            if &filetype=='cpp'
                call append(line(".")+6,"#include<iostream>")
                call append(line(".")+7,"#include<string>")
                call append(line(".")+8,"")
            endif
            if &filetype=='c'
                call append(line(".")+6,"#include<stdio.h>")
                call aapend(line(".")+7,"#include<string.h>")
                call append(line(".")+8,"")
            endif
        endfunction

        function SetTPythonTitle()
                call setline(1,"#!/usr/bin/env python")
                call append(line('.'),"#-*-coding: utf-8 -*-")
            call append(line('.')+1," ")
            call append(line(".")+2,"\# >File Name: ".expand("%"))
            call append(line(".")+3,"\# >Author: fgle")
            call append(line(".")+4,"\# >mail: fgle.sky@gmail.com")
            call append(line(".")+5,"\# >Created Time: ".strftime("%c"))
            call append(line('.')+6,"")
        endfunction
    "}

    " 初始化目录 {
        function! InitializeDirectories()
            let parent = $HOME
            let prefix = 'vim'
            let dir_list = {
                        \ 'backup': 'backupdir',
                        \ 'views': 'viewdir',
                        \ 'swap': 'directory' }

            if has('persistent_undo')
                let dir_list['undo'] = 'undodir'
            endif

            let common_dir = parent . '/.' . prefix

            for [dirname, settingname] in items(dir_list)
                let directory = common_dir . dirname . '/'
                if exists("*mkdir")
                    if !isdirectory(directory)
                        call mkdir(directory)
                    endif
                endif
                if !isdirectory(directory)
                    echo "Warning: Unable to create backup directory: " . directory
                    echo "Try: mkdir -p " . directory
                else
                    let directory = substitute(directory, " ", "\\\\ ", "g")
                    exec "set " . settingname . "=" . directory
                endif
            endfor
        endfunction
        call InitializeDirectories()
    " }

    " 去除空白 {
        function! StripTrailingWhitespace()
           let _s=@/
           let l = line(".")
           let c = col(".")

            %s/\s\+$//e

            let @/=_s
            call cursor(l, c)
        endfunction
    " }

    " 运行Shell命令 {
        function! s:RunShellCommand(cmdline)
            botright new

            setlocal buftype=nofile
            setlocal bufhidden=delete
            setlocal nobuflisted
            setlocal noswapfile
            setlocal nowrap
            setlocal filetype=shell
            setlocal syntax=shell

            call setline(1, a:cmdline)
            call setline(2, substitute(a:cmdline, '.', '=', 'g'))
            execute 'silent $read !' . escape(a:cmdline, '%#')
            setlocal nomodifiable
            1
        endfunction

        command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
        " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

        function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
        endfunction

        function! s:EditfgleConfig()
            call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
            call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.plugs")
        endfunction

        execute "noremap <leader>ev :call <SID>EditfgleConfig()<CR>"
        execute "noremap <leader>es :source ~/.vimrc<CR>"
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }
