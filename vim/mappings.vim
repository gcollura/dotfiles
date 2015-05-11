""" Shortcuts and mappings

" Generic shortcuts
imap jj <Esc>
noremap Q <nop>

" Stop that annoying useless piece of window from appearing
nnoremap q: :

" Motion
nnoremap j gj

" Tab shortcuts
nnoremap <leader>tt :tabnew<CR>
nnoremap <leader>TT :tabclose<CR>

command! Settings :e ~/.vim/vimrc
command! BashRc :e ~/.bashrc
command! ZshRc :e ~/.zshrc
command! W :w
command! Q :q

" Toggle search highlight
noremap <leader>h :nohlsearch<CR>
noremap <leader>w :w!<CR>

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
