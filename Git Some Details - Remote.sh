####################################
# Load Common Variables and Config #
####################################
source Common.sh

# Show the header
printf "$header_format" "$header_style" "Mrgd to master" "$header_seperator" "Mrgd to develop" "$header_seperator" "Branch" "$header_seperator" "Last User" "$header_seperator" "Last Updated" "$header_seperator" "Updated Date" "${reset}"

git for-each-ref refs/remotes/ --sort='-committerdate' --format='%(refname)|%(refname:lstrip=3)|%(authorname)|%(committerdate:relative)|%(committerdate:iso8601)' |
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
  
  if git merge-base --is-ancestor $refname origin/master;
  then
    merged_into_master_value="(Y)"
    merged_into_master_style="${green}"
  else                  
    merged_into_master_value="(N)"
    merged_into_master_style="${red}"
  fi
  
  if git merge-base --is-ancestor $refname origin/develop;
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
  
  printf "$body_format" "${reset}${bold}" "$merged_into_master_style" "$merged_into_master_value" "$body_behind_master_style" "$body_behind_master_value" "$body_ahead_master_style" "$body_ahead_master_value" "$body_seperator" "$merged_into_develop_style" "$merged_into_develop_value" "$body_behind_develop_style" "$body_behind_develop_value" "$body_ahead_develop_style" "$body_ahead_develop_value" "$body_seperator" "${reset}${bold}$body_branch_color" "$refnameformatted" "$body_seperator" "$body_lastuser_color" "$authorname" "$body_seperator" "$body_lastupdated_color" "($committerdaterelative)" "$body_seperator" "${reset}${bold}$body_updateddate_color" "$committerdateiso8601" "${reset}"
  
done

printf "$header_format" "$header_style" "" "$header_seperator" "" "$header_seperator" "" "$header_seperator" "" "$header_seperator" "" "$header_seperator" "" "${reset}"
printf "${reset}" # Ensure the command text is reset (Only applicable if running the Shell Script from a command line tool)

sleep infinity;