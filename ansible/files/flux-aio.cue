bundle: {
	apiVersion: "v1alpha1"
	name:       "flux-aio"
	instances: {
		"flux": {
			module: {
				url:     "oci://ghcr.io/stefanprodan/modules/flux-aio"
				version: "latest"
			}
			namespace: "flux-system"
			values: {
                controllers: {
                    helm: enabled:         true
                    kustomize: enabled:    true
                    notification: enabled: true
                }
				hostNetwork:     true
				securityProfile: "privileged"
			}
            values: env: {
                "KUBERNETES_SERVICE_HOST": "kube01.cooney.site"
                "KUBERNETES_SERVICE_PORT": "6443"
            }
		}

        "cilium": {
            module: url: "oci://ghcr.io/stefanprodan/modules/flux-helm-release"
            namespace: "flux-system"
            values: {
                repository: url: "https://helm.cilium.io"
                chart: {
                    name:    "cilium"
                    version: "1.17.x"
                }
                helmValues: {
                    autoDirectNodeRoutes: true
                    devices: "eth0"
                    externalIPs:    enabled: true
                    gatewayAPI: enabled: true
                    hubble: enabled: true
                    ui:
                        enabled: true
                        rollOutPods: true
                        tolerations:
                            "- key: node-role.kubernetes.io/control-plane"
                                operator: "Exists"
                                effect: "NoSchedule"
                            "- key: node-role.kubernetes.io/master"
                                operator: "Exists"
                                effect: "NoSchedule"
                    relay:
                        enabled: true
                        rollOutPods: true
                        tolerations:
                            "- key: node-role.kubernetes.io/control-plane"
                                operator: "Exists"
                                effect: "NoSchedule"
                            "- key: node-role.kubernetes.io/master"
                                operator: "Exists"
                                effect: "NoSchedule"
                    ipam:
                        mode: "kubernetes"
                        operator:
                            clusterPoolIPv4PodCIDRList: "10.42.0.0/16"
                            clusterPoolIPv4MaskSize: 24
                    ipv4:
                       enabled: true
                    ipv4NativeRoutingCIDR: "10.244.0.0/16"
                    ipv6:
                       enabled: false
                    k8sServiceHost: "172.16.1.171"
                    k8sServicePort: "6443"
                    kubeProxyReplacement: "true"
                    l2announcements:
                        enabled: true
                    loadBalancerIPs:
                        enabled: true
                    operator:
                        replicas: 1
                    rollOutCiliumPods: true
                    routingMode: "native"
                    tls:    secretsNamespace:   create: false
                }
                sync: targetNamespace: "kube-system"
            }
        }
	}
}
