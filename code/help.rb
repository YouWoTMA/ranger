module Fm
	def self.get_help()
		helptext = <<END




	key:
	Press a key to view the topic:
		?     quick summary
		m     basic movement and control
		g     quickly switching directories
		f     filtering and searching
		l     running files in different ways
		c     creating, deleting, moving, copying
		o     more commands that don't fit elsewhere

   To interrupt current operations: <Ctrl-C>
   To quit: Q or ZZ or <Ctrl-D> or <Ctrl-C><Ctrl-C> (quickly twice in a row)


	And always take care of which keys you press. This tool not only
	makes it easy to access files but also to destroy them.





	key:?
	Movement:                h,j,k,l or arrow-keys
	Run file or enter dir:   l or RIGHT or ENTER
	Move 1 directory back:   h or LEFT or BACKSPACE

	R:      Refresh the view     <Ctrl-R>:    Reload everything
	Space:  Mark a file.  v:  Reverse markings.  V:  Clear markings
	Bookmark directories with mX and re-enter them with 'X

	To search, type / or f followed by the text
	If you use f, the first non-ambiguous match will be entered/run

	mkdir<name> or touch<name> to create dirs or files

	move file to ~/.trash:     dd
	delete file forever:       dfd
	delete whole dir forever:  delete

	copy file:     cp or yy
	cut file:      cut
	paste file:    p
	move/rename:   mv<name> or cw<name>






	key:m
	R           refresh the view
	<Ctrl-R>    completely reloads the file memory

	k or UP     move 1 item up
	j or DOWN   move 1 item down
	K           move half the screen up
	J           move half the screen down
	PAGE UP     move the whole screen up
	PAGE DOWN   move the whole screen down
	HOME or gg  move to the top
	END or G    move to the bottom

	h or LEFT or BACKSPACE  move one directory back
	l or RIGHT or ENTER     enter the directory or run the file.
	H                       like h, but if if pwd is on a symlink,
                           you get to the original location





	key:g
	m<key>   bookmark this directory
	um<key>  un-marks the specified bookmark
	'        shows an overview of all bookmarks
	'<key>   re-enter bookmarked directory.
	TAB      equivalent to ''

	the quote ', backquote ` and the command "go" do the same

   g0    go to /
   gu    go to /usr/
   gm    go to /media/
   gn    go to /mnt/
   ge    go to /etc/
   gs    go to /srv/
   gh    go to ~/
   gt    go to ~/.trash/

	all of this commands, and also quitting the program, will save
	the old directory at ` so you can re-enter it by typing `` or '' or TAB






	key:f
	/<expr>    Search for a "regular expression"
	f<expr>    Like / but enters/runs the first non-ambiguous match
	F<expr>    Shows only files which match the regular expression.
	n or N     goes to the next or previous match.
	           if you search for nothing, n goes to the newest file.

	What is a regular expression:
	A very flexible way of defining patterns in text. By writing
	Special characters, you can specify what to search:
		.       matches any character
		\\d      matches any digit
		\\w      matches any letter (ascii)
		\\s      matches any whitespace
		|       either the preceding or next expression may match
		{m,n}   at least m and at most n repetitions of the preceding
		*       zero or more repetitions of the preceding
		+       one or more repetitions of the preceding
		?       at most one repetition of the preceding
		^ or $  the beginning or the end of the string

	More at: http://www.ruby-doc.org/docs/UsersGuide/rg/regexp.html

	If you're just searching or a simple string, it's usually enough to write
	it down. To escape the special characters, precede them with a \\







	key:l
	Space:  Mark a file.  v:  Reverse markings   V:  Clear markings

	l or RIGHT   Enter the directory or run the file in mode 0, flag "a"
   L            Run in a different way: mode 1, no flags
	r<n><f>r     Run with mode <n> and flags <f>. example: r3adr
	             Default mode: 0, default flags: no flags at all

	What are flags:
	Letters that specify details on how ranger should run the program.
	Capital letters reverse the function. use as many flags as you want.

		a        Run the selection rather than just the highlighted file
		t        Run in a detached terminal (implies d)
		d or e   Run as a detached process inside the current terminal
		w        Wait for a <enter> after execution of the programm

	What are modes:
	A number from 0 to infinity that specifies what shell command should
	be executed, since most file types have different ways to be run.

	You can set up the commands for each type in the file  ranger/data/apps.rb






	
	key:c
	the word "selection" means
	if you marked something: all marked items and NOT the highlighted item
	otherwise: the selected item.
	
	mkdir<name>   creates directory
	touch<name>   creates file

   yy or cp    Memorize selection
	cut         like cp, but move instead of copy if "p" is pressed
	p           Copy memorized files here.
	o<key>      Copy selection to the bookmarked dir (see ?g)

	use deleteing commands with caution!
   dd:          Move selection to ~/.trash and memorize it's new path
	             (so it can be pasted with p)
	dfd:         Deletes the selection or empty directory
	delete:      Remove whole selection with all contents

   mv<name>:    move/rename file to <name>
	cw<name>:    same as mv
	A:           write "cw <name of current file>" to the key buffer







	key:o
	t            Toggle Option
	S            Change Sorting
	E            Edit file
	s            Enter Shell
   !<command>   Executes command
   !!<command>  Executes command and waits for enter-press afterwards
	term         Runs a detached terminal in the current directory
	block        Blocks the program, until you write: stop
	- or =       decreases or increases audio volume (alsa)









END
		hash = {}
		current = nil
		helptext.gsub("\t", "   ").each_line do |l|
			if l =~ /^\s*key:(.*)$/
				current = hash[$1] = ""
			elsif current
				current << l
			end
		end
		return hash
	end

	HELP = get_help
end
