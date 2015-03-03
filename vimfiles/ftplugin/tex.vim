" ------------------------------------------------------------------------------
" Compiler rules {{{
" This is the first thing you should customize. It is set up for most common
" values, but if use some other compiler, then you will want to change this.
" As CompileFlags value you'd perhaps like to use, e.g., '-src-specials',
" but it is known that it can sometimes give different results in the output,
" so use it with care.

let g:Tex_CompileRule_dvi = 'latex  -src-specials -interaction=nonstopmode $*'
let g:Tex_ViewRule_dvi = 'xdvi -s 6'

