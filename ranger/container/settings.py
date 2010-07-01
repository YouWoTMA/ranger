# Copyright (C) 2009, 2010  Roman Zimbelmann <romanz@lavabit.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys
from inspect import isfunction
import ranger
from ranger.ext.signal_dispatcher import SignalDispatcher
from ranger.ext.openstruct import OpenStruct

NoneType = type(None)

ALLOWED_SETTINGS = {
	'show_hidden': bool,
	'show_hidden_bookmarks': bool,
	'show_cursor': bool,
	'autosave_bookmarks': bool,
	'save_console_history': bool,
	'collapse_preview': bool,
	'column_ratios': (tuple, list, set),
	'display_size_in_main_column': bool,
	'display_size_in_status_bar': bool,
	'draw_borders': bool,
	'draw_bookmark_borders': bool,
	'dirname_in_tabs': bool,
	'sort': str,
	'sort_reverse': bool,
	'sort_case_insensitive': bool,
	'sort_directories_first': bool,
	'update_title': bool,
	'shorten_title': int,  # Note: False is an instance of int
	'tilde_in_titlebar': bool,
	'max_history_size': (int, NoneType),
	'max_console_history_size': (int, NoneType),
	'launch_script': (str, NoneType),
	'scroll_offset': int,
	'preview_files': bool,
	'preview_directories': bool,
	'mouse_enabled': bool,
	'flushinput': bool,
	'colorscheme': str,
	'colorscheme_overlay': (NoneType, type(lambda:0)),
	'hidden_filter': lambda x: isinstance(x, str) or hasattr(x, 'match'),
	'xterm_alt_key': bool,
}


def default_value(name):
	types = ALLOWED_SETTINGS[name]
	if not isinstance(types, tuple):
		types = (types, )
	for t in types:
		if t is NoneType:
			return None
		if t in (bool, int, str, tuple):
			return t()
	return None


class SettingObject(SignalDispatcher):
	def __init__(self):
		SignalDispatcher.__init__(self)
		self.__dict__['_settings'] = dict()
		for name in ALLOWED_SETTINGS:
			self.signal_bind('setopt.'+name,
					self._raw_set_with_signal, priority=0.2)

	def __setattr__(self, name, value):
		if name[0] == '_':
			self.__dict__[name] = value
		else:
			assert self._check_type(name, value)
			kws = dict(setting=name, value=value,
					previous=(self._settings[name] \
							if name in self._settings \
							else default_value(name)))
			self.signal_emit('setopt', **kws)
			self.signal_emit('setopt.'+name, **kws)

	def __getattr__(self, name):
		try:
			return self._settings[name]
		except KeyError:
			raise Exception("No such setting: %s!" % name)

	def __iter__(self):
		for x in self._settings:
			yield x

	def types_of(self, name):
		try:
			typ = ALLOWED_SETTINGS[name]
		except KeyError:
			return tuple()
		else:
			if isinstance(typ, tuple):
				return typ
			else:
				return (typ, )

	def _check_type(self, name, value):
		typ = ALLOWED_SETTINGS[name]
		if isfunction(typ):
			assert typ(value), \
				"The option `" + name + "' has an incorrect type!"
		else:
			assert isinstance(value, typ), \
				"The option `" + name + "' has an incorrect type!"\
				" Got " + str(type(value)) + ", expected " + str(typ) + "!"
		return True

	__getitem__ = __getattr__
	__setitem__ = __setattr__

	def _raw_set(self, name, value):
		self._settings[name] = value

	def _raw_set_with_signal(self, signal):
		self._settings[signal.setting] = signal.value