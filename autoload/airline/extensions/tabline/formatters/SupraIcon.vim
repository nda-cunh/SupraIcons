function! airline#extensions#tabline#formatters#SupraIcon#format(bufnr, buffers) abort
  let bufname = bufname(a:bufnr)
  let name = fnamemodify(bufname, ':t')
  return name .. g:WebDevIconsTabAirLineBeforeGlyphPadding . WebDevIconsGetFileTypeSymbol(bufname) . g:WebDevIconsTabAirLineAfterGlyphPadding
endfunction
