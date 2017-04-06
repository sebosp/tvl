# bash/zsh k8s prompt
__k8s_prompt ()
{
  local c_lblue='\[\e[1;34m\]'
  local c_red='\[\e[31m\]'
  local c_clear='\[\e[0m\]'
  local inf_color="$c_red"
  local env_color="$c_blue"
  if [[ "0" == "${K8S_PS1_SHOW}" ]]; then
    echo ""
  else
    k8sctx=$(grep "current-context:" ~/.kube/config | cut -d' ' -f2)
    if [[ -z "${k8sctx}" ]]; then
        k8sctx=$(grep server: ~/.kube/config|cut -d: -f3|cut -d/ -f3|cut -c-14)
    fi
    if [[ "x" != "x${k8sctx}" ]]; then
        printf -- '[%s]' " ${inf_color}k8s:${env_color}${k8sctx}${c_clear}"
    fi
  fi
}
