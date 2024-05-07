   export KUBECONFIG="${HOME}/.kube/config"    

    export ADDITIONAL_E2E_ARGS=()
    export ADDITIONAL_E2E_ARGS+=("--ginkgo.slow-spec-threshold=120s")
    export ADDITIONAL_E2E_ARGS+=("--ginkgo.timeout=4h")
    export WINDOWS_WORKER_MACHINE_COUNT=1
    export ARTIFACTS="${PWD}/_artifacts"
    export KUBENETS_VERSION=1.28.3
    
    export GINKGO_FOCUS=${GINKGO_FOCUS:-"\[sig-node\] Container Runtime blackbox test on terminated container should report termination message if TerminationMessagePath is set as non-root user and at a non-default path \[NodeConformance\] \[Conformance\]"}
    
    export GINKGO_SKIP=${GINKGO_SKIP:-"\[LinuxOnly\]|\[Serial\]|\[Slow\]|\[Excluded:WindowsDocker\]|Networking.Granular.Checks(.*)node-pod.communication|Guestbook.application.should.create.and.stop.a.working.application|device.plugin.for.Windows|Container.Lifecycle.Hook.when.create.a.pod.with.lifecycle.hook.should.execute(.*)http.hook.properly|\[sig-api-machinery\].Garbage.collector"}
    export GINKGO_NODES="${GINKGO_NODES:-"1"}"

    set -x

    export GINKGO_FOCUS="Downward API volume should provide container's cpu request"

    "${HOME}"/kubernetes/test/bin/ginkgo --nodes="${GINKGO_NODES}" "${HOME}"/kubernetes/test/bin/e2e.test -- \
        --provider=skeleton \
        --ginkgo.noColor \
        --ginkgo.focus="$GINKGO_FOCUS" \
        --ginkgo.skip="$GINKGO_SKIP" \
        --node-os-distro="windows" \
        --disable-log-dump \
	--ginkgo.progress=true \
        --ginkgo.flakeAttempts=0 \
        --ginkgo.trace=true \
        --num-nodes="$WINDOWS_WORKER_MACHINE_COUNT" \
        --ginkgo.v=true \
        --dump-logs-on-failure=true \
        --report-dir="${ARTIFACTS}" \
        --prepull-images=true \
        --v=5 "${ADDITIONAL_E2E_ARGS[@]}"

    set +x
