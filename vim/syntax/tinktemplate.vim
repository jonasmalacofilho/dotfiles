" Vim syntax file
" Language:	Tink Template (simplified)
" Maintainer:	Jonas Malaco <jonas@elebeta.com.br>
" Last Change:	2015 Fev 24
" Based on Django HTML template by Dave Hodder <dmh@dmh.org.uk>

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'html'
endif

if version < 600
  so <sfile>:p:h/html.vim
else
  runtime! syntax/html.vim
  unlet b:current_syntax
endif

syn region ttCommentBlock start="(:\*" end="\*:)" containedin=ALL
syn region ttBlock start="(:[^*]" end="[^*]:)" containedin=ALLBUT,ttCommentBlock
hi link ttCommentBlock Comment
hi link ttBlock Special

let b:current_syntax = "tinktemplate"

