colorscheme peachpuff
setlocal omnifunc=syntaxcomplete#Complete
set wildmenu
set wildmode=longest:full,full
set backupdir=C:/tmp
set directory=./
set backup              " keep a backup file
set backupext=.bak
set patchmode=.ori
set nu
set ruler               " show the cursor position all the time
set noshowcmd           " display incomplete commands
set incsearch           " do incremental searching
set ai
set smartindent
set smarttab
set showmatch
set matchtime=3
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set encoding=utf-8
set gfw=MS_Gothic:h14:b
set scrolloff=2
filetype on

" settings for Latex-Suite
set shellslash
set grepprg=grep\ -nH\ $*



" Wu Yongwei's _vimrc for Vim 7
" Last Change: 2015-03-14 21:36:33 +0800

if v:version < 700
  echoerr 'This _vimrc requires Vim 7 or later.'
  quit
endif

if has('autocmd')
  " Remove ALL autocommands for the current group
  au!
endif

if has('gui_running')
  " Always show file types in menu
  let do_syntax_sel_menu=1
endif

if has('multi_byte')
  " Legacy encoding is the system default encoding
  let legacy_encoding=&encoding
endif

if has('gui_running') && has('multi_byte')
  " Set encoding (and possibly fileencodings)
  if $LANG !~ '\.' || $LANG =~? '\.UTF-8$'
    set encoding=utf-8
  else
    let &encoding=matchstr($LANG, '\.\zs.*')
    let &fileencodings='ucs-bom,utf-8,' . &encoding
    let legacy_encoding=&encoding
  endif
endif

set nocompatible
source $VIMRUNTIME/vimrc_example.vim
if has('xx') && has('gui_running')
  source $VIMRUNTIME/mswin.vim
  unmap  <C-Y>|             " <C-Y> for Redo is kept in insert mode
  iunmap <C-A>|             " <C-A> for Select-All is kept in normal mode
  " Key mapping to switch windows quickly (<C-Tab> is already mapped)
  nnoremap <C-S-Tab> <C-W>W
  inoremap <C-S-Tab> <C-O><C-W>W
endif

set autoindent
set nobackup
set formatoptions+=mM
set fileencodings=ucs-bom,utf-8,default,latin1          " default value
set grepprg=grep\ -nH
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set dictionary+=~\vimfiles\words
set tags+=~\vimfiles\systags                            " help ft-c-omni
set directory=~\AppData\Local\Temp
set path=.,
        \,

if has("directx") && $VIM_USE_DIRECTX != '0'
  set renderoptions=type:directx
  let s:use_directx=1
endif

" Personal setting for working with Windows (requires tee in path)
if &shell =~? 'cmd'
  "set shellxquote=\"
  set shellpipe=2>&1\|\ tee
endif

" Quote shell if it contains space and is not quoted
if &shell =~? '^[^"].* .*[^"]'
  let &shell='"' . &shell . '"'
endif

" Set British spelling convention for International English
if has('syntax')
  set spelllang=en_us
endif

" Use persistent undo
if has('persistent_undo')
  set undodir=~\AppData\Local\Temp\vim_undo_files
  set undofile
endif

if has('eval')
  " Function to find the absolute path of a runtime file
  function! FindRuntimeFile(filename, ...)
    if a:0 != 0 && a:1 =~ 'w'
      let require_writable=1
    else
      let require_writable=0
    endif
    let runtimepaths=&runtimepath . ','
    while strlen(runtimepaths) != 0
      let filepath=substitute(runtimepaths, ',.*', '', '') . '/' . a:filename
      if filereadable(filepath)
        if !require_writable || filewritable(filepath)
          return filepath
        endif
      endif
      let runtimepaths=substitute(runtimepaths, '[^,]*,', '', '')
    endwhile
    return ''
  endfunction

  " Function to display the current character code in its 'file encoding'
  function! EchoCharCode()
    let char_enc=matchstr(getline('.'), '.', col('.') - 1)
    let char_fenc=iconv(char_enc, &encoding, &fileencoding)
    let i=0
    let len=len(char_fenc)
    let hex_code=''
    while i < len
      let hex_code.=printf('%.2x',char2nr(char_fenc[i]))
      let i+=1
    endwhile
    echo '<' . char_enc . '> Hex ' . hex_code . ' (' .
          \(&fileencoding != '' ? &fileencoding : &encoding) . ')'
  endfunction

  " Key mapping to display the current character in its 'file encoding'
  nnoremap <silent> gn :call EchoCharCode()<CR>

  " Function to switch the cursor position between the first column and the
  " first non-blank column
  function! GoToFirstNonBlankOrFirstColumn()
    let cur_col=col('.')
    normal! ^
    if cur_col != 1 && cur_col == col('.')
      normal! 0
    endif
    return ''
  endfunction

  " Key mappings to make Home go to first non-blank column or first column
  nnoremap <silent> <Home> :call GoToFirstNonBlankOrFirstColumn()<CR>
  inoremap <silent> <Home> <C-R>=GoToFirstNonBlankOrFirstColumn()<CR>

  " Function to insert the current date
  function! InsertCurrentDate()
    let curr_date=strftime('%Y-%m-%d', localtime())
    return curr_date
  endfunction

  " Key mapping to insert the current date
  inoremap <silent> <C-\><C-D> <C-R>=InsertCurrentDate()<CR>
endif

" Key mappings to ease browsing long lines
noremap  <C-J>         gj
noremap  <C-K>         gk
inoremap <M-Home> <C-O>g0
inoremap <M-End>  <C-O>g$

" Key mappings for quick arithmetic inside Vim (requires a calcu in path)
nnoremap <silent> <Leader>ma yypV:!calcu <C-R>"<CR>k$
vnoremap <silent> <Leader>ma yo<Esc>pV:!calcu <C-R>"<CR>k$
nnoremap <silent> <Leader>mr yyV:!calcu <C-R>"<CR>$
vnoremap <silent> <Leader>mr ygvmaomb:r !calcu <C-R>"<CR>"ay$dd`bv`a"ap

" Key mappings for indenting
xnoremap < <gv
xnoremap > >gv

" Key mapping for quick substitution
nmap S :%s//g<Left><Left>
xmap S :s//g<Left><Left>

" Key mapping for confirmed exiting
nnoremap ZX :confirm qa<CR>

" Key mapping for opening the clipboard (Vim script #1014) to avoid
" conflict with the NERD Commenter (Vim script #1218)
nmap <unique> <silent> <Leader>co <Plug>ClipBrdOpen

" Key mapping to stop the search highlight
nmap <silent> <F2>      :nohlsearch<CR>
imap <silent> <F2> <C-O>:nohlsearch<CR>

" Key mappings to fold line according to syntax
nmap <silent> <F3> :set fdl=1 fdm=syntax<bar>syn sync fromstart<CR>
nmap <C-F3>   zv
nmap <M-F3>   zc

" Key mapping to toggle the display of tabs and trailing spaces
nmap <silent> <F4> :if &list == 0<bar>
                     \exec "set listchars=tab:\uBB\u2014,trail:\uB7,nbsp:~"<bar>
                     \set list<bar>
                     \echo "Display of TAB and trailing SPACE turned on"<bar>
                   \else<bar>
                     \set nolist<bar>
                     \echo<bar>
                   \endif<CR>

" Key mapping to toggle the background
nmap <silent> <F5> :if &background == 'light'<bar>
                     \colorscheme bandit<bar>
                     \set background=dark<bar>
                     \echo<bar>
                   \else<bar>
                     \colorscheme default<bar>
                     \set background=light<bar>
                     \echo<bar>
                   \endif<CR>

" Key mapping to toggle the display of status line for the last window
nmap <silent> <F6> :if &laststatus == 1<bar>
                     \set laststatus=2<bar>
                     \echo<bar>
                   \else<bar>
                     \set laststatus=1<bar>
                   \endif<CR>

" Key mappings for quickfix commands, tags, and buffers
nmap <F11>   :cn<CR>
nmap <F12>   :cp<CR>
nmap <M-F11> :copen<CR>
nmap <M-F12> :cclose<CR>
nmap <C-F11> :tn<CR>
nmap <C-F12> :tp<CR>
nmap <S-F11> :n<CR>
nmap <S-F12> :prev<CR>



" Key mapping for the taglist.vim plug-in (Vim script #273)
nmap <F9>       :TlistToggle<CR>
nmap <S-F9> 		:TagbarToggle<CR>
imap <F9> <C-O> :TlistToggle<CR>

" Key mappings for Damian Conway's listtrans.vim
" <URL:https://docs.google.com/file/d/0Bx3f0gFZh5Jqc0MtcUstV3BKdTQ/>
nmap <Leader>l :call ListTrans_toggle_format()<CR>
vmap <Leader>l :call ListTrans_toggle_format('visual')<CR>

" Key mappings for Damian Conway's vmath.vim
" <URL:https://docs.google.com/file/d/0Bx3f0gFZh5Jqc0MtcUstV3BKdTQ/>
" Warning: One must remove the "gv" in his script, otherwise the result
"          cannot be displayed.
xmap <expr> ++ VMATH_YankAndAnalyse()
nmap        ++ vip++

" Key mappings for Damian Conway's dragvisuals.vim
" <URL:https://docs.google.com/file/d/0Bx3f0gFZh5Jqc0MtcUstV3BKdTQ/>
if has('xx') && has('gui_running')
  xmap <expr> <Left>  DVB_Drag('left')
  xmap <expr> <Right> DVB_Drag('right')
  xmap <expr> <Down>  DVB_Drag('down')
  xmap <expr> <Up>    DVB_Drag('up')
else
  xmap <expr> <S-Left>  DVB_Drag('left')
  xmap <expr> <S-Right> DVB_Drag('right')
  xmap <expr> <S-Down>  DVB_Drag('down')
  xmap <expr> <S-Up>    DVB_Drag('up')
endif

" Key mapping for clang-format
" <URL:http://clang.llvm.org/docs/ClangFormat.html>
function! UseClangFormat()
  map  <buffer> <silent> <Tab> :pyf C:/Program\ Files\ (x86)/LLVM/share/clang/clang-format.py<CR>
  imap <buffer> <silent> <C-F> <ESC>:pyf C:/Program\ Files\ (x86)/LLVM/share/clang/clang-format.py<CR>i
endfunction

" Function to turn each paragraph to a line (to work with, say, MS Word)
function! ParagraphToLine()
  normal! ma
  if &formatoptions =~ 'w'
    let reg_bak=@"
    normal! G$vy
    if @" =~ '\s'
      normal! o
    endif
    let @"=reg_bak
    silent! %s/\(\S\)$/\1\r/e
  else
    normal! Go
  endif
  silent! g/\S/,/^\s*$/j
  silent! %s/\s\+$//e
  normal! `a
endfunction

" Non-GUI setting
if !has('gui_running')
  " English messages only
  " language messages en
	set invspell
  " Do not increase the window width in the taglist.vim plugin
  if has('eval')
    let Tlist_Inc_Winwidth=0
  endif

  " Set text-mode menu
  if has('wildmenu')
    set wildmenu
    set cpoptions-=<
    set wildcharm=<C-Z>
    nmap <F10>      :emenu <C-Z>
    imap <F10> <C-O>:emenu <C-Z>
  endif

  " Change encoding according to the current console code page
  if &termencoding != '' && &termencoding != &encoding
    let &encoding=&termencoding
    let &fileencodings='ucs-bom,utf-8,' . &encoding
  endif
endif

" Display window width and height in GUI
if has('gui_running') && has('statusline')
  let &statusline=substitute(
                 \&statusline, '%=', '%=%{winwidth(0)}x%{winheight(0)}  ', '')
  set laststatus=2
endif

" Set up language and font in GUI
if has('gui_running') && has('multi_byte')
  function! UTF8_East()
    exec 'language messages ' . s:lang_east . '.UTF-8'
    set ambiwidth=double
    set encoding=utf-8
    let s:utf8_east_mode=1
  endfunction

  function! UTF8_West()
    exec 'language messages ' . s:lang_west . '.UTF-8'
    set ambiwidth=single
    set encoding=utf-8
    let s:utf8_east_mode=0
  endfunction

  function! UTF8_SwitchMode()
    if exists('b:utf8_east_mode')
      unlet b:utf8_east_mode
    endif
    if s:utf8_east_mode
      call UTF8_West()
      call UTF8_SetFont()
    else
      call UTF8_East()
      call UTF8_SetFont()
    endif
  endfunction

  function! UTF8_SetFont()
    if &encoding != 'utf-8'
      return
    endif
    if &fileencoding == 'cp936' ||
          \&fileencoding == 'gbk' ||
          \&fileencoding == 'euc-cn'
      let s:font_east=s:font_schinese
    elseif &fileencoding == 'cp950' ||
          \&fileencoding == 'big5' ||
          \&fileencoding == 'euc-tw'
      let s:font_east=s:font_tchinese
    elseif &fileencoding == 'cp932' ||
          \&fileencoding == 'sjis' ||
          \&fileencoding == 'euc-jp'
      let s:font_east=s:font_japanese
    elseif &fileencoding == 'cp949' ||
          \&fileencoding == 'euc-kr'
      let s:font_east=s:font_korean
    endif
    if !exists('s:use_directx') && (
          \(g:legacy_encoding == 'cp936' && s:font_east == s:font_schinese) ||
          \(g:legacy_encoding == 'cp950' && s:font_east == s:font_tchinese) ||
          \(g:legacy_encoding == 'cp932' && s:font_east == s:font_japanese) ||
          \(g:legacy_encoding == 'cp949' && s:font_east == s:font_korean))
      " The system default (bitmap) font, FixedSys, can display ASCII
      " characters slightly better than the Far East fonts.  However,
      " when DirectX is enabled, only TrueType fonts can be used, the
      " automatic font mapping is not quite predictable, and the result
      " looks small and bad to me.  So we will stick to the Far East
      " font then.
      let s:font_east=''
    endif
    if exists('b:utf8_east_mode') && s:utf8_east_mode != b:utf8_east_mode
      let s:utf8_east_mode=b:utf8_east_mode
      let &ambiwidth=(s:utf8_east_mode ? 'double' : 'single')
    endif
    if s:utf8_east_mode
      exec 'set guifont=' . s:font_east
      set guifontwide=
    else
      exec 'set guifont=' . s:font_west
      exec 'set guifontwide=' . s:font_east
    endif
  endfunction

  function! UTF8_CheckAndSetFont()
    if &fileencoding == 'cp936' ||
          \&fileencoding == 'gbk' ||
          \&fileencoding == 'euc-cn' ||
          \&fileencoding == 'cp950' ||
          \&fileencoding == 'big5' ||
          \&fileencoding == 'euc-tw' ||
          \&fileencoding == 'cp932' ||
          \&fileencoding == 'sjis' ||
          \&fileencoding == 'euc-jp' ||
          \&fileencoding == 'cp949' ||
          \&fileencoding == 'euc-kr'
      let b:utf8_east_mode=1
    elseif &fileencoding == 'latin1' ||
          \&fileencoding =~ 'iso-8859-.*' ||
          \&fileencoding =~ 'koi8-.' ||
          \&fileencoding == 'macroman' ||
          \&fileencoding == 'cp437' ||
          \&fileencoding == 'cp850' ||
          \&fileencoding =~ 'cp125.'
      let b:utf8_east_mode=0
    endif
    if exists('b:utf8_east_mode') &&
          \(b:utf8_east_mode || (!b:utf8_east_mode && s:utf8_east_mode)) &&
          \((s:utf8_east_mode && &guifont == s:font_east) ||
          \(!s:utf8_east_mode && &guifont == s:font_west))
      call UTF8_SetFont()
    endif
  endfunction

  function UTF8_SwitchDejaVu()
    if s:font_west =~ '^Courier_New'
      let s:font_west='DejaVu_Sans_Mono:h14:cDEFAULT'
    else
      let s:font_west='MS_Gothic:h14:b'
    endif
    call UTF8_SetFont()
  endfunction

  " Rebuild the menu to make the translations display correctly
  " --------------------------------------------------------------------
  " Uncomment the following code if all of the following conditions
  " hold:
  "   1) Unicode support is wanted (enabled by default for gVim in this
  "      _vimrc);
  "   2) The libintl.dll shipped with gVim for Windows is not updated
  "      with a new one that supports encoding conversion (see also
  "      <URL:http://tinyurl.com/2hnwaq> for issues with this approach);
  "   3) The environment variable LANG is not manually set to something
  "      like "zh_CN.UTF-8", and the default language is not ASCII-based
  "      (English).
  " The reason why the code is not enabled by default is because it can
  " interfere with the localization of menus created by plug-ins.
  " --------------------------------------------------------------------
  "
  "if $LANG !~ '\.' && v:lang !~? '^\(C\|en\)\(_\|\.\|$\)'
  "  runtime! delmenu.vim
  "endif

  " Fonts
  let s:font_schinese='NSimSun:h14:b'
  let s:font_tchinese='MS_Gothic:h14:b'
  let s:font_japanese='MS_Gothic:h14:b'
  let s:font_korean='GulimChe:h14:cDEFAULT'
  if legacy_encoding == 'cp936'
    let s:font_east=s:font_schinese
  elseif legacy_encoding == 'cp950'
    let s:font_east=s:font_tchinese
  elseif legacy_encoding == 'cp932'
    let s:font_east=s:font_japanese
  elseif legacy_encoding == 'cp949'
    let s:font_east=s:font_korean
  else
    let s:font_east=s:font_schinese
  endif
  let s:font_west='Consolas:h14:b'

  " Extract the current Eastern/Western language settings
  if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
    let s:lang_east=matchstr(v:lang, '^[a-zA-Z_]*\ze\(\.\|$\)')
    let s:lang_west='en'
    let s:utf8_east_mode=1
    if v:lang=~? '^zh_TW'
      let s:font_east=s:font_tchinese
    elseif v:lang=~? '^ja'
      let s:font_east=s:font_japanese
    elseif v:lang=~? '^ko'
      let s:font_east=s:font_korean
    endif
  else
    let s:lang_east='zh_CN'
    let s:lang_west=matchstr(v:lang, '^[a-zA-Z_]*\ze\(\.\|$\)')
    let s:utf8_east_mode=0
  endif

  " Set a suitable GUI font and the ambiwidth option
  if &encoding == 'utf-8'
    if s:utf8_east_mode
      call UTF8_East()
    else
      call UTF8_West()
    endif
  elseif s:utf8_east_mode
    exec 'set guifont=' . s:font_east
  else
    exec 'set guifont=' . s:font_west
  endif
  call UTF8_SetFont()

  " Key mapping to switch the Eastern/Western UTF-8 mode
  nmap <F8>      :call UTF8_SwitchMode()<CR>
  imap <F8> <C-O>:call UTF8_SwitchMode()<CR>

  " Key mapping to switch the use of DejaVu Sans Mono
  nmap <C-F8>      :call UTF8_SwitchDejaVu()<CR>
  imap <C-F8> <C-O>:call UTF8_SwitchDejaVu()<CR>

  if has('autocmd')
    " Set the appropriate GUI font according to the fileencoding, but
    " not if user has manually changed it
    au BufWinEnter,WinEnter * call UTF8_CheckAndSetFont()
  endif
endif

" Key mapping to toggle spelling check
if has('syntax')
  nmap <silent> <F7>      :setlocal spell!<CR>
  imap <silent> <F7> <C-O>:setlocal spell!<CR>
  let spellfile_path=FindRuntimeFile('spell/en.' . &encoding . '.add', 'w')
  if spellfile_path != ''
    exec 'nmap <M-F7> :sp ' . spellfile_path . '<CR><bar><C-W>_'
  endif
endif

" Common abbreviations
iabbrev Br      Best regards,
iabbrev Btw     By the way,
iabbrev Yw      Yongwei

if has('autocmd')
  function! Timezone()
    if has('python')
python << EOF

import time

def my_timezone():
    is_dst = time.daylight and time.localtime().tm_isdst
    offset = time.altzone if is_dst else time.timezone
    (hours, seconds) = divmod(abs(offset), 3600)
    if offset > 0: hours = -hours
    minutes = seconds // 60
    return '{:+03d}{:02d}'.format(hours, minutes)

EOF
      return ' ' . pyeval('my_timezone()')
    else
      return ''
    endif
  endfunction

  function! SetFileEncodings(encodings)
    let b:my_fileencodings_bak=&fileencodings
    let &fileencodings=a:encodings
  endfunction

  function! RestoreFileEncodings()
    let &fileencodings=b:my_fileencodings_bak
    unlet b:my_fileencodings_bak
  endfunction

  function! GnuIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
  endfunction

  function! UpdateLastChangeTime()
    let last_change_anchor='^\(" Last Change:\s\+\)\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}\( [-+]\d\{4}\)\?'
    let last_change_line=search(last_change_anchor, 'n')
    if last_change_line != 0
      let last_change_time=strftime('%Y-%m-%d %H:%M:%S', localtime())
      let last_change_text=substitute(getline(last_change_line), last_change_anchor, '\1', '') . last_change_time . Timezone()
      call setline(last_change_line, last_change_text)
    endif
  endfunction

  function! RemoveTrailingSpace()
    if $VIM_HATE_SPACE_ERRORS != '0' &&
          \(&filetype == 'c' || &filetype == 'cpp' || &filetype == 'vim')
      normal! m`
      silent! :%s/\s\+$//e
      normal! ``
    endif
  endfunction

  " Set default file encodings to the legacy encoding
  "exec 'set fileencoding=' . legacy_encoding
  if legacy_encoding != 'latin1'
    let &fileencodings=substitute(
                      \&fileencodings, '\<default\>', legacy_encoding, '')
  else
    let &fileencodings=substitute(
                      \&fileencodings, ',default,', ',', '')
  endif

  " Use Google Chrome as the browser (Vim script #293)
  " let utl_rc_app_browser = 'silent !start ' . glob('~') . '\Local Settings\Application Data\Google\Chrome\Application\chrome.exe %u'

  " Set the directory to store _vim_mru_files (Vim script #521)
  let MRU_File=$HOME . '\_vim_mru_files'
  " And exclude the temporary files from being saved
  let MRU_Exclude_Files='\\itsalltext\\.*\|\\temp\\.*'

  " Use the legacy encoding for calling system() in VimExplorer
  let VEConf_systemEncoding=legacy_encoding

  " Use the legacy encoding for CVS in cvsmenu (Vim script #1245)
  let CVScmdencoding=legacy_encoding
  " but the encoding of files in CVS is still UTF-8
  let CVSfileencoding='utf-8'

  " Use C++11 mode for clang-complete (Vim script #3302)
  let clang_user_options='-std=c++11'

  " Use automatic encoding detection (Vim script #1708)
  let $FENCVIEW_TELLENC='tellenc'       " See <URL:http://wyw.dcweb.cn/>
  let fencview_autodetect=1
  let fencview_auto_patterns='*.c,*.cpp,*.cs,*.h,*.log,*.txt,*.tex,'
                           \.'*.vim,*.htm{l\=},*.asp,'
                           \.'README,CHANGES,INSTALL'
  let fencview_html_filetypes='html,aspvbs'

  " File types to use function echoing (Vim script #1735)
  let EchoFuncLangsUsed=['c', 'cpp']

  " Use the standard Leader key
  let NERDMapleader='<Leader>c'
  " Do not use menu for NERD Commenter
  let NERDMenuMode=0
  " Prevent NERD Commenter from complaining about unknown file types
  let NERDShutUp=1

  " Highlight space errors in C/C++ source files (Vim tip #935)
  if $VIM_HATE_SPACE_ERRORS != '0'
    let c_space_errors=1
  endif

  " Tune for C highlighting
  let c_gnu=1
  let c_no_curly_error=1

  " Load doxygen syntax file for c/cpp/idl files
  let load_doxygen_syntax=1

  " Use Bitstream Vera Sans Mono as special code font in doxygen, which
  " is available at
  " <URL:http://ftp.gnome.org/pub/GNOME/sources/ttf-bitstream-vera/1.10/>
  let doxygen_use_bitsream_vera=1

  " Let TOhtml output <PRE> and style sheet
  let html_use_css=1

  " Show syntax highlighting attributes of character under cursor (Vim
  " script #383)
  map <Leader>a :call SyntaxAttr()<CR>

  " Automatically find scripts in the autoload directory
  "au FuncUndefined Syn* exec 'runtime autoload/' . expand('<afile>') . '.vim'

  " File type related autosetting
  au FileType c,cpp      call UseClangFormat()|
       \setlocal expandtab cinoptions=:0,g0 shiftwidth=4 softtabstop=4 tabstop=4
  au FileType cs         setlocal expandtab shiftwidth=4 softtabstop=4
  au FileType python     setlocal expandtab shiftwidth=4 softtabstop=4
  au FileType diff       setlocal shiftwidth=4 tabstop=4
  au FileType changelog  setlocal textwidth=76
  au FileType cvs        setlocal textwidth=72
  au FileType html,xhtml setlocal indentexpr=
  au FileType mail       setlocal expandtab softtabstop=2 textwidth=70 comments+=fb:* comments-=mb:*

  " Detect file encoding based on file type
  au BufReadPre  *.gb               call SetFileEncodings('cp936')
  au BufReadPre  *.big5             call SetFileEncodings('cp950')
  au BufReadPre  *.nfo              call SetFileEncodings('cp437')
  au BufReadPost *.gb,*.big5,*.nfo  call RestoreFileEncodings()

  " Quickly exiting help files
  au BufRead *.txt      if &buftype=='help'|nmap <buffer> q <C-W>c|endif

  " Setting for files following the GNU coding standard
  au BufEnter C:/mingw*             call GnuIndent()

  " Automatically update change time
  au BufWritePre *vimrc,*.vim       call UpdateLastChangeTime()

  " Remove trailing spaces for C/C++ and Vim files
  au BufWritePre *                  call RemoveTrailingSpace()
endif

" folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "do not fold by default

" auto complete matching brackets
inoremap {{ {<CR>}<Esc>ko
inoremap ( ()<Esc>i
inoremap [ []<Esc>i

" select text when user matches braces
noremap % v%

" highlight matching parentheses
hi MatchParen ctermbg=blue guibg=lightblue

" highlight the row and column at cursor
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" remove tailing white-spaces on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

" add file types manually to avoid accidence
autocmd FileType javascript,java,scala,php,html,python,bash,perl autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" for TagBar plug-in
nmap <F12> :TagbarToggle<CR>

" for Tern plug-in
let $PATH = 'C:\Python279;' . $PATH

set nospell

execute pathogen#infect()
