__k8s_prompt ()
{
  # Use this var to control display of the AWS prompt.
  if [[ "1" == "${K8S_PS1_SHOW}" ]]; then
    k8sctx=$(grep "current-context:" ~/.kube/config | cut -d' ' -f2)
    if [[ -z "${k8sctx}" ]]; then
      k8sctx=$(grep server: ~/.kube/config|cut -d: -f3|cut -d/ -f3|cut -c-14)
    fi
    if [[ "x" != "x${k8sctx}" ]]; then
      printf -- '[%s]' " k8s:${k8sctx}"
    fi
  fi
}
