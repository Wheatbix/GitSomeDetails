############################################################################################################################################################
# IFS=Internal Field Separator
############################################################################################################################################################
IFS=$'|' # Make sure we split on '|' as the default is ' ' and we are formatting data that will include multiple spaces

############################################################################################################################################################
# Global Style Variables 
############################################################################################################################################################
# Text Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`

# Sets BG Color
red_bg=`tput setab 1`
green_bg=`tput setab 2`
yellow_bg=`tput setab 3`
blue_bg=`tput setab 4`
magenta_bg=`tput setab 5`
cyan_bg=`tput setab 6`
white_bg=`tput setab 7`

# additional options
bold=`tput bold`           # Select bold mode
dim=`tput dim`             # Select dim (half-bright) mode
smul=`tput smul`           # Enable underline mode
rmul=`tput rmul`           # Disable underline mode
rev=`tput rev`             # Turn on reverse video mode
smso=`tput smso`           # Enter standout (bold) mode
rmso=`tput rmso`           # Exit standout mode
bell=`tput bel`            # Play a bell
reset=`tput sgr0`          # Reset text format to the terminal's default

############################################################################################################################################################
# Read more at: https://www.computerhope.com/unix/uprintf.htm
# Explains printf and how we handle placeholders, widths and formatting
############################################################################################################################################################
header_format="%s %-15s %s%-15s %s%-55.53s %s%-25s %s%-23s %s%-27s %s\n"
header_style="${blue_bg}${white}${bold}"
header_seperator="| "

body_format="%s %s%-5s%s%-5s%s%-5s %s%s%-5s%s%-5s%s%-5s %s%s%-55.53s %s%s%-25s %s%s%-23s %s%s%-27s %s\n"
body_seperator="${reset}${blue_bg}${white}${bold}|${reset}${bold} "
body_branch_color="${yellow}"
body_lastuser_color="${white}"
body_lastupdated_color="${green}"
body_updateddate_color="${cyan}"

body_behind_none="${reset}${bold}";
body_behind_small="${reset}${cyan}${bold}";
body_behind_medium="${reset}${yellow}${bold}";
body_behind_large="${reset}${red}${bold}";