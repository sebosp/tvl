__aws_prompt ()
{
  # Use this var to control display of the AWS prompt.
  Red='\e[0;31m'
  if [[ "1" == "${AWS_PS1_SHOW}" ]]; then
    if [[ "x" != "x${AWS_DEFAULT_PROFILE}" ]]; then
      printf -- "${Red}%s" "${AWS_DEFAULT_PROFILE}"
    else
      printf -- "${Red}%s" "default"
    fi
  fi
}
