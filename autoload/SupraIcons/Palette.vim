vim9script

const ESCAPE_PATTERN = '^$~.*[]\'

export def Apply(palette_arg: dict<list<string>> = {})
    # Prepare the palette
    var palette = empty(palette_arg) ? g:supra_icons_palette : palette_arg
    var processed_palette: dict<string> = {}

    for [group, glyphs] in items(palette)
        if !empty(glyphs)
            # Escape special characters and join into REGEX
            var escaped_glyphs = mapnew(glyphs, (_, v) => escape(v, ESCAPE_PATTERN))
            processed_palette[group] = printf('\%%(%s\)', join(escaped_glyphs, '\|'))
        endif
    endfor

    # keep in buffer
    b:supra_icons_palette = processed_palette

    augroup GlyphPaletteInternal
        autocmd! * <buffer>
        autocmd BufEnter,WinEnter <buffer> ApplyToWindow()
    augroup END

    Clear()
    ApplyToWindow()
enddef


def ApplyToWindow()
    if !exists('b:supra_icons_palette')
        Clear()
        return
    endif

	# Remove old matches from current window
    if exists('w:glyph_palette_matches')
        for match_id in w:glyph_palette_matches
            silent! matchdelete(match_id)
        endfor
    endif

	# Apply new ones
    w:glyph_palette_matches = []
    for [group, regex] in items(b:supra_icons_palette)
        var mid = matchadd(group, regex)
        add(w:glyph_palette_matches, mid)
    endfor
enddef

def Clear()
    var winid_saved = win_getid()
    var winids = win_findbuf(bufnr('%'))
    for winid in winids
        win_gotoid(winid)
        if exists('w:glyph_palette_matches')
            for match_id in w:glyph_palette_matches
                silent! matchdelete(match_id)
            endfor
            unlet w:glyph_palette_matches
        endif
    endfor
    win_gotoid(winid_saved)
enddef
