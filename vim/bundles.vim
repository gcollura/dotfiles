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
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#set_profile('files', 'smartcase', 1)
call unite#custom#source('file_rec/async', 'ignore_pattern', 'build')
nnoremap <leader>p :Unite -start-insert file_rec/async <CR>
nnoremap <leader>o :Unite -start-insert file_mru <CR>
nnoremap <leader>/ :Unite grep:$buffers <CR>
nnoremap <leader>l :Unite buffer <CR>
nnoremap <leader>i :Unite source <CR>
nnoremap <leader>r :Unite register <CR>
nnoremap <leader>b :Unite bookmark <CR>

NeoBundleLazy 'Shougo/vimfiler.vim', { 'autoload' : {
            \ 'commands' : 'VimFiler',
            \ }}
let g:vimfiler_as_default_explorer = 1
nnoremap <leader>f :VimFiler -toggle -explorer <CR>

" Ultisnips and Snippets
NeoBundle 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories=['bundle/ultisnips/UltiSnips']
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

au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsListSnippets="<C-Tab>"

" Completion support
NeoBundle 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_extra_conf.py'
let g:ycm_key_invoke_completion = '<C-a>'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0 " NOTE: Extremely insecure!

" Syntastic
NeoBundle 'scrooloose/syntastic'

" IndentLine - Disabled until performance aren't improved
" NeoBundle 'Yggdroot/indentLine'
" nnoremap <F11> :IndentLinesToggle <CR>

" C++11 support
NeoBundleLazy 'random-cpp/cpp-vim', { 'autoload' : {
            \ 'filetypes' : 'cpp',
            \ }}

" Commentary
NeoBundle 'tpope/vim-commentary'
autocmd FileType cpp set commentstring=//\ %s

" Vim multiple cursors (a.k.a. SublimeText2 multiselection)
NeoBundle 'terryma/vim-multiple-cursors'

" Vim fugitive
NeoBundle 'tpope/vim-fugitive'

" Gundo
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : {
            \ 'commands' : 'GundoToggle'
            \ }}
nnoremap <F3> :GundoToggle <CR>

NeoBundle 'Raimondi/delimitMate'

" Vim statusline
NeoBundle 'bling/vim-airline'
let g:airline_enable_syntastic = 0
let g:airline_theme = 'luna'
let g:airline_powerline_fonts = 1
let g:airline_exclude_preview = 1

" Luna colorscheme
NeoBundle 'Pychimp/vim-luna'

filetype plugin indent on
