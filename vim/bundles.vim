""" Bundle setup and configuration
filetype off

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
NeoBundle 'Shougo/unite.vim'
let g:unite_prompt = '» '
let g:unite_source_grep_max_candidates = 200
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#set_profile('files', 'smartcase', 1)
call unite#custom#source('file_rec/async', 'ignore_pattern', 'build')
nnoremap <leader>p :Unite -start-insert file_rec/async:! <CR>
nnoremap <leader>è :Unite grep:. <CR>
nnoremap <leader>o :Unite -start-insert file_mru <CR>
nnoremap <leader>/ :Unite grep:$buffers <CR>
nnoremap <leader>l :Unite buffer <CR>
nnoremap <leader>i :Unite source <CR>
nnoremap <leader>r :Unite register <CR>
nnoremap <leader>b :Unite bookmark <CR>
nnoremap <leader>L :Unite -start-insert line <CR>

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

NeoBundleLazy 'Shougo/vimfiler.vim', { 'autoload' : {
            \ 'commands' : 'VimFiler',
            \ }}
let g:vimfiler_as_default_explorer = 1
nnoremap <leader>f :VimFiler -toggle -explorer <CR>

" Ultisnips and Snippets
NeoBundle 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories = ['bundle/ultisnips/UltiSnips']
function! g:UltiSnips_Complete()
    call UltiSnips_ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips_JumpForwards()
            if g:ulti_jump_forwards_res == 0
                return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction
" Small workaround to have tab work with YouCompleteMe
au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsListSnippets="<C-Tab>"

" Completion support
NeoBundle 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0 " NOTE: Extremely insecure!
let g:ycm_collect_identifiers_from_tags_files = 1

" Syntastic
NeoBundle 'scrooloose/syntastic'
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': [ 'ruby', 'php', 'python' ],
            \ 'passive_filetypes': [ 'sass', 'scss', 'scss.css' ] }

" TagBar
NeoBundle 'majutsushi/tagbar'
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
nmap <F2> :TagbarToggle <CR>

" Vim indent guides
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_color_change_percent = 2

" Commentary
NeoBundle 'tpope/vim-commentary'
autocmd FileType cpp set commentstring=//\ %s

" Vim fugitive
NeoBundle 'tpope/vim-fugitive'

" Vim multiple cursors (a.k.a. SublimeText2 multiselection)
NeoBundle 'terryma/vim-multiple-cursors'

" Gundo
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : {
            \ 'commands' : 'GundoToggle'
            \ }}
nnoremap <F3> :GundoToggle <CR>

" Automatically close brackets
NeoBundle 'Raimondi/delimitMate'

" Utility library for vim-session and vim-lua
NeoBundle 'xolox/vim-misc'

" Easytags - Ctags everywhere
NeoBundle 'xolox/vim-easytags'
let g:easytags_file = '~/.vim/tags'
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0

" Sexy session support
NeoBundle 'xolox/vim-session'
let g:session_autosave_periodic = 5
let g:session_command_aliases = 1

" Lua support
NeoBundleLazy 'xolox/vim-lua-ftplugin', { 'autoload' : {
            \ 'filetypes': 'lua',
            \ }}
let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0

" Vim go to terminal or go to file manager
NeoBundle 'justinmk/vim-gtfo'

" Vim sneak
NeoBundle 'justinmk/vim-sneak'
let g:sneak#streak = 1

" Vim statusline
NeoBundle 'bling/vim-airline'
let g:airline_enable_syntastic = 0
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1

" C++11 support
NeoBundleLazy 'vim-jp/cpp-vim', { 'autoload' : {
            \ 'filetypes' : 'cpp',
            \ }}

" Scss support
NeoBundle 'cakebaker/scss-syntax.vim'

" Vala support
NeoBundleLazy 'tkztmk/vim-vala', { 'autoload' : {
            \ 'filetypes': 'vala',
            \ }}

" Luna colorscheme
NeoBundle 'Pychimp/vim-luna'
NeoBundle 'Pychimp/vim-sol'

filetype plugin indent on
