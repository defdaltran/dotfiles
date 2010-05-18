#!/usr/bin/env bash
# ------------------------------------------------------------------------------
# Description
#   "Modular" bash_profile/bash_rc/zshrc.
#     - First executes every script in header/enabled to output a
#       custom terminal header or welcome screen.
#     - Then sources the configs in configs/
#       * configs/active/: sources every file found recursively.
#       * configs/prompt/: prompts the user to source every file
#         found recursively.
#
# Usage
#   The directory structure must be as follows:
#       $HOME
#       └─ .shell.d
#          ├─ configs
#          │  ├─ enabled
#          │  ├─ disabled
#          │  └─ prompt
#          └─ header
#             ├─ enabled
#             └─ disabled
#
#   Then make sure shellrc is sourced at bash startup, for example by
#   setting a symbolic link this way:
#     $ ln -s /path/to/this/file $HOME/.bash_profile
#     $ ln -s /path/to/this/file $HOME/.bashrc
#     $ ln -s /path/to/this/file $HOME/.zshrc
#
# Dependencies
#   * Commands: awk, tput, read, source, test.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------


# Ask the user a "yes/no" question. Defaults to "no".
#
# Arguments
#     1 (optional) the question to ask.
shellrc_ask ()
{
  read -s -n1 -p "$@ [y/N] " ans
  case "$ans" in
    y*|Y*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}


# Print a line.
#
# Arguments
#     1 (required) the first character.
#     2 (required) the character repeated to draw the line.
#     3 (required) the last character.
#     4 (optional) the length of the line to print.
shellrc_print-line ()
{
  local line_length=${4:-$(tput cols)}
  echo -ne "$1"
  echo -ne `echo ""|awk '
  {
    _SPACES = '${line_length}'
    while (_SPACES-- > 2) printf ("'$2'")
  }'`
  echo -e "$3"
}


# Print the top line.
shellrc_print-top-line()
{
  local host_name
  if [[ $SHELL_TYPE == 'bash' ]]; then
    host_name=$HOSTNAME
  elif [[ $SHELL_TYPE == 'zsh' ]]; then
    host_name=$HOST
  fi
  echo -ne "──❮ ${SHELL_TYPE} ❯──❮ `set_color brown`$USER@$host_name`set_color normal` ❯"
  shellrc_print-line "─" "─" "─" "$(( `tput cols` - ${#USER} - ${#host_name} - ${#SHELL_TYPE} - 13 ))"
}


# Execute the header scripts.
shellrc_exec-headers ()
{
  local file

  # Loop through files in the header folder
  # (Trick: replace spaces in filenames with '&' to enter the for loop)
  for file in `find $SHELL_INIT_DIR/header/enabled/* ! -name '.*' -xtype f | sort | sed -e "s/ /\\&/g"`
  do

	# Restore spaces
	file=`echo $file | sed -e "s/\\&/ /g"`
        
    # If this is a file, execute it
    if [ -f "$file" ]; then
      eval "$file"
    fi
  done
}


# Source the given file.
#
# Arguments
#     1 (required) the file to source.
#
# Options
#     --ask Prompt the user before.
#           To be put before first argument.
shellrc_load-config ()
{
  # Handle the --ask option
  local ask=false
  if [ $1 = "--ask" ]; then
    shift
    ask=true
  fi

  # Extract a readable name from the file name
  # Example: "/home/user/folder/010_Aliases and functions.sh" => "Aliases and functions"
  local config_name="$(expr match "`echo $@`" '.*[/_]\([^\.]*\)')"
  
  # Determine wether we're going to laod this config
  local load=true
  if $ask; then
    if ! shellrc_ask "Load $config_name ?"; then
      load=false
    fi
  fi

  # Let's go
  if $load; then

    # Source the file
    source "`echo $@`" &> /tmp/SHELLRC_config_out.log

    # Append the output to the report if needed
    if [ -s /tmp/SHELLRC_config_out.log ]; then
      echo "`set_color -o blue`$config_name`set_color normal` > " >> /tmp/SHELLRC_configs_out
      (cat /tmp/SHELLRC_config_out.log | sed -e "s/\(.*\)/\ \ \1/g"; echo) >> /tmp/SHELLRC_configs_out
    fi

    # Update the configurations line
    if [ -z "${SHELLRC_CONFIGS_LINE}" ]; then
      export SHELLRC_CONFIGS_LINE="`set_color -o blue`Configs▸`set_color normal` $config_name"
    else
      export SHELLRC_CONFIGS_LINE=${SHELLRC_CONFIGS_LINE}" `set_color blue`▪`set_color normal` $config_name"
    fi
  fi
  
  # If we have asked, redraw now
  if $ask; then
    tput rc; tput ed
    echo -e "$SHELLRC_CONFIGS_LINE"
  fi
}


# Source the files recursively in the given folder.
#
# Arguments
#     1 (required) the folder to process.
#
# Options
#     --ask Prompt the user before loading each script.
#           To be put before first argument.
shellrc_load-folder-configs ()
{
  local file
  local load_opts=""
	
  # Handle the --ask option
  if [ $1 = "--ask" ]; then
    shift
    load_opts="--ask"
  fi
  
  # Declare a boolean to determine the success of the operation
  local success=true
  
  # Escape spaces in the folder name
  local folder=`echo $1 | sed -e "s/ /\\ /g"`
  
  # Check that a valid folder was given
  if [ -d "$folder" ]; then
    
    # Check the folder is not empty
    if [ `ls "$folder" | wc -l` -ne 0 ]; then
    
      # Loop through files in the folder
      # (Trick: replace spaces in filenames with '&' to enter the for loop)
      for file in `find $folder/* ! -name '.*' -xtype f | sort | sed -e "s/ /\\&/g"`
      do
      
        # Restore spaces
        file=`echo $file | sed -e "s/\\&/ /g"`

        # Try loading the config
        shellrc_load-config $load_opts $file
        
      done
      
    fi

  # If this is not a valid folder
  else
    echo -e "`set_color -o red`'$1' not found or invalid.`set_color normal`"
    success=false
  fi

  # If something went wrong, exit
  if ! $success; then
    `exit 1`
  fi
}


# Load the configurations
shellrc_load-configs ()
{
  # Save the current cursor position
  tput sc

  # Source scripts in active/
  shellrc_load-folder-configs "$SHELL_INIT_DIR/configs/enabled"
  [[ -n $SHELLRC_CONFIGS_LINE ]] && echo -e "$SHELLRC_CONFIGS_LINE"

  # Source scripts in prompt/ (ask first)
  shellrc_load-folder-configs --ask "$SHELL_INIT_DIR/configs/prompt"
}


# Print the configurations output report.
shellrc_print-configs-output ()
{
  if [ -s /tmp/SHELLRC_configs_out ]; then
    shellrc_print-line "`set_color red`─" "─" "─`set_color normal`"
    cat /tmp/SHELLRC_configs_out | head --lines=-1
    shellrc_print-line "`set_color red`─" "─" "─`set_color normal`"
  fi
}


# Resolve the shell used (Bash or Zsh) and set
# the $SHELL_TYPE variable.
shellrc_resolve-shell()
{
	if [[ -n $ZSH_VERSION ]]; then
	  export SHELL_TYPE='zsh'
	else
	  export SHELL_TYPE='bash'
	fi
}


# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve the shell type
shellrc_resolve-shell

# Declare the location of the initialization directory
export SHELL_INIT_DIR=$HOME/.shell.d

# Local variables declarations
SHELLRC_CONFIGS_LINE=""

# Clear the terminal
clear

# Clean traces from a previous execution
rm -f /tmp/SHELLRC_configs_out

# Blank line
echo

# Print the top line
shellrc_print-top-line

# Execute the header scripts
shellrc_exec-headers

# Load the configurations
shellrc_load-configs

# Print the footer line
shellrc_print-line "─" "─" "─"

# Print the configurations output
shellrc_print-configs-output

# Blank line
echo

# Unset all variables and functions to ensure their visibility stay local
unset SHELLRC_CONFIGS_LINE
unset -f shellrc_ask
unset -f shellrc_print-line
unset -f shellrc_print-top-line
unset -f shellrc_exec-headers
unset -f shellrc_load-config
unset -f shellrc_load-folder-configs
unset -f shellrc_load-configs
unset -f shellrc_print-configs-output
unset -f shellrc_resolve-shell
