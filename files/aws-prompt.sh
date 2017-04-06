__aws_prompt ()
{
    # If this var is exported, we won't display the K8s prompt.
    if [[ "0" == "${AWS_PS1_SHOW}" ]]; then
      echo ""
    else
      if [[ "x" != "x${AWS_DEFAULT_PROFILE}" ]]; then
          echo "[aws:${AWS_DEFAULT_PROFILE}]"
      else
          echo "[aws:default]"
      fi
    fi
}
