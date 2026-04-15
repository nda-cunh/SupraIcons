vim9script

import autoload '../autoload/SupraIcons/Icons.vim' as icons

##################################
#  All Icons for SupraIcons
##################################

const folder_open = ''

g:loaded_webdevicons = 1
g:webdevicons_enable = 1

#####################################
#  Utility Functions
#####################################

def IsBinary(path: string): bool
	return match(readfile(path, '', 10), '\%x00', 0, 1) != -1
enddef

def GetDirectorySymbol(_path: string): string
	var path: string
	if _path[-1] == '/'
		path = substitute(_path, '/\+$', '', '') 
	else
		path = _path
	endif
	const name = tolower(fnamemodify(path, ':t'))
	if has_key(icons.icons_matches_folders, name)
		return icons.icons_matches_folders[name]
	endif
	if isdirectory(_path)
		# check if we have permission to read the directory
		try 
		if readdir(_path) != []
			return folder_open # Empty directory
		endif
		catch
			return '󱧴'
		endtry
	endif
	return '󰉋' # Default directory icon
enddef

def GetFileSymbol(path: string): string
	const name = tolower(fnamemodify(path, ':t'))

	# Match the filename
	if has_key(icons.icons_matches_files, name)
		return icons.icons_matches_files[name]
	endif

	# Match the extension
	const ext = fnamemodify(name, ':e')
	if has_key(icons.icons_ext, ext)
		return icons.icons_ext[ext]
	endif

	if !isdirectory(path)
		# check if we have permission to read the file 
		try 
		if readfile(path, '', 1) == []
			return '󰈔' # Default file icon
		else
			return '󰈙'
		endif
		catch
			return '󱪡'
		endtry
	endif
	return '󰈔' # Default file icon
enddef

#######################################
# Public Functions (WebDevIcons)
#######################################

var fileformat: string = ''

def g:WebDevIconsGetFileFormatSymbol(): string
	if fileformat != ''
		return fileformat
	endif
	if &fileformat ==? 'dos'
		fileformat = ''
	elseif &fileformat ==? 'unix'
		fileformat = has('macunix') ? '' : GetDistro()
	elseif &fileformat ==? 'mac'
		fileformat = ''
	endif
	return fileformat
enddef

def g:WebDevIconsGetFileTypeSymbol(_value: string = '', type_id: number = -1): string
	var value: string
	if _value == ''
		value = expand('%:p')
	else
		value = _value
	endif
	# if number == 0 it's a file 
	if type_id == 0
		return GetFileSymbol(value)
	# if type_id == 1 it's a directory
	elseif type_id >= 1
		return GetDirectorySymbol(value)
	# Check its a file or directory
	else
		const is_dir = isdirectory(value)
		const is_file = filereadable(value)
		# if is not a file or directory return default icon
		# echom is_dir .. ' ' .. is_file 
		if !is_dir && !is_file
			# the path is not valid check if a '/' is at the end 
			if value[-1] == '/'
				return GetDirectorySymbol(value[: -1])
			else
				return GetFileSymbol(value)
			endif
		endif
		if is_dir
			return GetDirectorySymbol(value)
		endif
		if is_file
			var sym = GetFileSymbol(value)
			if (sym == '󰈔' || sym == '󰈙') && IsBinary(value)
				return ''
			endif
			return sym 
		endif
	endif
	return GetFileSymbol(value)
enddef

def GetDistro(): string
	if has('bsd')
		return ''
	elseif has('unix')
		try
			const content = readfile('/etc/lsb-release')
			var idx = 0
			for i in range(len(content))
				if stridx('^DISTRIB_ID=', content[i]) == 0
					idx = i
					break
				endif
			endfor
			if idx == -1
				throw 'Distro not found'
			endif
			var distro = content[idx][11 : -1]
			distro = tolower(distro)
			if has_key(icons.icons_distro, distro)
				return icons.icons_distro[distro]
			endif
		catch
		endtry
	endif
	return '' # Default to generic Linux icon
enddef
