##########################
# Global Style Variables #
##########################
red=`tput setaf 1`         # Sets Text Color
green=`tput setaf 2`       # Sets Text Color
yellow=`tput setaf 3`      # Sets Text Color
blue=`tput setaf 4`        # Sets Text Color
magenta=`tput setaf 5`     # Sets Text Color
cyan=`tput setaf 6`        # Sets Text Color
white=`tput setaf 7`       # Sets Text Color
red_bg=`tput setab 1`      # Sets BG Color
green_bg=`tput setab 2`    # Sets BG Color
yellow_bg=`tput setab 3`   # Sets BG Color
blue_bg=`tput setab 4`     # Sets BG Color
magenta_bg=`tput setab 5`  # Sets BG Color
cyan_bg=`tput setab 6`     # Sets BG Color
white_bg=`tput setab 7`    # Sets BG Color
bold=`tput bold`           # Select bold mode
dim=`tput dim`             # Select dim (half-bright) mode
smul=`tput smul`           # Enable underline mode
rmul=`tput rmul`           # Disable underline mode
rev=`tput rev`             # Turn on reverse video mode
smso=`tput smso`           # Enter standout (bold) mode
rmso=`tput rmso`           # Exit standout mode
bell=`tput bel`            # Play a bell
reset=`tput sgr0`          # Reset text format to the terminal's default

##############################################################################################
# Below is the old way of jsut showing the details, there was not need to logical evaluation #
##############################################################################################
#echo "${bell}${yellow}${blue_bg}${bold}Branch Details${reset}";
#git for-each-ref refs/remotes/ --sort='-committerdate' --format='%(color:yellow)%(refname:lstrip=3)%(color:reset) - %(authorname) - (%(color:green)%(committerdate:relative)%(color:reset)) - %(color:cyan)%(committerdate:iso8601)%(color:cyan)' \ | awk 'BEGIN { FS = " - "; } ; { printf "%-50s %-25s %-30s %s\n", $1, $2, $3, $4;  } ; END { print "\n"NR,"Records Processed"; }';
##############################################################################################

IFS=$'|' # Make sure we split on '|' as the default is ' ' and we are formatting data that will include multiple spaces
count=0

# Read more at: https://www.computerhope.com/unix/uprintf.htm
# Explains printf and how we handel placeholders, widths and formatting
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

git for-each-ref refs/heads/ --sort='-committerdate' --format='%(refname)|%(refname:lstrip=2)|%(authorname)|%(committerdate:relative)|%(committerdate:iso8601)' |
while read refname refnameformatted authorname committerdaterelative committerdateiso8601; 
do
  merged_into_master_value="ERROR"
  merged_into_master_style="${reset}${bold}"
  merged_into_develop_value="ERROR"
  merged_into_develop_style="${reset}${bold}"
  
  body_behind_master_value="-"
  body_ahead_master_value="-"
  body_behind_develop_value="-"
  body_ahead_develop_value="-"
  
  body_behind_master_style="${reset}${bold}";
  body_ahead_master_style="${reset}${bold}";
  body_behind_develop_style="${reset}${bold}";
  body_ahead_develop_style="${reset}${bold}";
  
  if git merge-base --is-ancestor $refname master;
  then
    merged_into_master_value="(Y)"
    merged_into_master_style="${green}"
  else                  
    merged_into_master_value="(N)"
    merged_into_master_style="${red}"
  fi
  
  if git merge-base --is-ancestor $refname develop;
  then
    merged_into_develop_value="(Y)"
    merged_into_develop_style="${green}"
  else
    merged_into_develop_value="(N)"
    merged_into_develop_style="${red}"
  fi
  
  if [ $refnameformatted == "master" ] || [ $refnameformatted == "develop" ]
  then
    merged_into_master_value=" - "
    merged_into_master_style="${reset}${bold}"
    merged_into_develop_value=" - "
    merged_into_develop_style="${reset}${bold}"
  fi
  
  if [ $refnameformatted != "master" ]
  then
    body_behind_master_value=$(git rev-list --left-only --count master...$refname)
    body_ahead_master_value=$(git rev-list --right-only --count master...$refname)
    
    if (( $body_behind_master_value == 0 ));
    then
      body_behind_master_style="${body_behind_none}"
    elif (( $body_behind_master_value > 0 )) && (( $body_behind_master_value < 10 ));
    then
      body_behind_master_style="${body_behind_small}"
    elif (( $body_behind_master_value > 10 )) && (( $body_behind_master_value < 50 ));
    then
      body_behind_master_style="${body_behind_medium}"
    elif (( $body_behind_master_value > 50 ));
    then
      body_behind_master_style="${body_behind_large}"
    fi
    
    if (( $body_ahead_master_value == 0 ));
    then
      body_ahead_master_style="${body_behind_none}"
    elif (( $body_ahead_master_value > 0 )) && (( $body_ahead_master_value < 10 ));
    then
      body_ahead_master_style="${body_behind_small}"
    elif (( $body_ahead_master_value > 10 )) && (( $body_ahead_master_value < 50 ));
    then
      body_ahead_master_style="${body_behind_medium}"
    elif (( $body_ahead_master_value > 50 ));
    then
      body_ahead_master_style="${body_behind_large}"
    fi
  fi
  
  if [ $refnameformatted != "develop" ]
  then
    body_behind_develop_value=$(git rev-list --left-only --count develop...$refname)
    body_ahead_develop_value=$(git rev-list --right-only --count develop...$refname)
    
    if (( $body_behind_develop_value == 0 ));
    then
      body_behind_develop_style="${body_behind_none}"
    elif (( $body_behind_develop_value > 0 )) && (( $body_behind_develop_value < 10 ));
    then
      body_behind_develop_style="${body_behind_small}"
    elif (( $body_behind_develop_value > 10 )) && (( $body_behind_develop_value < 50 ));
    then
      body_behind_develop_style="${body_behind_medium}"
    elif (( $body_behind_develop_value > 50 ));
    then
      body_behind_develop_style="${body_behind_large}"
    fi
    
    if (( $body_ahead_develop_value == 0 ));
    then
      body_ahead_develop_style="${body_behind_none}"
    elif (( $body_ahead_develop_value > 0 )) && (( $body_ahead_develop_value < 10 ));
    then
      body_ahead_develop_style="${body_behind_small}"
    elif (( $body_ahead_develop_value > 10 )) && (( $body_ahead_develop_value < 50 ));
    then
      body_ahead_develop_style="${body_behind_medium}"
    elif (( $body_ahead_develop_value > 50 ));
    then
      body_ahead_develop_style="${body_behind_large}"
    fi
  fi
  
  #if [ $refnameformatted == "master" ] || [ $refnameformatted == "develop" ];
  #then
  #  merged_into_master_value=" - "
  #  merged_into_master_style="${reset}${bold}"
  #  merged_into_develop_value=" - "
  #  merged_into_develop_style="${reset}${bold}"
  #else 
  #  body_behind_master_value=$(git rev-list --left-only --count master...$refname)
  #  body_ahead_master_value=$(git rev-list --right-only --count master...$refname)
  #  body_behind_develop_value=$(git rev-list --left-only --count develop...$refname)
  #  body_ahead_develop_value=$(git rev-list --right-only --count develop...$refname)
  #
  #  if (( $body_behind_master_value == 0 ));
  #  then
  #    body_behind_master_style="${body_behind_none}"
  #  elif (( $body_behind_master_value > 0 )) && (( $body_behind_master_value < 10 ));
  #  then
  #    body_behind_master_style="${body_behind_small}"
  #  elif (( $body_behind_master_value > 10 )) && (( $body_behind_master_value < 50 ));
  #  then
  #    body_behind_master_style="${body_behind_medium}"
  #  elif (( $body_behind_master_value > 50 ));
  #  then
  #    body_behind_master_style="${body_behind_large}"
  #  fi
  #  
  #  if (( $body_ahead_master_value == 0 ));
  #  then
  #    body_ahead_master_style="${body_behind_none}"
  #  elif (( $body_ahead_master_value > 0 )) && (( $body_ahead_master_value < 10 ));
  #  then
  #    body_ahead_master_style="${body_behind_small}"
  #  elif (( $body_ahead_master_value > 10 )) && (( $body_ahead_master_value < 50 ));
  #  then
  #    body_ahead_master_style="${body_behind_medium}"
  #  elif (( $body_ahead_master_value > 50 ));
  #  then
  #    body_ahead_master_style="${body_behind_large}"
  #  fi
  #  
  #  if (( $body_behind_develop_value == 0 ));
  #  then
  #    body_behind_develop_style="${body_behind_none}"
  #  elif (( $body_behind_develop_value > 0 )) && (( $body_behind_develop_value < 10 ));
  #  then
  #    body_behind_develop_style="${body_behind_small}"
  #  elif (( $body_behind_develop_value > 10 )) && (( $body_behind_develop_value < 50 ));
  #  then
  #    body_behind_develop_style="${body_behind_medium}"
  #  elif (( $body_behind_develop_value > 50 ));
  #  then
  #    body_behind_develop_style="${body_behind_large}"
  #  fi
  #  
  #  if (( $body_ahead_develop_value == 0 ));
  #  then
  #    body_ahead_develop_style="${body_behind_none}"
  #  elif (( $body_ahead_develop_value > 0 )) && (( $body_ahead_develop_value < 10 ));
  #  then
  #    body_ahead_develop_style="${body_behind_small}"
  #  elif (( $body_ahead_develop_value > 10 )) && (( $body_ahead_develop_value < 50 ));
  #  then
  #    body_ahead_develop_style="${body_behind_medium}"
  #  elif (( $body_ahead_develop_value > 50 ));
  #  then
  #    body_ahead_develop_style="${body_behind_large}"
  #  fi
  #fi
  
  if (( $count == 0 ));
  then
    count=1
    printf "$header_format" "$header_style" "Mrgd to master" "$header_seperator" "Mrgd to develop" "$header_seperator" "Branch" "$header_seperator" "Last User" "$header_seperator" "Last Updated" "$header_seperator" "Updated Date" "${reset}"
  fi
  
  printf "$body_format" "${reset}${bold}" "$merged_into_master_style" "$merged_into_master_value" "$body_behind_master_style" "$body_behind_master_value" "$body_ahead_master_style" "$body_ahead_master_value" "$body_seperator" "$merged_into_develop_style" "$merged_into_develop_value" "$body_behind_develop_style" "$body_behind_develop_value" "$body_ahead_develop_style" "$body_ahead_develop_value" "$body_seperator" "${reset}${bold}$body_branch_color" "$refnameformatted" "$body_seperator" "$body_lastuser_color" "$authorname" "$body_seperator" "$body_lastupdated_color" "($committerdaterelative)" "$body_seperator" "${reset}${bold}$body_updateddate_color" "$committerdateiso8601" "${reset}"
  
done

printf "$header_format" "$header_style" "" "$header_seperator" "" "$header_seperator" "" "$header_seperator" "" "$header_seperator" "" "$header_seperator" "" "${reset}"
printf "${reset}" # Ensure the command text is reset (Only applicable if running the Shell Script from a command line tool)

sleep infinity;