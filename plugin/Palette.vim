vim9script


if !exists('g:supra_icons_palette')
    g:supra_icons_palette = {
		# Red glyphs
		'GlyphPalette1': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
		# Green glyphs
		'GlyphPalette2': ['', '', '', '', '', '', '󰡄', '', '', '', '', '', '', ''],
		# Yellow glyphs
		'GlyphPalette3': ['λ', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '󰜡', '', '', '', '', '', '', '', '', '', '', '󰗀'],
		# Blue glyphs
		'GlyphPalette4': ['', '', '', '', '', '', '󰌛', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '󱎒', '󱎒', '󱎏', '󱎏', '󱎐', '', '󰬈', '󰬉', '󰬊', '󰬋', '󰬌', '󰬍', '󰬟', '󰬠', '󰬡', ''],
		# Purple glyphs
		'GlyphPalette5': ['', '', '', '', '', '󱎎', ''],
		# Cyan glyphs
		'GlyphPalette6': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
		# Orange glyphs
		'GlyphPalette7': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
		# Gray glyphs
		'GlyphPalette8': [],
		'GlyphPalette9': ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''],
		'GlyphPaletteDirectory': ['', '', '', '', '', '', '', '', '', '', '󱂵', '󰉏', '󰉐', '󰉑', '󰉒', '󰉓', '󰉔', '󰉕', '󰉖', '󰉗', '󰉘', '󰉙', '󰉍', '󰚝', '󱧺', '󰉓', '', ''],
	}
endif

const GLYPH_PALETTE_COLORS = {
    light: [
        '#dcdfe7', '#cc517a', '#668e3d', '#c57339', '#2d539e', '#7759b4', '#3f83a6', '#33374c',
        '#8389a3', '#cc3768', '#598030', '#b6662d', '#22478e', '#6845ad', '#327698', '#262a3f'
    ],
    dark: [
        '#1e2132', '#e27878', '#b4be82', '#e2a478', '#84a0c6', '#a093c7', '#89b8c2', '#c6c8d1',
        '#6b7089', '#e98989', '#c0ca8e', '#e9b189', '#91acd1', '#ada0d3', '#95c4ce', '#d2d4de'
    ]
}

def Highlight(colors: list<string>)
    highlight default link GlyphPaletteDirectory Directory

    for i in range(len(colors))
        var color = colors[i]
        execute $'highlight default GlyphPalette{i} ctermfg={i} guifg={color}'
    endfor
enddef

export def ApplyDefaults()
    var colors: list<string>

    if exists('g:terminal_ansi_colors')
        colors = g:terminal_ansi_colors
    elseif exists('g:terminal_color_0')
        colors = range(16)->mapnew((i, _) => get(g:, $'terminal_color_{i}'))
    else
        colors = GLYPH_PALETTE_COLORS[&background]
    endif

    Highlight(colors)

    augroup GlyphPaletteDefaultsHighlightInternal
        autocmd!
        autocmd ColorScheme * ++once ApplyDefaults()
    augroup END
enddef

call ApplyDefaults()
