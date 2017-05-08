__aws_prompt ()
{
  # Use this var to control display of the AWS prompt.
  if [[ "1" == "${AWS_PS1_SHOW}" ]]; then
    if [[ "x" != "x${AWS_DEFAULT_PROFILE}" ]]; then
      printf -- '[%s]' " aws:${AWS_DEFAULT_PROFILE}"
    else
      printf -- '[%s]' " aws:default"
    fi
  fi
}
