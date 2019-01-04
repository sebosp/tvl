__k8s_prompt ()
{
  # Use this var to control display of the AWS prompt.
  if [[ "1" == "${K8S_PS1_SHOW}" ]]; then
    if [[ -z "$K8S_PROMPT_TTL" ]]; then
      export K8S_PROMPT_TTL=15
    fi
    if [[ -z "$K8S_LAST_PROMPT_CHECK" ]]; then
      export K8S_LAST_PROMPT_CHECK=$(date +'%s')
    fi
    if [[ $(($K8S_PROMPT_TTL + $K8S_LAST_PROMPT_CHECK)) < $(date +'%s') ]]; then
      export K8SCTX=$(kubectl config current-context 2>/dev/null)
      export K8SNS=$(kubectl config view -o json|jq ".contexts | map(select(.name| contains(\"$K8SCTX\")))[0]|.context.namespace" -r|cut -c-10)
      export K8S_LAST_PROMPT_CHECK=$(date +'%s')
    fi
    if [[ -z "${K8SCTX}" ]]; then
      export K8SCTX="NONE"
    fi
    if [[ "null" == "${K8SNS}" ]]; then
      export K8SNS="default"
    fi
    if [[ "x" != "x${K8SCTX}" ]]; then
      printf -- '%s\e[33m[%s]' "${K8SCTX}" "${K8SNS}"
    fi
  fi
}
