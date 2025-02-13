" Vim filetype plugin file
"
"   Language :  Perl
"     Plugin :  perl-support.vim
" Maintainer :  Fritz Mehner <mehner@fh-swf.de>
"   Revision :  $Id: perl.vim,v 1.65 2010/04/28 19:10:13 mehner Exp $
"
" ----------------------------------------------------------------------------
"
" Only do this when not done yet for this buffer
"
if exists("b:did_PERL_ftplugin")
  finish
endif
let b:did_PERL_ftplugin = 1
"
let s:UNIX  = has("unix") || has("macunix") || has("win32unix")
let s:MSWIN = has("win16") || has("win32")   || has("win64")    || has("win95")
"
" ---------- tabulator / shiftwidth ------------------------------------------
"  Set tabulator and shift width to 4 conforming to the Perl Style Guide.
"  Uncomment the next two lines to force these settings for all files with
"  filetype 'perl' .
"
setlocal  softtabstop=4
setlocal  shiftwidth=4
"
" ---------- Add ':' to the keyword characters -------------------------------
"            Tokens like 'File::Find' are recognized as
"            one keyword
"
setlocal iskeyword+=:
"
" ---------- Do we have a mapleader other than '\' ? ------------
"
if exists("g:Perl_MapLeader")
  let maplocalleader  = g:Perl_MapLeader
endif
"
" ---------- Perl dictionary -------------------------------------------------
" This will enable keyword completion for Perl
" using Vim's dictionary feature |i_CTRL-X_CTRL-K|.
"
if exists("g:Perl_Dictionary_File")
  let save=&dictionary
  silent! exe 'setlocal dictionary='.g:Perl_Dictionary_File
  silent! exe 'setlocal dictionary+='.save
endif
"
" ---------- commands --------------------------------------------------
"
command! -nargs=? CriticOptions         call Perl_PerlCriticOptions  (<f-args>)
command! -nargs=1 -complete=customlist,Perl_PerlCriticSeverityList   CriticSeverity   call Perl_PerlCriticSeverity (<f-args>)
command! -nargs=1 -complete=customlist,Perl_PerlCriticVerbosityList  CriticVerbosity  call Perl_PerlCriticVerbosity(<f-args>)
command! -nargs=1 RegexSubstitutions    call perlsupportregex#Perl_PerlRegexSubstitutions(<f-args>)
"
"command! -nargs=1 RegexCodeEvaluation    call Perl_RegexCodeEvaluation(<f-args>)
"
command! -nargs=1 -complete=customlist,perlsupportprofiling#Perl_SmallProfSortList SmallProfSort
        \ call  perlsupportprofiling#Perl_SmallProfSortQuickfix ( <f-args> )
"
if  !s:MSWIN
  command! -nargs=1 -complete=customlist,perlsupportprofiling#Perl_FastProfSortList FastProfSort
        \ call  perlsupportprofiling#Perl_FastProfSortQuickfix ( <f-args> )
endif
"
command! -nargs=1 -complete=customlist,perlsupportprofiling#Perl_NYTProfSortList NYTProfSort
        \ call  perlsupportprofiling#Perl_NYTProfSortQuickfix ( <f-args> )
"
command! -nargs=0  NYTProfCSV call perlsupportprofiling#Perl_NYTprofReadCSV  ()
"
command! -nargs=0  NYTProfHTML call perlsupportprofiling#Perl_NYTprofReadHtml  ()
"
" ---------- Key mappings : function keys ------------------------------------
"
"   Ctrl-F9   run script
"    Alt-F9   run syntax check
"  Shift-F9   set command line arguments
"  Shift-F1   read Perl documentation
" Vim (non-GUI) : shifted keys are mapped to their unshifted key !!!
"
if has("gui_running")
  "
   map    <buffer>  <silent>  <A-F9>             :call Perl_SyntaxCheck()<CR>
  imap    <buffer>  <silent>  <A-F9>        <C-C>:call Perl_SyntaxCheck()<CR>
  "
   map    <buffer>  <silent>  <C-F9>             :call Perl_Run()<CR>
  imap    <buffer>  <silent>  <C-F9>        <C-C>:call Perl_Run()<CR>
  "
   map    <buffer>  <silent>  <S-F9>             :call Perl_Arguments()<CR>
  imap    <buffer>  <silent>  <S-F9>        <C-C>:call Perl_Arguments()<CR>
  "
   map    <buffer>  <silent>  <S-F1>             :call Perl_perldoc()<CR><CR>
  imap    <buffer>  <silent>  <S-F1>        <C-C>:call Perl_perldoc()<CR><CR>
endif
"
"-------------------------------------------------------------------------------
"   Key mappings for menu entries
"   The mappings can be switched on and off by g:Perl_NoKeyMappings
"-------------------------------------------------------------------------------
"
if !exists("g:Perl_NoKeyMappings") || ( exists("g:Perl_NoKeyMappings") && g:Perl_NoKeyMappings!=1 )
  " ---------- plugin help -----------------------------------------------------
  "
   map    <buffer>  <silent>  <LocalLeader>hp         :call Perl_HelpPerlsupport()<CR>
  imap    <buffer>  <silent>  <LocalLeader>hp    <C-C>:call Perl_HelpPerlsupport()<CR>
  "
  noremap    <buffer>  <silent>  <LocalLeader>ntl        :call Perl_EditTemplates("local")<CR>
  noremap    <buffer>  <silent>  <LocalLeader>ntg        :call Perl_EditTemplates("global")<CR>
  noremap    <buffer>  <silent>  <LocalLeader>ntr        :call Perl_RereadTemplates()<CR>
  "
  " ----------------------------------------------------------------------------
  " Regex
  " ----------------------------------------------------------------------------
  "
  nnoremap    <buffer>  <silent>  <LocalLeader>xr        :call perlsupportregex#Perl_RegexPick( "regexp", "n" )<CR>j
  nnoremap    <buffer>  <silent>  <LocalLeader>xs        :call perlsupportregex#Perl_RegexPick( "string", "n" )<CR>j
  nnoremap    <buffer>  <silent>  <LocalLeader>xf        :call perlsupportregex#Perl_RegexPickFlag( "n" )<CR>
  vnoremap    <buffer>  <silent>  <LocalLeader>xr   <C-C>:call perlsupportregex#Perl_RegexPick( "regexp", "v" )<CR>'>j
  vnoremap    <buffer>  <silent>  <LocalLeader>xs   <C-C>:call perlsupportregex#Perl_RegexPick( "string", "v" )<CR>'>j
  vnoremap    <buffer>  <silent>  <LocalLeader>xf   <C-C>:call perlsupportregex#Perl_RegexPickFlag( "v" )<CR>'>j
  nnoremap    <buffer>  <silent>  <LocalLeader>xm        :call perlsupportregex#Perl_RegexVisualize( )<CR>
  nnoremap    <buffer>  <silent>  <LocalLeader>xmm       :call perlsupportregex#Perl_RegexMatchSeveral( )<CR>
  nnoremap    <buffer>  <silent>  <LocalLeader>xe        :call perlsupportregex#Perl_RegexExplain( "n" )<CR>
  vnoremap    <buffer>  <silent>  <LocalLeader>xe   <C-C>:call perlsupportregex#Perl_RegexExplain( "v" )<CR>
  "
  " ----------------------------------------------------------------------------
  " POD
  " ----------------------------------------------------------------------------
  "
   map    <buffer>  <silent>  <LocalLeader>pod         :call Perl_PodCheck()<CR>
   map    <buffer>  <silent>  <LocalLeader>podh        :call Perl_POD('html')<CR>
   map    <buffer>  <silent>  <LocalLeader>podm        :call Perl_POD('man')<CR>
   map    <buffer>  <silent>  <LocalLeader>podt        :call Perl_POD('text')<CR>
  "
  " ----------------------------------------------------------------------------
  " Profiling
  " ----------------------------------------------------------------------------
  "
   map    <buffer>  <silent>  <LocalLeader>rps         :call perlsupportprofiling#Perl_Smallprof()<CR>
   map    <buffer>  <silent>  <LocalLeader>rpf         :call perlsupportprofiling#Perl_Fastprof()<CR>
   map    <buffer>  <silent>  <LocalLeader>rpn         :call perlsupportprofiling#Perl_NYTprof()<CR>
   map    <buffer>  <silent>  <LocalLeader>rpnc        :call perlsupportprofiling#Perl_NYTprofReadCSV("read","line")<CR>
  "
  " ----------------------------------------------------------------------------
  " Run
  " ----------------------------------------------------------------------------
  "
   noremap    <buffer>  <silent>  <LocalLeader>rr         :call Perl_Run()<CR>
   noremap    <buffer>  <silent>  <LocalLeader>rs         :call Perl_SyntaxCheck()<CR>
   noremap    <buffer>  <silent>  <LocalLeader>ra         :call Perl_Arguments()<CR>
   noremap    <buffer>  <silent>  <LocalLeader>rw         :call Perl_PerlSwitches()<CR>
   noremap    <buffer>  <silent>  <LocalLeader>rm         :call Perl_Make()<CR>
   noremap    <buffer>  <silent>  <LocalLeader>rma        :call Perl_MakeArguments()<CR>
  inoremap    <buffer>  <silent>  <LocalLeader>rr    <C-C>:call Perl_Run()<CR>
  inoremap    <buffer>  <silent>  <LocalLeader>rs    <C-C>:call Perl_SyntaxCheck()<CR>
  inoremap    <buffer>  <silent>  <LocalLeader>ra    <C-C>:call Perl_Arguments()<CR>
  inoremap    <buffer>  <silent>  <LocalLeader>rw    <C-C>:call Perl_PerlSwitches()<CR>
  inoremap    <buffer>  <silent>  <LocalLeader>rm    <C-C>:call Perl_Make()<CR>
  inoremap    <buffer>  <silent>  <LocalLeader>rma   <C-C>:call Perl_MakeArguments()<CR>
  "
   noremap    <buffer>  <silent>  <LocalLeader>rd    :call Perl_Debugger()<CR>
   noremap    <buffer>  <silent>    <F9>             :call Perl_Debugger()<CR>
  inoremap    <buffer>  <silent>    <F9>        <C-C>:call Perl_Debugger()<CR>
  "
  if s:UNIX
     noremap    <buffer>  <silent>  <LocalLeader>re         :call Perl_MakeScriptExecutable()<CR>
    inoremap    <buffer>  <silent>  <LocalLeader>re    <C-C>:call Perl_MakeScriptExecutable()<CR>
  endif
  "
   map    <buffer>  <silent>  <LocalLeader>rp         :call Perl_perldoc()<CR>
   map    <buffer>  <silent>  <LocalLeader>h          :call Perl_perldoc()<CR>
  "
   map    <buffer>  <silent>  <LocalLeader>ri         :call Perl_perldoc_show_module_list()<CR>
   map    <buffer>  <silent>  <LocalLeader>rg         :call Perl_perldoc_generate_module_list()<CR>
  "
   map    <buffer>  <silent>  <LocalLeader>ry         :call Perl_Perltidy("n")<CR>
  vmap    <buffer>  <silent>  <LocalLeader>ry    <C-C>:call Perl_Perltidy("v")<CR>
   "
   map    <buffer>  <silent>  <LocalLeader>rc         :call Perl_Perlcritic()<CR>
   map    <buffer>  <silent>  <LocalLeader>rt         :call Perl_SaveWithTimestamp()<CR>
   map    <buffer>  <silent>  <LocalLeader>rh         :call Perl_Hardcopy("n")<CR>
  vmap    <buffer>  <silent>  <LocalLeader>rh    <C-C>:call Perl_Hardcopy("v")<CR>
  "
   map    <buffer>  <silent>  <LocalLeader>rk    :call Perl_Settings()<CR>
  if has("gui_running") && s:UNIX
     map    <buffer>  <silent>  <LocalLeader>rx    :call Perl_XtermSize()<CR>
  endif
  "
   map    <buffer>  <silent>  <LocalLeader>ro         :call Perl_Toggle_Gvim_Xterm()<CR>
  imap    <buffer>  <silent>  <LocalLeader>ro    <C-C>:call Perl_Toggle_Gvim_Xterm()<CR>
  "
  "
endif

" ----------------------------------------------------------------------------
"  Generate (possibly exuberant) Ctags style tags for Perl sourcecode.
"  Controlled by g:Perl_PerlTags, enabled by default.
" ----------------------------------------------------------------------------
if has('perl') && g:Perl_PerlTags == 'enabled'
  let g:Perl_PerlTagsTempfile = tempname()
  if getfsize( expand('%') ) > 0
    call Perl_do_tags( expand('%'), g:Perl_PerlTagsTempfile )
  endif
endif
"
if !exists("g:Perl_Ctrl_j") || ( exists("g:Perl_Ctrl_j") && g:Perl_Ctrl_j != 'off' )
  nmap    <buffer>  <silent>  <C-j>    i<C-R>=Perl_JumpCtrlJ()<CR>
  imap    <buffer>  <silent>  <C-j>     <C-R>=Perl_JumpCtrlJ()<CR>
endif
" ----------------------------------------------------------------------------
