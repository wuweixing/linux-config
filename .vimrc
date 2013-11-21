" User-defined functions

function! MySys()
	if(has("win32") || has("win95") || has("win64") || has("win16")) 
		return "windows"
	else
		return "linux"
	endif
endfunction
function! RemoveOldViewFiles()
 	exe 'find '.$VIMFILES.'/view* -mtime +90 -exec rm {} \;'
endfunction
function! MakeSession()
    if !has('gui_running')
        hi clear
    endif
    if bufname('')  == ''
        exe 'bdelete '.bufnr('')
    endif
    let l:count = 0
    let l:i = 0
    while l:i <= bufnr('$')
        if buflisted(count)
            let l:count += 1
        endif
        let l:i+=1
    endwhile
    if l:count >= 4
        mksession! ~/.last_session.vim
    endif
endfunction

function! LoadSession()
    "if exists('g:SessionLoaded')
    "return
    "endif
    if expand('%') == '' && filereadable($HOME.'/.last_session.vim') && !&diff
        silent so ~/.last_session.vim
    endif

    let l:buftotal = bufnr('$')
    let l:i = 0
    let l:crtpath = getcwd() 
    while l:i <= l:buftotal
        " 列表中还未载入的buffer，如果不在当前工作目录，会被删除
        if !bufloaded(l:i) && buflisted(l:i) && expand('%:p') !~ l:crtpath
            exe 'bdelete '.l:i
            echo expand('%:p') .' !~ '. l:crtpath
        endif
        let l:i += 1
    endwhile
endfunction
function! WikiDateInsert()
        let l:winview = winsaveview()
        0
        read !date
        0 delete
        call winrestview(l:winview)
endfunction
if MySys() == 'windows'
	let $VIMFILES = $VIM.'/vimfiles'
else
	let $VIMFILES = $HOME.'/.vim'
endif
" 基本配置
" 设置不生成swap文件
	set noswf 
" 编码设置
	set encoding=utf-8
	set fileencodings=ucs-bom,utf-8,chinese,gbk,default
	set termencoding=utf-8
" 显示行号
	set nu
" 设置缩进
	set softtabstop=2 " 使得按退格键时可以一次删掉 4 个空格
	set tabstop=2 " 设定 tab 长度为 4
	set shiftwidth=2 
	set expandtab " 将 tab 键转换为空格
	set autoindent        " 自动对齐
	set autoindent cindent cinoptions=g0 "  打开自动缩进和 C 语言风格的缩进模式，定制 C 语言缩进风格
	set smartindent       " 智能对齐
" 设置自动换行
	set wrap 
	set noignorecase " 默认区分大小写
	set ignorecase smartcase " 搜索时忽略大小写，但在有一个或以上大写字母时,仍保持对大小写敏感
" 设置不生成备份
	set nobackup " 覆盖文件时不备份
" 共享剪贴板
	set clipboard+=unnamed

  " 切换自动缩进
  set pastetoggle=<F9>
	set foldlevel=3
	set history=100 " 设置冒号命令和搜索命令的列表的长度为 
	set autochdir " 自动切换当前目录为当前文件所在的目录
	set hlsearch "高亮显示结果
  set mouse=a " 设定在任何模式下鼠标都可用
	set foldcolumn=2
	set foldmethod=indent
	set wildmenu          "增强模式中的命令行自动完成操作
	" set vb t_vb=
	set nowrap "不自动换行
	set nocp              "不兼容vi
	set nocompatible " "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限
	set backspace=indent,eol,start whichwrap+=<,>,[,] "允许退格键的使用
	set helplang=cn       "设置帮助的语言为中文
	set showmatch         "括号匹配模式
	set ruler             "显示状态行
	set incsearch "在输入要搜索的文字时，vim会实时匹配
	set background=light "dark/light 使用了浅色背景 syntax enable命令的前面
	set winaltkeys=no    "Alt组合键不映射到菜单上
	syntax enable   "设置高亮关键字显示
	syntax on " 自动语法高亮
	filetype plugin indent on "自动识别文件类型，用文件类型plugin脚本使用缩进义文件
	if has("gui_running")
		colorscheme darkblue" 设定背景为夜间模式
		if MySys() == 'windows'
			autocmd GUIEnter * simalt ~x	" 设定 windows 下图形界面下的字体.
			set guifont=Bitstream_Vera_Sans_Mono:h14:cANSI
		else
			"set guifont=Bitstream_Vera_Sans_Mono:h9:cANSI "记住空格用下划线代替哦
			set guifont=DejaVu\ Sans\ Mono\ 11 "记住空格用下划线代替哦
			set gfw=幼圆:h10:cGB2312
		endif
	else	
		colorscheme desert" 设定背景为夜间模式
	endif 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"兼容设置
	if MySys() == 'windows'
		let JavaBrowser_Ctags_Cmd='ctags'
		let Tlist_Ctags_Cmd= 'ctags'
    	let g:iswindows=1
		set fileencoding=chinese
		au GUIEnter * simalt ~x " 防止linux终端下无法拷贝
	else
		let JavaBrowser_Ctags_Cmd='/usr/bin/ctags'
		let Tlist_Ctags_Cmd= '/usr/bin/ctags'
    	let g:iswindows=0
		set fileencoding=utf-8
	endif
	if v:version >= 700
		set completeopt=menu,longest,preview
		" 自动补全(ctrl-p)时的一些选项：多于一项时显示菜单，最长选择，显示当前选择的额外信息
	endif
	set confirm " 用确认对话框（对于 gvim）或命令行选项（对于vim）来代替有未保存内容时的警告信息
	" set display=lastline 长行不能完全显示时显示当前屏幕能显示的部分。默认值为空，长行不能完全显示时显示
	set formatoptions=tcqro " 使得注释换行时自动加上前导的空格和星号
	set hidden " 允许在有未保存的修改时切换缓冲区
	set backupcopy=yes " 设置备份时的行为为覆盖
	set nolinebreak " 在单词中间断行
	set scrolloff=4 " 设定光标离窗口上下边界 5 行时窗口自动滚动
	" set whichwrap=b,s,<,>,[,] " 设定退格键、空格键以及左右方向键在行首行尾时的
	" " 行为，不影响 h 和 l 键

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 设置命令行和状态栏
	set cmdheight=2 " 设定命令行的行数为 2
	set laststatus=2 " 显示状态栏 (默认值为 1, 无法显示状态栏)
	set statusline=%F%m%r,%Y,%{&fileformat}\ \ \ ASCII=\%b,HEX=\%B\ \ \ %l,%c%V\ %p%%\ \ \ [\ %L\ lines\ in\ all\ ]
		" " 设置在状态行显示的信息如下：  %F 当前文件名;%m 当前文件修改状态;%r当前文件是否只读;%Y 当前文件类型
		" " %{&fileformat};当前文件编码;%b 当前光标处字符的 ASCII 码值;%B 当前光标处字符的十六进制值;%l 当前光标行号
		" " %c 当前光标列号;%V 当前光标虚拟列号 (根据字符所占字节数计算);%p
		" 当前行占总行数的百分比; %% 百分号; %L 当前文件总行数
"=================================================
" " 自动命令
	autocmd BufReadPost * cd %:p:h " 读文件时自动设定当前目录为刚读入文件所在的目录
	autocmd BufNewFile *.[ch],*.sh,*.cpp,*.java exec "call SetTitle()"
	"添加文件信息autocmd FileType text"是一个自动命令。它所定义的是每当文件类型被设置为"text"时就自动执行它后面的命令。新建.c.h.sh.cpp.java 自动插入文件头
	autocmd BufNewFile * normal G$
	"新建文件后，自动到文件末尾
	autocmd BufWrite *.java exec call DateInsert()
	autocmd FileType txt text setlocal textwidth=70 " 普通文件自动断行
	autocmd BufEnter * lcd %:p:h
	autocmd FileType c,cpp set shiftwidth=4 " 设定 << 和 >> 命令移动时的宽度为 4
"使用cscope支持
	let Tlist_Exit_OnlyWindow=1	"如果taglist窗口为最后一个窗口则退出
	let Tlist_Use_Right_Window=1 "在右侧窗口显示taglist
	let Tlist_Auto_Open=1	"默认打开Taglist
"键盘映射
let mapleader=","
	nmap <silent> <leader>ss :source $HOME/.vimrc	
	nmap <silent> <leader>ee :e $HOME/.vimrc
	map \p i(<Esc>ea)<Esc>
	nmap <F12> :%s,\s\+$,,g<CR>
	map <S-t> :tabnew .<CR>
	map <S-t><S-t> <ESC>:tabnext<CR>
	nmap <F9> <c-w>w
	"imap <F9> <Esc><F9> 
	"F9映射ctrl+w 切换窗口
	"Shift+t为新建一个标签，按两次Shirt+t为跳转标签
"map <F8> :NERDTreeToggle<CR>
"map <F5> i{<Esc{>ea}<Esc>
"设置运行F5调试快捷键
		nmap <F5> :call CompileRun()<CR>
		nmap <C-F5> :call Debug()<CR>
	"设置TAB操作的快捷键，绑定:tabnew到<leader>t :tabn,
	":tabp-><leader>n,"<leader>p
	"	map <leader>t :tabnew<CR>
	"	map <leader>n :tabn<CR>
	"	map <leader>p :tabp<CR>

	iab /** /<Esc>75a*<Esc>o<Esc>0c$ * <Esc>yyAFile NAME: <C-R>=expand("%t")<CR><Esc>pADescription:<Esc>pmxpAAuthor : wwx<Esc>pALanguage: C<Esc>pADate : <C-R>=strftime("%Y-%m-%d")<CR><Esc>p$r/74i*<Esc>0vyo<Esc>i
"
	"iab #i #include <<Esc>mxa><Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab #d #define
	"用a方式添加75个*-------------<Esc>75a*<Esc> 
	"e将光标移动到当前word的最后，a在word后加
 " " JAVA 关键字
	"iab im import ;<esc>i
	"iab pbc public class (){<Esc>o<tab>System.<Esc>o} 
 " " C 关键字
	"iab if( if (<Esc>mxa)<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab el{ else<CR>{<Esc>mxa<CR>}<Esc>`xa<CR><C-R>=Eatchar('\s')<CR>
	"iab ie( if (<Esc>mxa)<CR>{<CR>}<CR>else<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab fo( for (<Esc>mxa; ; )<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab fi( for (i = 0; i < <Esc>mxa;++i)<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab fi1( for (i = 1; i <= <Esc>mxa;++i)<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab fj( for (j = 0; j < <Esc>mxa;++j)<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab fj1( for (j = 1; j <= <Esc>mxa;++j)<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab ma( int main(int argc, char *argv[])<CR>{<Esc>mxa<CR>}<Esc>`xa<CR><CR>return 0;<Esc>`xa<CR><C-R>=Eatchar('\s'	"	"	")<CR>
	"iab wh( while (<Esc>mxa)<CR>{<CR>}<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab sw( switch (<Esc>mxa)<CR>{<CR>case <Esc>mya<CR>break;<CR>case<Esc>mza<CR>break;:<Esc>xa<CR>}<Esc>`yp`zp`xa<C-R>=Eatchar('\s')<CR>
	"iab sd( switch (<Esc>mxa)<CR>{<CR>case <Esc>mya<CR>break;<CR>case<Esc>mza<CR>break;<CR>default:<Esc>vya<CR>}<Esc>`yp`zp`xa<C-R>=Eatchar('\s')<CR>
 " " C 常用函数
	"iab sc( scanf("<Esc>mxa", );<Esc>`xa<C-R>=/Eatchar('\s')<CR>
	"iab fs( fscanf(<Esc>mxa, "", );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab ss( sscanf(<Esc>mxa, "", );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab pr( printf("<Esc>mxa", );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab prn( printf("<Esc>mxa\n");<Esc>`x<C-R>=Eatchar('\s')<CR>
	"iab fp( fprintf(<Esc>mxa, "", );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab sp( sprintf(<Esc>mxa, "", );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab cpy( strcpy(<Esc>mxa, );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab cat( strcat(<Esc>mxa, );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab len( strlen(<Esc>mxa);<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab cmp( strcmp(<Esc>mxa, );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab qs( qsort(<Esc>mxa, , , );<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab co cout << <Esc>mxa << endl;<Esc>`xa<C-R>=Eatchar('\s')<CR>
	"iab --- <Esc>75A-<Esc>a<C-R>=Eatchar('\s')<CR>
	"cab tn tabnew
"make `functions <c-o>in
inoremap ` <c-o>
nnoremap ` i`<esc>
vnoremap . :normal .<CR>
map <C-F10> :NERDTreeToggle<CR>
"""""""""""""""""""""""""""""""""""""
"
" => Plugin configuration
"
"""""""""""""""""""""""""""""""""""""
"
"taglist
"=====================================
	let Tlist_Auto_Highlight_Tag = 1
	let Tlist_Auto_Open = 1 
	let Tlist_Auto_Update = 1
	let Tlist_Close_On_Select = 0
	let Tlist_Compact_Format = 0
	let Tlist_Display_Prototype = 0
	let Tlist_Display_Tag_Scope = 1
	let Tlist_Enable_Fold_Column = 0
	let Tlist_Exit_OnlyWindow = 1  "如果taglist是最后一个窗口则退出
	let Tlist_File_Fold_Auto_Close = 0
	let	Tlist_GainFocus_On_ToggleOpen = 1
	let Tlist_Hightlight_Tag_On_BufEnter = 1
	let Tlist_Inc_Winwidth = 0
	let Tlist_Max_Submenu_Items = 1
	let Tlist_Max_Tag_Length = 30
	let Tlist_Process_File_Always = 0
	let Tlist_Show_Menu = 0
	let Tlist_Show_One_File = 1	"不同时显示多个文件的tag,只显示当前文件的
	let Tlist_Use_Right_Window = 1
	let Tlist_WinWidth = 30
	let tlist_php_settings = 'php;c:class;i:interfaces;d:constant;f:function'
"=====================================
"authorinfo.vim
"=====================================
	let g:vimrc_author='wwx'
	let g:vimrc_email='wwx_2012@hotmail.com'
	let g:vimrc_homepage='http://chenai...'
	nmap <F6> :AuthorInfoDetect<cr>
"=====================================
"	
"NERDtree
"
"=====================================
	"let loaded_nerd_tree=1
	"nmap <silent><leader>tto:NERDTreeToggle<cr>
	"let NERDTreeIgnore=['/.vim$','/~$']
	let NERDTreeShowHidden=1
	let NERDtreeSortOrder=['//$','/.java$','/.cpp$','/.h$','*']
	"let NERDTreeCaseSensitiveSort=0
	"let NERDTreeWinSize=30
"======================================
"netrew setting
"""""""""""""""""""""""""""""""""""""""
	let g:netrw_winsize = 30
	nmap <silent> <leader>fe :Sexplore!<cr>
"""""""""""""""""""""""""""""""""""""""
"======================================
"winManager setting
"======================================
	let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
	let g:winManagerWidth = 30
	let g:defaultExplorer = 0
	nmap <C-W><C-F> :FirstExplorerWindow<cr>
	nmap <C-W><C-B> :BottomExplorerWindow<cr>
	nmap <silent> <leader>wm :WMToggle<cr>
"=========================================
"JavaBrowser
"=========================================
set tags=~/.tags;
set autochdir
"定义ComplieRun
	func CompileRun()
		exec "w"
		if &filetype=='c'
			exec "!gcc % -g -o %<.exe"
			exec "!%<.exe"
		elseif &filetype=='cpp'
			exec "!gcc % -g -o %<.exe"
			exec "!%<.exe"
		elseif &filetype=='java'
			exec "!javac %"
			exec "!java %<"
		endif
	endfu
"定义Debug()
	func Debug()
		exec "w"
		if &filetype=='c'
			exec "!gcc % -g -o <.exe"
			exec "!gdb %<.exe"
		elseif &filetype=='cpp'
			exec "!gcc % -g -o <.exe"
			exec "!gdb %<.exe"
		elseif &filetype=='java'
			exec "!javac %"
			exec "!jdb %<"
		endif
	endfunc
"settitle
	func SetTitle()
		call setline(1,"//###################################################################################")
		call append(line("."),"//#File Name:".expand("%"))
		call append(line(".")+1,"//#Description:")
		call append(line(".")+2,"//#author:wwx")
		call append(line(".")+3,"//#Create time:".strftime("%c"))
		call append(line(".")+4,"//###########################################################################")
		if &filetype=='c'
			call append(line(".")+6,"#include<stdio.h>)
		elseif &filetype=='cpp'

		elseif &filetype=='java'
			
		endif
	endfunc
"DateInsert函数
	function DateInsert()	
		call append(5,"//#Create time:")
	endfunction
"SwitchToBuf
	function! SwitchToBuf(filename)
		"let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
		" find in current tab
		let bufwinnr = bufwinnr(a:filename)
		if bufwinnr != -1
			exec bufwinnr . "wincmd w"
			return
		else
			" find in each tab
			tabfirst
		let tab = 1
		while tab <= tabpagenr("$")
			let bufwinnr = bufwinnr(a:filename)
			if bufwinnr != -1
				exec "normal " . tab . "gt"
				exec bufwinnr . "wincmd w"
				return
			endif
			tabnext
			let tab = tab + 1
		endwhile
		" not exist, new tab
		exec "tabnew " . a:filename
		endif
	endfunction
	if MySys() == 'linux'
		map <silent> <leader>ss :source ~/.vimrc<cr>
		map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
		autocmd! bufwritepost .vimrc source ~/.vimrc
	elseif MySys() == 'windows'
		set helplang=cn
		map <silent> <leader>ss :source ~/_vimrc<cr>
		map <silent> <leader>ee :call SwitchToBuf("~/_vimrc")<cr>
		autocmd! bufwritepost _vimrc source ~/_vimrc
		source $VIMRUNTIME/mswin.vim
		behave mswin
	endif




""""""""""""""""""""""""""""""""""""'''''
"tab键位冲突
    let g:completekey = "<tab><j>"   "hotkey
	"设置java代码的自动补全
	autocmd FileType java setlocal omnifunc=javacomplete#Complete
	"绑定自动补全的快捷键<C-X>  <C-X>到<leader>
	inoremap <buffer> <C-H> <C-X><C-U><C-P>
	inoremap <buffer> <C-S-Space> <C-X><C-U><C-P>

" for vimwiki
autocmd Filetype vimwiki ab hl {{{class="brush:python"}}}
autocmd Filetype vimwiki ab tab <div id=""></div>
autocmd Filetype vimwiki ab jump <a href="#"> </a>
autocmd Filetype vimwiki ab \n </br>
autocmd Filetype vimwiki ab pi {{../picture/.png\|\|title=""}}
autocmd Filetype vimwiki ab do _//todo_
autocmd Filetype vimwiki ab fi _//tofinish_
autocmd Filetype vimwiki nmap <Leader>bd 0i*<ESC>A*<ESC>
autocmd BufWritePre 2013-*.wiki  :call WikiDateInsert()
" for bash shell
autocmd BufNewFile *.sh 0r ~/.vim/templates/header.sh | $
let wiki = {}
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
let g:vimwiki_camel_case = 0   "don't take the CamelCasedWords as a new wiki
let g:vimwiki_list = [{
			\ 'path' : '~/wiki/cs_wiki/',
			\ 'path_html' : '~/Documents/wiki_html/cs_html/',
			\ 'template_path': '~/.vim/templates/',
			\ 'template_default': 'default',
			\ 'template_ext': '.tpl',
			\ 'auto_export' : 0},
			\{
			\ 'path' : '~/wiki/life_wiki/',
			\ 'path_html' : '~/Documents/wiki_html/life_html/',
			\ 'template_path': '~/.vim/templates/',
			\ 'template_default': 'default',
			\ 'template_ext': '.tpl',
			\ 'auto_export' : 0},
			\{
			\ 'path' : '~/wiki/original_wiki/',
			\ 'path_html' : '~/Documents/wiki_html/original_html/',
			\ 'template_path': '~/.vim/templates/',
			\ 'template_default': 'default',
			\ 'template_ext': '.tpl',
			\ 'auto_export' : 0},
			\{
			\ 'path' : '~/wiki/',
			\ 'path_html' : '~/Documents/wiki_html/',
			\ 'template_path': '~/.vim/templates/',
			\ 'template_default': 'main',
			\ 'template_ext': '.tpl',
			\ 'auto_export' : 0}]
let g:vimwiki_valid_html_tags='a,br,blockquote,div,span'
let g:vimwiki_folding=1
let g:vimwiki_hl_headers=1
let g:vimwiki_auto_checkbox=1
let g:vimwiki_ext2syntax = {}
let g:vimwiki_CJK_length = 1
" 对中文用户来说，我们并不怎么需要驼峰英文成为维基词条
let g:vimwiki_camel_case = 0
"let g:vimwiki_hl_cb_checked = 1
"let g:vimwiki_menu = ''
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,h1'

map <leader>wsg :exec 'silent !cmd.exe /k "cd "'.VimwikiGet('path').'" & sync"'<cr>
map <leader>wsh :exec 'silent !cmd.exe /k "cd "'.VimwikiGet('path_html').'" & sync"'<cr>

au BufNewFile,BufRead *.wiki exe 'AcpLock' | setlocal fenc=utf-8

" plugin end }}}
map <F4> :Vimwiki2HTML<cr>
map <leader><F4> :VimwikiAll2HTML<cr>


" For vundle
set nocompatible               " be iMproved
 filetype off                   " required!

 set rtp+=~/.vim/bundle/vundle/
 call vundle#rc()

 " let Vundle manage Vundle
 " required! 
 Bundle 'gmarik/vundle'
 Bundle 'othree/xml.vim'
 " My Bundles here:
 "
 " original repos on github
 Bundle 'vimwiki'
 Bundle 'tpope/vim-fugitive'
 Bundle 'Lokaltog/vim-easymotion'
 Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
 Bundle 'tpope/vim-rails.git'
 Bundle 'othree/html5.vim'
 " vim-scripts repos
 Bundle 'jQuery'
 "Bundle 'L9'
 "Bundle 'FuzzyFinder'
 " non github repos
 Bundle 'git://git.wincent.com/command-t.git'
 " git repos on your local machine (ie. when working on your own plugin)
 " Bundle 'file:///home/wwx/.vim/bkplugin/calendar'
 Bundle 'git@10.0.3.186:wwx/calendar-vim.git'
 " ...

 filetype plugin indent on     " required!
 "
 " Brief help
 " :BundleList          - list configured bundles
 " :BundleInstall(!)    - install(update) bundles
 " :BundleSearch(!) foo - search(or refresh cache first) for foo
 " :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
 "
 " see :h vundle for more details or wiki for FAQ
 " NOTE: comments after Bundle command are not allowed..
" For calendar
map <silent> <F8> :if &buftype == 'nofile' <bar> exe 'q' <bar> else <bar> exe 'Calendar' <bar> endif<cr>
" 重启后撤销历史可用 persistent undo 
 set undofile
 set undodir=$VIMFILES/\_undodir
 set undolevels=1000 "maximum number of changes that can be undone
 autocmd BufWinLeave * if expand('%') != '' && &buftype == '' | mkview | endif
 autocmd BufRead     * if expand('%') != '' && &buftype == '' | silent loadview | syntax on | endif
 nmap <leader>.cl :call RemoveOldViewFiles<cr
 
 " Session files Vim关闭时保存会话状态
 set sessionoptions+=unix
 set sessionoptions-=blank
 "set sessionoptions-=options
 autocmd VimEnter * call LoadSession()
 autocmd VimLeave * call MakeSession() 
" xml格式化
" 状态行
	set showcmd " 在状态栏显示目前所执行的指令，未完成的指令片段亦会显示出来
