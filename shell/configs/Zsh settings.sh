#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Description
#   General settings for the Zsh shell.
# ------------------------------------------------------------------------------

if [[ $SHELL_TYPE == 'zsh' ]]; then

  # Activate auto-completion
  autoload -Uz compinit
  compinit
  
  # Use Emacs line editing mode
  bindkey -e

  # ----------------------------------------------------------------------------
  # Options
  # ----------------------------------------------------------------------------

  # Changing Directories

  # If a command is issued that can't be executed as a normal command, and the
  # command is the name of a directory, perform the cd command to that directory.
  setopt AUTO_CD

  # Make cd push the old directory onto the directory stack.
  setopt AUTO_PUSHD

  # If the argument to a cd command (or an implied cd with the AUTO_CD option set)
  # is not a directory, and does not begin with a slash, try to expand the expression
  # as if it were preceded by a `~' (see Filename Expansion).
  setopt CDABLE_VARS

  # When changing to a directory containing a path segment `..' which would otherwise
  # be treated as canceling the previous segment in the path (in other words, `foo/..'
  # would be removed from the path, or if `..' is the first part of the path, the last
  # part of $PWD would be deleted), instead resolve the path to the physical directory.
  # This option is overridden by CHASE_LINKS.
  # For example, suppose /foo/bar is a link to the directory /alt/rod. Without this
  # option set, `cd /foo/bar/..' changes to /foo; with it set, it changes to /alt. The
  # same applies if the current directory is /foo/bar and `cd ..' is used. Note that
  # all other symbolic links in the path will also be resolved.  
  unsetopt CHASE_DOTS

  # Resolve symbolic links to their true values when changing directory. This also has
  # the effect of CHASE_DOTS, i.e. a `..' path segment will be treated as referring to
  # the physical parent, even if the preceding path segment is a symbolic link.
  setopt CHASE_LINKS

  # Don't push multiple copies of the same directory onto the directory stack.
  setopt PUSHD_IGNORE_DUPS

  # Exchanges the meanings of `+' and `-' when used with a number to specify a
  # directory in the stack.
  unsetopt PUSHD_MINUS

  # Do not print the directory stack after pushd or popd.
  unsetopt PUSHD_SILENT

  # Have pushd with no arguments act like `pushd $HOME'.
  setopt PUSHD_TO_HOME

  
  # Completion

  # If unset, key functions that list completions try to return to the last prompt if
  # given a numeric argument. If set these functions try to return to the last prompt
  # if given no numeric argument.
  setopt ALWAYS_LAST_PROMPT

  # If a completion is performed with the cursor within a word, and a full completion
  # is inserted, the cursor is moved to the end of the word. That is, the cursor is
  # moved to the end of the word if either a single match is inserted or menu
  # completion is performed.
  unsetopt ALWAYS_TO_END

  # Automatically list choices on an ambiguous completion.
  setopt AUTO_LIST

  # Automatically use menu completion after the second consecutive request for
  # completion, for example by pressing the tab key repeatedly. This option is
  # overridden by MENU_COMPLETE.
  setopt AUTO_MENU

  # Any parameter that is set to the absolute name of a directory immediately becomes
  # a name for that directory, that will be used by the `%~' and related prompt
  # sequences, and will be available when completion is performed on a word starting
  # with `~'. (Otherwise, the parameter must be used in the form `~param' first.)
  setopt AUTO_NAME_DIRS

  # If a parameter name was completed and a following character (normally a space)
  # automatically inserted, and the next character typed is one of those that have to
  # come directly after the name (like `}', `:', etc.), the automatically added
  # character is deleted, so that the character typed comes immediately after the
  # parameter name. Completion in a brace expansion is affected similarly: the added
  # character is a `,', which will be removed if `}' is typed next.
  setopt AUTO_PARAM_KEYS

  # If a parameter is completed whose content is the name of a directory, then add a
  # trailing slash instead of a space.
  setopt AUTO_PARAM_SLASH

  # When the last character resulting from a completion is a slash and the next
  # character typed is a word delimiter, a slash, or a character that ends a command
  # (such as a semicolon or an ampersand), remove the slash.
  setopt AUTO_REMOVE_SLASH

  # On an ambiguous completion, automatically list choices when the completion function
  # is called twice in succession. This takes precedence over AUTO_LIST. The setting of
  # LIST_AMBIGUOUS is respected. If AUTO_MENU is set, the menu behaviour will then
  # start with the third press. Note that this will not work with MENU_COMPLETE, since
  # repeated completion calls immediately cycle through the list in that case.
  unsetopt BASH_AUTO_LIST

  # Prevents aliases on the command line from being internally substituted before
  # completion is attempted. The effect is to make the alias a distinct command for
  # completion purposes.
  unsetopt COMPLETE_ALIASES

  # If unset, the cursor is set to the end of the word if completion is started.
  # Otherwise it stays there and completion is done from both ends.
  setopt COMPLETE_IN_WORD

  # When the current word has a glob pattern, do not insert all the words resulting
  # from the expansion but generate matches as for completion and cycle through them
  # like MENU_COMPLETE. The matches are generated as if a `*' was added to the end of
  # the word, or inserted at the cursor when COMPLETE_IN_WORD is set. This actually uses
  # pattern matching, not globbing, so it works not only for files but for any
  # completion, such as options, user names, etc.
  # Note that when the pattern matcher is used, matching control (for example, case-
  # insensitive or anchored matching) cannot be used. This limitation only applie
  # when the current word contains a pattern; simply turning on the GLOB_COMPLETE option
  # does not have this effect.
  setopt GLOB_COMPLETE

  # Whenever a command completion is attempted, make sure the entire command path is
  # hashed first. This makes the first completion slower.
  setopt HASH_LIST_ALL

  # This option works when AUTO_LIST or BASH_AUTO_LIST is also set. If there is an
  # unambiguous prefix to insert on the command line, that is done without a completion
  # list being displayed; in other words, auto-listing behaviour only takes place when
  # nothing would be inserted. In the case of BASH_AUTO_LIST, this means that the list
  # will be delayed to the third call of the function.
  setopt LIST_AMBIGUOUS

  # Beep on an ambiguous completion. More accurately, this forces the completion widgets
  # to return status 1 on an ambiguous completion, which causes the shell to beep if the
  # option BEEP is also set; this may be modified if completion is called from a user-
  # defined widget.
  unsetopt LIST_BEEP

  # Try to make the completion list smaller (occupying less lines) by printing the
  # matches in columns with different widths.
  setopt LIST_PACKED

  # Lay out the matches in completion lists sorted horizontally, that is, the second match
  # is to the right of the first one, not under it as usual.
  unsetopt LIST_ROWS_FIRST

  # When listing files that are possible completions, show the type of each file with a
  # trailing identifying mark.
  setopt LIST_TYPES

  # On an ambiguous completion, instead of listing possibilities or beeping, insert the
  # first match immediately. Then when completion is requested again, remove the first match
  # and insert the second match, etc. When there are no more matches, go back to the first
  # one again. reverse-menu-complete may be used to loop through the list in the other
  # direction. This option overrides AUTO_MENU.
  unsetopt MENU_COMPLETE

  # In completion, recognize exact matches even if they are ambiguous.
  unsetopt REC_EXACT

  
  # Expansion and Globbing

  # If a pattern for filename generation is badly formed, print an error message. (If this
  # option is unset, the pattern will be left unchanged.)
  setopt BAD_PATTERN

  # In a glob pattern, treat a trailing set of parentheses as a qualifier list, if it
  # contains no `|', `(' or (if special) `~' characters. See Filename Generation.
  unsetopt BARE_GLOB_QUAL

  # Expand expressions in braces which would not otherwise undergo brace expansion to a
  # lexically ordered list of all the characters. See Brace Expansion.
  unsetopt BRACE_CCL

  # Make globbing (filename generation) sensitive to case. Note that other uses of patterns
  # are always sensitive to case. If the option is unset, the presence of any character which
  # is special to filename generation will cause case-insensitive matching. For example, cvs(/)
  # can match the directory CVS owing to the presence of the globbing flag (unless the option
  # BARE_GLOB_QUAL is unset).
  unsetopt CASE_GLOB

  # Make regular expressions using the zsh/regex module (including matches with =~) sensitive
  # to case.
  setopt CASE_MATCH

  # If a pattern for filename generation has no matches, delete the pattern from the argument
  # list; do not report an error unless all the patterns in a command have no matches.
  # Overrides NOMATCH.
  unsetopt CSH_NULL_GLOB

  # Perform = filename expansion. (See Filename Expansion.)
  setopt EQUALS

  # Treat the `#', `~' and `^' characters as part of patterns for filename generation, etc.
  # (An initial unquoted `~' always produces named directory expansion.)
  setopt EXTENDED_GLOB

  # Perform filename generation (globbing). (See Filename Generation.)
  setopt GLOB

  # If this option is set, filename generation (globbing) is performed on the right hand side
  # of scalar parameter assignments of the form `name=pattern (e.g. `foo=*'). If the result
  # has more than one word the parameter will become an array with those words as arguments.
  # This option is provided for backwards compatibility only: globbing is always performed on
  # the right hand side of array assignments of the form `name=(value)' (e.g. `foo=(*)') and
  # this form is recommended for clarity; with this option set, it is not possible to predict
  # whether the result will be an array or a scalar.
  unsetopt GLOB_ASSIGN

  # Do not require a leading `.' in a filename to be matched explicitly.
  setopt GLOB_DOTS

  # Treat any characters resulting from parameter expansion as being eligible for file
  # expansion and filename generation, and any characters resulting from command substitution
  # as being eligible for filename generation. Braces (and commas in between) do not become
  # eligible for expansion.
  unsetopt GLOB_SUBST

  # Substitutions using the :s and :& history modifiers are performed with pattern matching
  # instead of string matching. This occurs wherever history modifiers are valid, including
  # glob qualifiers and parameters. See Modifiers.
  unsetopt HIST_SUBST_PATTERN

  # Do not perform brace expansion.
  unsetopt IGNORE_BRACES

  # In pattern matching, the interpretation of parentheses is affected by a preceding `@', `*',
  # `+', `?' or `!'. See Filename Generation.
  unsetopt KSH_GLOB

  # All unquoted arguments of the form `anything=expression' appearing after the command name
  # have filename expansion (that is, where expression has a leading `~' or `=') performed on
  # expression as if it were a parameter assignment. The argument is not otherwise treated
  # specially; it is passed to the command as a single argument, and not used as an actual
  # parameter assignment. For example, in echo foo=~/bar:~/rod, both occurrences of ~ would
  # be replaced. Note that this happens anyway with typeset and similar statements.
  # This option respects the setting of the KSH_TYPESET option. In other words, if both options
  # are in effect, arguments looking like assignments will not undergo word splitting.
  unsetopt MAGIC_EQUAL_SUBST

  # Append a trailing `/' to all directory names resulting from filename generation (globbing).
  unsetopt MARK_DIRS

  # Respect multibyte characters when found in strings. When this option is set, strings are
  # examined using the system library to determine how many bytes form a character, depending
  # on the current locale. This affects the way characters are counted in pattern matching,
  # parameter values and various delimiters.
  # The option is on by default if the shell was compiled with MULTIBYTE_SUPPORT except in sh
  # emulation; otherwise it is off by default and has no effect if turned on. The mode is off
  # in sh emulation for compatibility but for interactive use may need to be turned on if the
  # terminal interprets multibyte characters.
  # If the option is off a single byte is always treated as a single character. This setting
  # is designed purely for examining strings known to contain raw bytes or other values that
  # may not be characters in the current locale. It is not necessary to unset the option
  # merely because the character set for the current locale does not contain multibyte
  # characters.
  # The option does not affect the shell's editor, which always uses the locale to determine
  # multibyte characters. This is because the character set displayed by the terminal emulator
  # is independent of shell settings.
  setopt MULTIBYTE

  # If a pattern for filename generation has no matches, print an error, instead of leaving it
  # unchanged in the argument list. This also applies to file expansion of an initial `~' or `='.
  setopt NOMATCH
  
  # If a pattern for filename generation has no matches, delete the pattern from the argument
  # list instead of reporting an error. Overrides NOMATCH.
  unsetopt NULL_GLOB

  # If numeric filenames are matched by a filename generation pattern, sort the filenames
  # numerically rather than lexicographically.
  unsetopt NUMERIC_GLOB_SORT

  # Array expansions of the form `foo${xx}bar', where the parameter xx is set to (a b c), are
  # substituted with `fooabar foobbar foocbar' instead of the default `fooa b cbar'. Note that
  # an empty array will therefore cause all arguments to be removed.
  setopt RC_EXPAND_PARAM

  # If set, regular expression matching with the =~ operator will use Perl-Compatible Regular
  # Expressions from the PCRE library, if available. If not set, regular expressions will use
  # the extended regexp syntax provided by the system libraries.
  setopt REMATCH_PCRE

  # Disables the special meaning of `(', `|', `)' and '<' for globbing the result of parameter
  # and command substitutions, and in some other places where the shell accepts patterns. This
  # option is set by default if zsh is invoked as sh or ksh.
  unsetopt SH_GLOB

  # Treat unset parameters as if they were empty when substituting. Otherwise they are treated
  # as an error.
  setopt UNSET

  # Print a warning message when a global parameter is created in a function by an assignment.
  # This often indicates that a parameter has not been declared local when it should have been.
  # Parameters explicitly declared global from within a function using typeset -g do not cause
  # a warning. Note that there is no warning when a local parameter is assigned to in a nested
  # function, which may also indicate an error.
  setopt WARN_CREATE_GLOBAL
  
  
  # History

  # If this is set, zsh sessions will append their history list to the history file, rather than
  # replace it. Thus, multiple parallel zsh sessions will all have the new entries from their
  # history lists added to the history file, in the order that they exit. The file will still
  # be periodically re-written to trim it when the number of lines grows 20% beyond the value
  # specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
  setopt APPEND_HISTORY

  # Perform textual history expansion, csh-style, treating the character `!' specially.
  setopt BANG_HIST

  # Save each command's beginning timestamp (in seconds since the epoch) and the duration (in
  # seconds) to the history file. The format of this prefixed data is:
  # `:<beginning time>:<elapsed seconds>:<command>'.
  setopt EXTENDED_HISTORY

  # Add `|' to output redirections in the history. This allows history references to clobber
  # files even when CLOBBER is unset.
  unsetopt HIST_ALLOW_CLOBBER

  # Beep when an attempt is made to access a history entry which isn't there.
  unsetopt HIST_BEEP

  # If the internal history needs to be trimmed to add the current command line, setting this
  # option will cause the oldest history event that has a duplicate to be lost before losing a
  # unique event from the list. You should be sure to set the value of HISTSIZE to a larger
  # number than SAVEHIST in order to give you some room for the duplicated events, otherwise
  # this option will behave just like HIST_IGNORE_ALL_DUPS once the history fills up with
  # unique events.
  setopt HIST_EXPIRE_DUPS_FIRST

  # When writing out the history file, by default zsh uses ad-hoc file locking to avoid known
  # problems with locking on some operating systems. With this option locking is done by means
  # of the system's fcntl call, where this method is available. On recent operating systems this
  # may provide better performance, in particular avoiding history corruption when files are
  # stored on NFS.
  unsetopt HIST_FCNTL_LOCK

  # When searching for history entries in the line editor, do not display duplicates of a line
  # previously found, even if the duplicates are not contiguous.
  setopt HIST_FIND_NO_DUPS

  # If a new command line being added to the history list duplicates an older one, the older
  # command is removed from the list (even if it is not the previous event).
  setopt HIST_IGNORE_ALL_DUPS

  # Do not enter command lines into the history list if they are duplicates of the previous event.
  setopt HIST_IGNORE_DUPS

  # Remove command lines from the history list when the first character on the line is a space,
  # or when one of the expanded aliases contains a leading space. Note that the command lingers
  # in the internal history until the next command is entered before it vanishes, allowing you
  # to briefly reuse or edit the line. If you want to make it vanish right away without entering
  # another command, type a space and press return.
  setopt HIST_IGNORE_SPACE

  # Remove function definitions from the history list. Note that the function lingers in the
  # internal history until the next command is entered before it vanishes, allowing you to briefly
  # reuse or edit the definition.
  unsetopt HIST_NO_FUNCTIONS

  # Remove the history (fc -l) command from the history list when invoked. Note that the command
  # lingers in the internal history until the next command is entered before it vanishes, allowing
  # you to briefly reuse or edit the line.
  setopt HIST_NO_STORE

  # Remove superfluous blanks from each command line being added to the history list.
  setopt HIST_REDUCE_BLANKS

  # When the history file is re-written, we normally write out a copy of the file named $HISTFILE.new
  # and then rename it over the old one. However, if this option is unset, we instead truncate the old
  # history file and write out the new version in-place. If one of the history-appending options is
  # enabled, this option only has an effect when the enlarged history file needs to be re-written to
  # trim it down to size. Disable this only if you have special needs, as doing so makes it possible
  # to lose history entries if zsh gets interrupted during the save.
  # When writing out a copy of the history file, zsh preserves the old file's permissions and group
  # information, but will refuse to write out a new file if it would change the history file's owner.
  setopt HIST_SAVE_BY_COPY

  # When writing out the history file, older commands that duplicate newer ones are omitted.
  setopt HIST_SAVE_NO_DUPS

  # Whenever the user enters a line with history expansion, don't execute the line directly; instead,
  # perform history expansion and reload the line into the editing buffer.
  setopt HIST_VERIFY

  # This options works like APPEND_HISTORY except that new history lines are added to the $HISTFILE
  # incrementally (as soon as they are entered), rather than waiting until the shell exits. The file will
  # still be periodically re-written to trim it when the number of lines grows 20% beyond the value
  # specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
  setopt INC_APPEND_HISTORY

  # This option both imports new commands from the history file, and also causes your typed commands to
  # be appended to the history file (the latter is like specifying INC_APPEND_HISTORY). The history lines
  # are also output with timestamps ala EXTENDED_HISTORY (which makes it easier to find the spot where we
  # left off reading the file after it gets re-written).
  # By default, history movement commands visit the imported lines as well as the local lines, but you can
  # toggle this on and off with the set-local-history zle binding. It is also possible to create a zle
  # widget that will make some commands ignore imported commands, and some include them.
  # If you find that you want more control over when commands get imported, you may wish to turn
  # SHARE_HISTORY off, INC_APPEND_HISTORY on, and then manually import commands whenever you need them
  # using `fc -RI'.
  setopt SHARE_HISTORY

  
  # Initialisation

  # TODO
  
  
  # Input/Output

  # TODO
  
  
  # Job Control

  # TODO
  
  
  # Prompting

  # TODO
  
  
  # Scripts and Functions

  # TODO
  
  
  # Shell Emulation

  # TODO
  
  
  # Shell State

  # TODO
  
  
  # Zle

  # TODO
  

fi
