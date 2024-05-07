RESOURCE_GROUP_NAME="wcct-agentbaker-test-20348.2346.240312" \
CLUSTER_NAME="wcct-agentbaker-test-aks"
FQDN=`az aks show -n ${CLUSTER_NAME} -g ${RESOURCE_GROUP_NAME} --query fqdn -o tsv`

set -x

log "beginning npm conformance test..."

    toRun="NetworkPolicy"

    nomatch1="should enforce policy based on PodSelector or NamespaceSelector"
    nomatch2="should enforce policy based on NamespaceSelector with MatchExpressions using default ns label"
    nomatch3="should enforce policy based on PodSelector and NamespaceSelector"
    nomatch4="should enforce policy based on Multiple PodSelectors and NamespaceSelectors"
    cidrExcept1="should ensure an IP overlapping both IPBlock.CIDR and IPBlock.Except is allowed"
    cidrExcept2="should enforce except clause while egress access to server in CIDR block"
    namedPorts="named port"
    wrongK8sVersion="Netpol API"
    toSkip="\[LinuxOnly\]|$nomatch1|$nomatch2|$nomatch3|$nomatch4|$cidrExcept1|$cidrExcept2|$namedPorts|$wrongK8sVersion|SCTP"
    
    # to debug with one test case, uncomment this
    # toRun="NetworkPolicy API should support creating NetworkPolicy API operations"

    echo "" > conformance.ran
    KUBERNETES_SERVICE_HOST="$FQDN" KUBERNETES_SERVICE_PORT=443 ./npm-e2e.test \
        --provider=skeleton \
        --ginkgo.noColor \
        --ginkgo.focus="$toRun" \
        --ginkgo.skip="$toSkip" \
        --allowed-not-ready-nodes=1 \
        --node-os-distro="windows" \
        --disable-log-dump \
        --ginkgo.progress=true \
        --ginkgo.slowSpecThreshold=120.0 \
        --ginkgo.flakeAttempts=0 \
        --ginkgo.trace=true \
        --ginkgo.v=true \
        --dump-logs-on-failure=true \
        --report-dir="${ARTIFACTS}" \
        --prepull-images=true \
        --v=5 "${ADDITIONAL_E2E_ARGS[@]}" \
	--kubeconfig=${HOME}/.kube/config | tee npm-e2e.log || true
set +x
    # grep "FAIL: unable to initialize resources: after 10 tries, 2 HTTP servers are not ready
