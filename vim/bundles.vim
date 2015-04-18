""" Bundle setup and configuration
filetype off

" NeoBundle manages itself
call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Vimproc from Shougo
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }

" Unite.vim
NeoBundleLazy 'Shougo/unite.vim', { 'autoload': {
            \ 'commands': [ 'Unite', 'UniteResume' ]
            \ }}
let g:unite_prompt = '» '
let g:unite_source_grep_max_candidates = 200
nnoremap <leader>p :Unite -start-insert file_rec/async <CR>
nnoremap <leader>[ :Unite grep:. <CR>
nnoremap <leader>/ :Unite grep:$buffers <CR>
nnoremap <leader>l :Unite buffer_tab buffer -hide-source-names <CR>
nnoremap <leader>i :Unite source <CR>
nnoremap <leader>r :Unite register <CR>
nnoremap <leader>b :Unite bookmark <CR>
nnoremap <leader>L :Unite -start-insert line <CR>
nnoremap <leader>R :UniteResume <CR>

if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
                \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
                \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
    " Use ack in unite grep source.
    let g:unite_source_grep_command = 'ack-grep'
    let g:unite_source_grep_default_opts =
                \ '--no-heading --no-color -a -H'
    let g:unite_source_grep_recursive_opt = ''
endif

NeoBundleLazy 'Shougo/neomru.vim', {
            \ 'depends': 'Shougo/unite.vim',
            \ }
nnoremap <leader>o :Unite -start-insert neomru/file <CR>
nnoremap <leader>O :Unite -start-insert -default-action=lcd neomru/directory <CR>

NeoBundleLazy 'Shougo/unite-session', {
            \ 'depends': 'Shougo/unite.vim',
            \ }
let g:unite_source_session_path = '~/.vim/sessions'
nnoremap <leader>S :Unite -start-insert session <CR>

NeoBundleLazy 'Shougo/vimfiler.vim', {
            \ 'depends': 'Shougo/unite.vim',
            \ 'commands': [ {
            \       'name': [ 'VimFiler', 'VimFilerExplorer', 'Edit', 'Write' ],
            \       'complete': 'customlist,vimfiler#complete'
            \    },
            \    'Read', 'Source'
            \ ],
            \ 'explorer' : 1,
            \ }
let g:vimfiler_as_default_explorer = 1
nnoremap <leader>f :VimFilerExplorer -split <CR>

NeoBundle 'Shougo/tabpagebuffer.vim'

NeoBundleLazy 'Shougo/unite-outline', {
            \ 'depends': 'Shougo/unite.vim',
            \ }
NeoBundle 'osyo-manga/unite-quickfix', {
            \ 'depends': 'Shougo/unite.vim',
            \ }

NeoBundle 't9md/vim-choosewin'
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
nnoremap - <Plug>(choosewin)

NeoBundle 'MattesGroeger/vim-bookmarks'

NeoBundle 'moll/vim-bbye'
nnoremap <leader>q :Bdelete <CR>

" Ultisnips and Snippets
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsListSnippets = '<c-l>'
let g:UltiSnipsExpandTrigger = '<c-h>'
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Completion support
NeoBundle 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0 " NOTE: Extremely insecure!
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_warning_symbol = '»'
let g:ycm_error_symbol = '»'

" Syntastic
NeoBundle 'scrooloose/syntastic'
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': [ 'ruby', 'php', 'python' ],
            \ 'passive_filetypes': [ 'sass', 'scss', 'scss.css' ]
            \ }

" TagBar
NeoBundle 'majutsushi/tagbar'
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
nmap <F2> :TagbarToggle <CR>

" Commentary
NeoBundle 'tpope/vim-commentary'

" Vim fugitive
NeoBundle 'tpope/vim-fugitive'

" Vim repeat
NeoBundle 'tpope/vim-repeat'

" Vim eunuch
NeoBundle 'tpope/vim-eunuch'

" Let's play better with tmux
NeoBundle 'tmux-plugins/vim-tmux-focus-events'

NeoBundle 'kana/vim-operator-user'

" Vim operator sorround
NeoBundle 'rhysd/vim-operator-surround'
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

" Gundo
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : {
            \ 'commands' : 'GundoToggle'
            \ }}
nnoremap <F3> :GundoToggle <CR>

" Automatically close brackets
NeoBundle 'Raimondi/delimitMate'

" Utility library for vim-session and vim-lua
NeoBundle 'xolox/vim-misc'

" Better session support
NeoBundle 'xolox/vim-session'
let g:session_autosave_periodic = 5
let g:session_command_aliases = 1
let g:session_autosave = 'yes'
let g:session_persist_colors = 0
let g:session_autoload = 'no'

" Lua support
NeoBundleLazy 'xolox/vim-lua-ftplugin', { 'autoload' : {
            \ 'filetypes': 'lua',
            \ }}
let g:lua_check_syntax = 1
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 1

NeoBundle 'junegunn/vim-easy-align'

NeoBundle 'LaTeX-Box-Team/LaTeX-Box'

NeoBundle 'jamessan/vim-gnupg'
" Tell the GnuPG plugin to armor new files.
let g:GPGPreferArmor=1
" Tell the GnuPG plugin to sign new files.
let g:GPGPreferSign=1

NeoBundle 'fmoralesc/vim-pad'
let g:pad#dir = "~/Sync/Notes/"

" Vim statusline
NeoBundle 'bling/vim-airline'
let g:airline#extensions#syntastic#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1

" C++11 support
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', { 'autoload' : {
            \ 'filetypes': 'cpp',
            \ }}

" Scss support
NeoBundleLazy 'cakebaker/scss-syntax.vim', { 'autoload' : {
            \ 'filetypes': [ 'scss', 'sass', 'css' ]
            \ }}

" Javascript
NeoBundleLazy 'marijnh/tern_for_vim', { 'autoload' : {
            \ 'filetypes': [ 'javascript', 'html' ]
            \ }}
NeoBundleLazy 'pangloss/vim-javascript', { 'autoload': {
            \ 'filetypes': [ 'javascript', 'html' ]
            \ }}

NeoBundle 'gregsexton/MatchTag'

" Vala support
NeoBundleLazy 'tkztmk/vim-vala', { 'autoload' : {
            \ 'filetypes': 'vala',
            \ }}

" Qml support
NeoBundleLazy 'peterhoeg/vim-qml', { 'autoload': {
            \ 'filetypes': 'qml',
            \ }}

" Gradle
NeoBundle 'tfnico/vim-gradle'

NeoBundle 'chriskempson/base16-vim'

let g:EclimCompletionMethod = 'omnifunc'
let g:EclimJavascriptValidate = 0

call neobundle#end()

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('files', 'context.smartcase', 1)
call unite#custom#source('file_rec/async', 'ignore_pattern', 'build')
call unite#custom#profile('source/quickfix,source/location_list', 'context', {
    \   'winheight': 13,
    \   'direction': 'botright',
    \   'start_insert': 0,
    \   'keep_focus': 1,
    \   'no_quit': 0,
    \ })

filetype plugin indent on
