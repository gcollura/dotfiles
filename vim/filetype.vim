""" File type support

if exists("did_load_filetypes")
    finish
endif

augroup filetypedetect
    " Vala
    autocmd BufRead,BufNewFile *vala        setfiletype vala
    autocmd BufRead,BufNewFile *vapi        setfiletype vala

    " EJS
    autocmd BufRead,BufNewFile *.ejs        setfiletype jst

    " jQuery
    autocmd BufRead,BufNewFile jquery.*.js  set ft=javascript syntax=jquery

    " Markdown
    autocmd BufRead,BufNewFile *.md         setfiletype markdown
augroup END

" HTML
autocmd FileType html   set tabstop=2|set shiftwidth=2
autocmd FileType xhtml  set tabstop=2|set shiftwidth=2
autocmd FileType xml    set tabstop=2|set shiftwidth=2

" Vala
autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m

" Python
autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
