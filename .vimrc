" Modeline and Notes { vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,}
" foldlevel=0 foldmethod=indent spell:

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
    set formatoptions+=mM
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
    autocmd BufNewFile,BufReadPost *.coffee set filetype=coffee
    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    autocmd Filetype text,markdown setlocal textwidth=78

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
            if a:mode != 0
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
        call Terminal_MetaMode(1)

        command! -nargs=0 -bang VimMetaInit call Terminal_MetaMode(<bang>1)
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
" Plugin {
    " General {
        " NerdTree {
            if isdirectory(expand("~/.vim/plugged/nerdtree"))
                noremap <C-e> <plug>NERDTreeTabsToggle<CR>
                noremap <leader>e :NERDTreeFind<CR>

                " 是否显示隐藏文件
                let NERDTreeShowHidden=1
                " 设置宽度
                let NERDTreeWinSize=31
                " 在启动vim时，启动NERDTree
                "let g:nerdtree_tabs_open_on_console_startup=1
                " 忽略一下文件的显示
                let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
                " 显示书签列表
                let NERDTreeShowBookmarks=1
            endif
            if isdirectory(expand("~/.vim/plugged/nerdtree-git-plugin"))
                let g:NERDTreeIndicatorMapCustom = {
                    \ "Modified"  : "✹",
                    \ "Staged"    : "✚",
                    \ "Untracked" : "✭",
                    \ "Renamed"   : "➜",
                    \ "Unmerged"  : "═",
                    \ "Deleted"   : "✖",
                    \ "Dirty"     : "✗",
                    \ "Clean"     : "✔︎",
                    \ "Unknown"   : "?"
                \ }
            endif
        " }

        " vim-surround{
            if isdirectory(expand("~/.vim/plugged/vim-surround"))
                "一个单词
                nmap <leader>' ysiw'<CR>
                nmap <leader>" ysiw"<CR>
                nmap <leader>[ ysiw]<CR>
                nmap <leader>( ysiw)<CR>
                nmap <leader>< ysiw><CR>
                nmap <leader>{ ysiw}<CR>
              "一行
                nmap <leader>l' yss'<CR>
                nmap <leader>l" yss"<CR>
                nmap <leader>l[ yss]<CR>
                nmap <leader>l( yss)<CR>
                nmap <leader>l< yss><CR>
                nmap <leader>l{ yss}<CR>
                "删除
                nmap <leader>d' ds'<CR>
                nmap <leader>d" ds"<CR>
                nmap <leader>d[ ds]<CR>
                nmap <leader>d( ds)<CR>
                nmap <leader>d< ds><CR>
                nmap <leader>d{ ds}<CR>
            endif
        " }

        " airline{
            if isdirectory(expand("~/.vim/plugged/airline"))

            endif
        " }

        " indent_guides {
            if isdirectory(expand("~/.vim/plugged/vim-indent-guides/"))
                let g:indent_guides_start_level = 2
                let g:indent_guides_guide_size = 1
                let g:indent_guides_enable_on_vim_startup = 1
            endif
        " }

        " UndoTree {
            if isdirectory(expand("~/.vim/plugged/undotree/"))
                nnoremap <Leader>u :UndotreeToggle<CR>
                " If undotree is opened, it is likely one wants to interact with it.
                let g:undotree_SetFocusWhenToggle=1
            endif
        " }

        " vim-airline {
            if isdirectory(expand("~/.vim/plugged/vim-airline/"))
                if isdirectory(expand("~/.vim/plugged/vim-airline-themes"))
                    let g:airline_theme = 'solarized'
                endif
                let g:airline_powerline_fonts=1
                "显示tab和buffer
                let g:airline#extensions#tabline#enabled=1
            endif
        " }
    " }

    " Writting {
        " maekdown{
            if isdirectory(expand("~/.vim/plugged/vim-markdown"))
                "关闭markdown折叠
                let g:vim_markdown_folding_disabled = 1
                "设置折叠风格like python-mode
                "let g:vim_markdown_folding_style_pythonic = 1
            endif
        " }
    " }

    " Programing {
        " Fugitive {
            if isdirectory(expand("~/.vim/plugged/vim-fugitive/"))
                nnoremap <silent> <leader>gs :Gstatus<CR>
                nnoremap <silent> <leader>gd :Gdiff<CR>
                nnoremap <silent> <leader>gc :Gcommit<CR>
                nnoremap <silent> <leader>gb :Gblame<CR>
                nnoremap <silent> <leader>gl :Glog<CR>
                nnoremap <silent> <leader>gp :Git push<CR>
                nnoremap <silent> <leader>gr :Gread<CR>
                nnoremap <silent> <leader>gw :Gwrite<CR>
                nnoremap <silent> <leader>ge :Gedit<CR>
                " Mnemonic _i_nteractive
                nnoremap <silent> <leader>gi :Git add -p %<CR>
                nnoremap <silent> <leader>gg :SignifyToggle<CR>
           endif
        "}

        " ale{
            if isdirectory(expand("~/.vim/plugged/ale"))
                "始终开启标志列
                let g:ale_sign_column_always = 1
                let g:ale_set_highlights = 0
              "自定义error和warning图标
                let g:ale_sign_error = '✗'
                let g:ale_sign_warning = '⚡'
                "在vim自带的状态栏中整合ale
                let g:ale_statusline_format = ['✗ %d', '⚡ %d', '✔ OK']
                "设置状态行
                set statusline+=\ %{ALEGetStatusLine()}
                "显示Linter名称,出错或警告等相关信息
                let g:ale_echo_msg_error_str = 'E'
                let g:ale_echo_msg_warning_str = 'W'
                let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
                "对C/C++使用Clang进行语法检查
                let g:ale_linters = {'c': 'clang'}
                let g:ale_linters = {'c++': 'clang++'}
                "普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
                nmap sp <Plug>(ale_previous_wrap)
                nmap sn <Plug>(ale_next_wrap)
                "<Leader>s触发/关闭语法检查
                nmap <Leader>s :ALEToggle<CR>
                "<Leader>d查看错误或警告的详细信息
                nmap <Leader>d :ALEDetail<CR>
            endif
        " }

        " vim-commentary{
            if isdirectory(expand("~/.vim/plugged/vim-commentary"))
                "为python,shell添加注释规则
                autocmd Filetype python,shell set commentstring=#\ %s
                "修改注释风格
                autocmd Filetype java,c,cpp set commentstring=//\ %s
            endif
         " }

        " PythonMode {
            " Disable if python support not present
            if !has('python') && !has('python3')
                let g:pymode = 0
            endif

            if isdirectory(expand("~/.vim/plugged/python-mode"))
                "开启警告
                let g:pymode_warnings = 0
                "保存文件时自动删除无用空格
                let g:pymode_trim_whitespaces = 1
                let g:pymode_options = 1
                "显示允许的最大长度的列
                let g:pymode_options_colorcolumn = 1
                "设置QuickFix窗口的最大，最小高度
                let g:pymode_quickfix_minheight = 3
                let g:pymode_quickfix_maxheight = 10
                "使用python3
                let g:pymode_python = 'python3'
                "使用PEP8风格的缩进
                let g:pymode_indent = 1
                "取消代码折叠
                let g:pymode_folding = 0
                "开启python-mode定义的移动方式
                let g:pymode_motion = 1
                "启用python-mode内置的python文档，使用K进行查找
                let g:pymode_doc = 1
                let g:pymode_doc_bind = 'K'
                "自动检测并启用virtualenv
                let g:pymode_virtualenv = 1
                "不使用python-mode运行python代码
                let g:pymode_run = 0
                "let g:pymode_run_bind = '<Leader>r'
                "不使用python-mode设置断点
                let g:pymode_breakpoint = 0
                "let g:pymode_breakpoint_bind = '<leader>b'
                "启用python语法检查
                let g:pymode_lint = 1
                "修改后保存时进行检查
                let g:pymode_lint_on_write = 0
                "编辑时进行检查
                let g:pymode_lint_on_fly = 0
                let g:pymode_lint_checkers = ['pyflakes', 'pep8']
                "发现错误时不自动打开QuickFix窗口
                let g:pymode_lint_cwindow = 0
                "侧边栏不显示python-mode相关的标志
                let g:pymode_lint_signs = 0
                "let g:pymode_lint_todo_symbol = 'WW'
                "let g:pymode_lint_comment_symbol = 'CC'
                "let g:pymode_lint_visual_symbol = 'RR'
                "let g:pymode_lint_error_symbol = 'EE'
                "let g:pymode_lint_info_symbol = 'II'
                "let g:pymode_lint_pyflakes_symbol = 'FF'
                "启用重构
                let g:pymode_rope = 1
                "不在父目录下查找.ropeproject，能提升响应速度
                let g:pymode_rope_lookup_project = 0
                "光标下单词查阅文档
                let g:pymode_rope_show_doc_bind = '<C-c>d'
                "项目修改后重新生成缓存
                let g:pymode_rope_regenerate_on_write = 1
                "开启补全，并设置<C-Tab>为默认快捷键
                let g:pymode_rope_completion = 1
                let g:pymode_rope_complete_on_dot = 1
                let g:pymode_rope_completion_bind = '<C-Tab>'
                "<C-c>g跳转到定义处，同时新建竖直窗口打开
                let g:pymode_rope_goto_definition_bind = '<C-c>g'
                let g:pymode_rope_goto_definition_cmd = 'vnew'
                "重命名光标下的函数，方法，变量及类名
                let g:pymode_rope_rename_bind = '<C-c>rr'
                "重命名光标下的模块或包
                let g:pymode_rope_rename_module_bind = '<C-c>r1r'
                "开启python所有的语法高亮
                let g:pymode_syntax = 1
                let g:pymode_syntax_all = 1
                "高亮缩进错误
                let g:pymode_syntax_indent_errors = g:pymode_syntax_all
                "高亮空格错误
                let g:pymode_syntax_space_errors = g:pymode_syntax_all
            endif
        " }

        "cpp_highlight{
            if isdirectory(expand("~/.vim/plugged/vim-cpp-enhanced-highlight"))
                let g:cpp_class_scope_highlight = 1
                let g:cpp_member_variable_highlight = 1
                "let g:cpp_class_decl_highlight = 1
                let g:cpp_experimental_template_highlight = 1
                "let g:cpp_experimental_simple_template_highlight = 1
                let g:cpp_concepts_highlight = 1
                "let g:cpp_no_function_highlight = 1
            endif
        "}
    " }

    " Snippets & AutoComplete {
        " YouCompleteMe {
            if isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
                let g:acp_enableAtStartup = 0

                " enable completion from tags
                " 允许加载.ycm_extra_conf.py文件,不再提示
                let g:gym_confirm_extra_conf = 1
                "加载路径
                let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
                "在注释中同样可以补全
                let g:gym_complete_in_comments = 1
                "开启ycm标签补全引擎
                let g:ycm_collect_identifiers_from_tags_files = 1
                "引入c++标准库tags
                set tags+=/usr/include/c++/7.2.0/stdcpp.tags
                "从第一个字符开始匹配
                let g:ycm_min_num_of_chars_for_completion=1
                "禁止缓存匹配项
                "let g:ycm_cache_omnifunc=0
                "语法关键字补全
                let g:ycm_seed_identifiers_with_syntax=1

                " remap Ultisnips for compatibility for YCM
                let g:UltiSnipsExpandTrigger = "<leader><tab>"
                let g:UltiSnipsJumpForwardTrigger = "<leader><tab>"
                let g:UltiSnipsJumpBackwardTrigger = "<leader><tab>"

                " Enable omni completion.
                autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
                autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
                autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
                autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
                autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
                autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
                autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
                inoremap <leader>c <C-x><C-o>
            endif
        " }
    " }
" }
