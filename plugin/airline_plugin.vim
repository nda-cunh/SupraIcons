vim9script

########################################
# Airline Integration
########################################

if !exists('g:loaded_airline')
	finish
endif

g:webdevicons_enable_airline_tabline = 1
g:webdevicons_enable_airline_statusline = 1
g:webdevicons_enable_airline_statusline_fileformat_symbols = 1
g:WebDevIconsTabAirLineBeforeGlyphPadding = ' '
g:WebDevIconsTabAirLineAfterGlyphPadding = ''

g:airline#extensions#tabline#formatter = 'SupraIcon'

def AirlineActiveFunc(...args: list<any>): any
	var ctx = args[0]._context
	var buf = ctx.bufnr

	const icon = ' ' .. g:WebDevIconsGetFileTypeSymbol() .. ' '
	w:airline_section_x = get(g:, 'airline_section_x', '') .. icon

	if g:webdevicons_enable_airline_statusline_fileformat_symbols
		w:airline_section_y = ' %{&fenc . " " . g:WebDevIconsGetFileFormatSymbol()} '
	endif
	return 0
enddef

def AirlineInactiveFunc(...args: list<any>): any 
	var ctx = args[0]._context
	var wid = win_getid(ctx.winnr)
	if getwinvar(wid, '&filetype') == 'suprawater'
		setwinvar(wid, 'airline_section_c', 'SupraWater 󰥨 ')
	endif
	return 0 
enddef

airline#add_statusline_func(function('AirlineActiveFunc'))
airline#add_inactive_statusline_func(function('AirlineInactiveFunc'))
