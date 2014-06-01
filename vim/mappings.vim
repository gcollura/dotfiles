""" Shortcuts and mappings

" Generic shortcuts
imap jj <Esc>
map Q <nop>

" Stop that annoying useless piece of window from appearing
nnoremap q: :

" Tab shortcuts
map <leader>tt :tabnew<CR>
map <leader>TT :tabclose<CR>

" GVim only
" cycle through buffers with <ALT><Left> and <ALT><Right>
nmap <silent> <A-H> :bprev<CR>
nmap <silent> <A-L> :bnext<CR>

" Window navigation
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

" Show my CPUs Temp
command! Settings :e ~/.vim/vimrc
command! BashRc :e ~/.bashrc
command! ZshRc :e ~/.zshrc
command! W :w
command! Q :q
" command! Ws :exe 'write !sudo tee % >/dev/null' | silent edit!
" Thanks tpope for this command
command! -bar SudoWrite :
      \ setlocal nomodified |
      \ exe (has('gui_running') ? '' : 'silent') 'write !sudo tee % >/dev/null' |
      \ let &modified = v:shell_error

" CTRL-X and SHIFT-Del are Cut
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <S-Insert> "+gP
" command-line mode
cnoremap <S-Insert> <C-R>+
" Insert
inoremap <S-Insert> <F9><C-r>+<F9>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" Toggle search highlight
noremap <leader>h :nohlsearch<CR>
noremap <leader>w :w!<CR>

" Numbering
nmap <silent> <F4> :set invrnu<CR>

" Column scroll-binding on <leader>sb
noremap <silent> <leader>sb :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>
            \ Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

" delitMate autoclose and indent
inoremap {<CR> {<CR>}<C-o>O

" This rewires n and N to do the highlighing...
nnoremap <silent> n n:call HLNext(0.3)<cr>
nnoremap <silent> N N:call HLNext(0.3)<cr>

vmap <expr> <left>  DVB_Drag('left')
vmap <expr> <right> DVB_Drag('right')
vmap <expr> <down>  DVB_Drag('down')
vmap <expr> <up>    DVB_Drag('up')
vmap <expr> D       DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1
