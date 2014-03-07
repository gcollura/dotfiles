""" Shortcuts and mappings

imap jj <Esc>

" Firefox-like shortcuts
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
command! Wsudo :w !sudo tee % >/dev/null <CR><CR>

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V> "+gP
map <S-Insert> "+gP
" command-line mode
cnoremap <C-V> <C-R>+
cnoremap <S-Insert> <C-R>+
" Insert
inoremap <C-V> <F9><C-r>+<F9>
inoremap <S-Insert> <F9><C-r>+<F9>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q> <C-V>

" Toggle search highlight
map <Space> :set nohlsearch<CR>

" vpaste
map vp :exec "w !vpaste ft=".&ft<CR>
vmap vp <ESC>:exec "'<,'>w !vpaste ft=".&ft<CR>

" Numbering
nmap <silent> <F4> :set invrnu<CR>

" Close the current buffer with \q
nnoremap <leader>q :bd % <CR>

" Column scroll-binding on <leader>sb
noremap <silent> <leader>sb :<C-u>let @z=&so<CR>:set so=0 noscb<CR>:bo vs<CR>
            \ Ljzt:setl scb<CR><C-w>p:setl scb<CR>:let &so=@z<CR>

" delitMate autoclose and indent
inoremap {<CR> {<CR>}<C-o>O
