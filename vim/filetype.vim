""" File type support

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    " EJS
    autocmd BufRead,BufNewFile *.ejs        set filetype=jst

    " jQuery
    autocmd BufRead,BufNewFile jquery.*.js  set filetype=javascript syntax=jquery

    " Markdown
    autocmd BufRead,BufNewFile *.md         set filetype=markdown

    " Gradle
    autocmd BufRead,BufNewFile *.gradle     set filetype=groovy

augroup END

" HTML
autocmd FileType html,xhtml,xml             setl tabstop=2 shiftwidth=2 matchpairs+=<:>

" Vala
autocmd BufRead,BufNewFile *.vala,*.vapi    setl errorformat=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m

" Python
autocmd FileType python                     setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" LaTeX
autocmd FileType tex                        setl wrap linebreak textwidth=0 spell spelllang=it

" VimScript
autocmd FileType vim                        setl iskeyword+=:,#
