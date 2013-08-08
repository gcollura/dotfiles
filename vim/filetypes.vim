""" File type support

if exists("did_load_filetypes")
    finish
endif
let g:did_load_filetypes = 1

" Vala
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead,BufNewFile *vala setfiletype vala
autocmd BufRead,BufNewFile *vapi setfiletype vala

" Python
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class 

" EJS
autocmd BufNewFile,BufRead *.ejs set filetype=jst

" jQuery
autocmd BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

" HTML
autocmd FileType html set tabstop=2|set shiftwidth=2
autocmd FileType xhtml set tabstop=2|set shiftwidth=2
autocmd FileType xml set tabstop=2|set shiftwidth=2
