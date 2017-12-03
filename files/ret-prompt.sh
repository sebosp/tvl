__prompt_command() {
    local EXIT="$?"
    RCol='\e[0m'
    if [[ "1" == "${RET_PS1_SHOW}" ]]; then
      Red='\e[0;31m'
      Gre='\e[0;32m'
      BYel='\e[1;33m'
  
      if [[ "0" == "$EXIT" ]]; then
          printf -- "${Gre}@" ""
      elif [[ "127" == "$EXIT" ]]; then
          printf -- "${BYel}@" ""
      else
          printf -- "${Red}@" ""
      fi
  
    else
      printf -- "${Rcol}%s@" ""
    fi
}
