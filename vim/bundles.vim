""" Bundle setup and configuration
filetype off

" NeoBundle manages itself
call neobundle#begin(g:bundle_dir)
NeoBundleFetch 'Shougo/neobundle.vim'

" Vimproc from Shougo
NeoBundle 'Shougo/vimproc', {
            \ 'name': 'vimproc',
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }

" Unite.vim
NeoBundleLazy 'Shougo/unite.vim', {
            \ 'name': 'unite.vim',
            \ 'depends': 'vimproc',
            \ 'commands': [
            \   { 'name': 'Unite', 'complete': 'customlist,unite#complete_source' }
            \ ] }
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
nnoremap <leader>c :Unite quickfix location_list -profile-name=qfll<CR>
nnoremap <leader>R :UniteResume <CR>

if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
                \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
                \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr''' .
                \ '--ignore ''node_modules/'' --ignore ''build/'''
    let g:unite_source_grep_recursive_opt = ''
endif

NeoBundleLazy 'Shougo/neomru.vim', {
            \ 'depends': 'unite.vim',
            \ 'filetypes': 'all',
            \ 'unite_sources': [ 'neomru/file', 'neomru/directory' ]
            \ }
nnoremap <leader>o :Unite -start-insert neomru/file <CR>
nnoremap <leader>O :Unite -start-insert -default-action=lcd neomru/directory <CR>

NeoBundleLazy 'Shougo/unite-session', {
            \ 'depends': 'Shougo/unite.vim',
            \ }
let g:unite_source_session_path = g:vim_dir . '/sessions'
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
let g:vimfiler_ignore_pattern = '\(^\.\|^\.git\|\.DS_Store\|node_modules\|build\)'
nnoremap <leader>f :VimFilerExplorer -split <CR>
autocmd FileType vimfiler setl nonumber norelativenumber

NeoBundleLazy 'Shougo/tabpagebuffer.vim', {
            \ 'filetypes': 'all',
            \ 'autoload': {
            \   'unite_sources': [ 'buffer_tab' ]
            \ }}

NeoBundleLazy 'Shougo/unite-outline', {
            \ 'depends': 'Shougo/unite.vim',
            \ }

NeoBundleLazy 'osyo-manga/unite-quickfix', {
            \ 'depends': 'Shougo/unite.vim',
            \ 'unite_sources': [ 'quickfix', 'location_list' ]
            \ }

NeoBundleLazy 't9md/vim-choosewin', {
            \ 'mappings': '<Plug>'
            \ }
let g:choosewin_overlay_enable = 1
let g:choosewin_overlay_clear_multibyte = 1
nnoremap - <Plug>(choosewin)

NeoBundleLazy 'MattesGroeger/vim-bookmarks', {
            \ 'filetypes': 'all'
            \ }

NeoBundleLazy 'moll/vim-bbye', {
            \ 'commands': 'Bdelete'
            \ }
nnoremap <leader>q :Bdelete <CR>

" Ultisnips and Snippets
NeoBundleLazy 'SirVer/ultisnips', {
            \ 'depends': 'honza/vim-snippets',
            \ 'autoload': {
            \   'filetypes': 'all'
            \ }}
NeoBundleLazy 'honza/vim-snippets', {
            \ 'autoload': {
            \   'on_source': 'ultisnips',
            \ }}
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsListSnippets = '<c-l>'
let g:UltiSnipsExpandTrigger = '<c-h>'
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Completion support
NeoBundleLazy 'Valloric/YouCompleteMe', {
            \ 'augroup': 'youcompletemeStart',
            \ 'autoload': {
            \   'insert': 1,
            \ }}
let g:ycm_global_ycm_extra_conf = g:vim_dir . '/ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0 " NOTE: Extremely insecure!
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_warning_symbol = '»'
let g:ycm_error_symbol = '»'
let g:ycm_always_populate_location_list = 1

" Syntastic
NeoBundleLazy 'scrooloose/syntastic', {
            \ 'filetypes': 'all'
            \ }
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': [ 'ruby', 'php', 'python' ],
            \ 'passive_filetypes': [ 'java', 'sass', 'scss', 'scss.css' ]
            \ }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '»'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '»'
let g:syntastic_javascript_checkers = [ 'jshint', 'jscs' ]


" Commentary
NeoBundleLazy 'tomtom/tcomment_vim', {
            \ 'autoload': {
            \   'mappings': [ 'g' ]
            \ }}

" Vim fugitive
NeoBundle 'tpope/vim-fugitive', {
            \ 'augroup' : 'fugitive',
            \ 'commands': [
            \   'Git', 'Gdiff', 'Gstatus', 'Gwrite', 'Gcd', 'Glcd',
            \   'Ggrep', 'Glog', 'Gcommit', 'Gblame', 'Gbrowse'
            \ ],
            \ 'autoload': {
            \   'functions' : [ 'fugitive#head', 'fugitive#extract_git_dir' ],
            \   'filetypes': 'all'
            \ }}

" Vim repeat
NeoBundleLazy 'tpope/vim-repeat', {
            \ 'insert': 1
            \ }

" Vim eunuch
NeoBundleLazy 'tpope/vim-eunuch', {
            \ 'autoload': {
            \   'commands': [
            \     'Unlink',
            \     'Remove',
            \     'Move',
            \     'Rename',
            \     'Chmod',
            \     'Mkdir',
            \     'Find',
            \     'Locate',
            \     'SudoEdit',
            \     'SudoWrite',
            \     'W'
            \   ]
            \ }}

" Let's play better with tmux
NeoBundle 'tmux-plugins/vim-tmux-focus-events', {
            \ 'disabled': !exists('$TMUX'),
            \ 'terminal': 1
            \ }

NeoBundleLazy 'kana/vim-operator-user', {
            \ 'functions' : 'operator#user#define',
            \ }

NeoBundleLazy 'kana/vim-textobj-user', {
            \ 'functions': 'textobj#user#plugin',
            \ }

" Vim operator sorround
NeoBundleLazy 'rhysd/vim-operator-surround', {
            \ 'depends': 'kana/vim-operator-user',
            \ 'mappings': '<Plug>',
            \ }
map <silent>sa <Plug>(operator-surround-append)
map <silent>sd <Plug>(operator-surround-delete)
map <silent>sr <Plug>(operator-surround-replace)

NeoBundle 'sgur/vim-textobj-parameter', {
            \ 'depends': 'kana/vim-textobj-user'
            \ }

NeoBundle 'glts/vim-textobj-comment', {
            \ 'depends': 'kana/vim-textobj-user'
            \ }

" For more kana's textobj based plugins, look
" https://github.com/kana/vim-textobj-user/wiki

" more textobj
" NeoBundle 'wellle/targets.vim'

" incsearch.vim
NeoBundle 'haya14busa/incsearch.vim', {
            \ 'name': 'incsearch.vim'
            \ }
NeoBundle 'haya14busa/incsearch-fuzzy.vim', {
            \ 'depends': 'incsearch.vim'
            \ }
let g:incsearch#auto_nohlsearch = 1
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map z/ <Plug>(incsearch-fuzzy-/)
map z? <Plug>(incsearch-fuzzy-?)
map zg/ <Plug>(incsearch-fuzzy-stay)

" Gundo
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : {
            \ 'commands': 'GundoToggle'
            \ }}
nnoremap <F3> :GundoToggle <CR>

" Automatically close brackets
NeoBundleLazy 'Raimondi/delimitMate', {
            \ 'insert': 1
            \ }

" Utility library for vim-session and vim-lua
NeoBundleLazy 'xolox/vim-misc'

" Better session support
NeoBundleLazy 'xolox/vim-session', {
            \ 'depends': 'xolox/vim-misc',
            \ 'autoload': {
            \   'commands': [
            \     { 'name': [ 'SessionOpen', 'SessionClose' ],
            \       'complete': 'customlist,xolox#session#complete_names' },
            \     { 'name': [ 'SessionSave' ],
            \       'complete': 'customlist,xolox#session#complete_names_with_suggestions' }
            \   ],
            \   'functions': [ 'xolox#session#complete_names',
            \                  'xolox#session#complete_names_with_suggestions' ],
            \   'unite_sources': [ 'session', 'session/new' ]
            \ }}
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

NeoBundleLazy 'junegunn/vim-easy-align', {
            \ 'insert': 1
            \ }

NeoBundleLazy 'lervag/vimtex', { 'autoload': {
            \ 'filetypes': [ 'tex', 'latex' ]
            \ }}
let g:vimtex_mappings_enabled = 1
let g:vimtex_latexmk_build_dir = 'out'
let g:vimtex_quickfix_mode = 0
let g:vimtex_latexmk_background = 1
let g:vimtex_view_general_viewer = 'mupdf'
let g:vimtex_quickfix_ignored_warnings = [
            \ 'Underfull',
            \ 'Overfull',
            \ 'specifier changed to',
            \ ]
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = [
            \ 're!\\[A-Za-z]*(ref|cite)[A-Za-z]*([^]]*])?{([^}]*, ?)*'
            \ ]

NeoBundleLazy 'jamessan/vim-gnupg', {
            \ 'commands': [ 'GPGViewRecipients', 'GPGEditRecipients',
            \               'GPGViewOptions', 'GPGEditOptions' ],
            \ 'augroup': 'GnuPG',
            \ 'autoload': {
            \   'filename_patterns': [ '\.gpg$', '\.pgp$', '\.asc$' ]
            \ }}
" Tell the GnuPG plugin to armor new files.
let g:GPGPreferArmor = 1
" Tell the GnuPG plugin to sign new files.
let g:GPGPreferSign = 1

NeoBundleLazy 'fmoralesc/vim-pad', {
            \ 'autoload': {
            \   'commands': [
            \     { 'name': [ 'Pad' ],
            \       'complete': 'custom,pad#PadCmdComplete' }
            \   ],
            \ }}
let g:pad#dir = "~/.notes/"
call utils#putdir(g:pad#dir)

" Vim statusline
NeoBundle 'bling/vim-airline'
let g:airline#extensions#syntastic#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1

" C++11 support
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', { 'autoload': {
            \ 'filetypes': 'cpp',
            \ }}

" Java 8 support
NeoBundleLazy 'vim-jp/vim-java', { 'autoload': {
            \ 'filetypes': 'java',
            \ }}

NeoBundleLazy 'rust-lang/rust.vim', { 'autoload': {
            \ 'filetypes': 'rust',
            \ }}

" Scss support
NeoBundleLazy 'cakebaker/scss-syntax.vim', { 'autoload': {
            \ 'filetypes': [ 'scss', 'sass', 'css' ]
            \ }}

" Javascript and HTML
NeoBundleLazy 'marijnh/tern_for_vim', { 'autoload': {
            \ 'filetypes': [ 'javascript', 'html' ]
            \ }}

NeoBundleLazy 'pangloss/vim-javascript', { 'autoload': {
            \ 'filetypes': [ 'javascript', 'html' ]
            \ }}

NeoBundleLazy 'digitaltoad/vim-jade', { 'autoload': {
            \ 'filetypes': 'jade'
            \ }}

NeoBundleLazy 'gregsexton/MatchTag', { 'autoload': {
            \ 'filetypes': [ 'html', 'xml' ]
            \ }}

" Vala support
NeoBundleLazy 'tkztmk/vim-vala', { 'autoload': {
            \ 'filetypes': 'vala',
            \ }}

" Qml support
NeoBundleLazy 'peterhoeg/vim-qml', { 'autoload': {
            \ 'filetypes': 'qml',
            \ }}

" Vim omni complete support
NeoBundleLazy 'c9s/vimomni.vim', { 'autoload': {
            \ 'filetypes': 'vim'
            \ }}

NeoBundleLazy 'tmux-plugins/vim-tmux', { 'autoload': {
            \ 'filetypes': 'conf',
            \ }}

NeoBundleLazy 'cespare/vim-toml', { 'autoload': {
            \ 'filetypes': 'toml',
            \ }}

" vim-partial, move chunks of code to new files
" NeoBundleLazy 'jbgutierrez/vim-partial', {
"             \ 'commands': 'PartialExtract'
"             \ }
"
" vim-gitbranch, lightweight alternative to fugitive.vim
" NeoBundleLazy 'itchyny/vim-gitbranch'

NeoBundle 'chriskempson/base16-vim'

let g:EclimCompletionMethod = 'omnifunc'
let g:EclimJavascriptValidate = 0

call neobundle#end()

if neobundle#tap('unite.vim')
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    call unite#custom#profile('files', 'context.smartcase', 1)
    call unite#custom#source('file_rec/async', 'ignore_pattern', g:vimfiler_ignore_pattern)
    call unite#custom#profile('source/quickfix,source/location_list', 'context', {
                \   'winheight': 13,
                \   'direction': 'botright',
                \   'start_insert': 0,
                \   'keep_focus': 1,
                \   'no_quit': 0,
                \ })
    call unite#custom#profile('qfll', 'context', {
                \   'winheight': 13,
                \   'direction': 'botright',
                \   'start_insert': 0,
                \   'keep_focus': 1,
                \   'no_quit': 0,
                \   'hide_source_names': 1,
                \ })
    call neobundle#untap()
endif

filetype plugin indent on
