""" File type support

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    " Vala
    autocmd BufRead,BufNewFile *.vala       set filetype=vala
    autocmd BufRead,BufNewFile *.vapi       set filetype=vala

    " EJS
    autocmd BufRead,BufNewFile *.ejs        set filetype=jst

    " jQuery
    autocmd BufRead,BufNewFile jquery.*.js  set filetype=javascript syntax=jquery

    " Markdown
    autocmd BufRead,BufNewFile *.md         set filetype=markdown

    " Qml
    autocmd BufRead,BufNewFile *.qml        set filetype=qml
augroup END

" HTML
autocmd FileType html   setlocal tabstop=2 shiftwidth=2
autocmd FileType xhtml  setlocal tabstop=2 shiftwidth=2
autocmd FileType xml    setlocal tabstop=2 shiftwidth=2

" Vala
autocmd BufRead *.vala,*.vapi setl errorformat=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m

" Python
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" LaTeX
autocmd FileType tex setl wrap linebreak textwidth=0 spell spelllang=it

autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType cfg setlocal commentstring=#\ %s
