{{- define "restricted-pss-vaps.pod-resource-preamble" }}
  failurePolicy: Fail
  matchConstraints:
    resourceRules:
    - apiGroups:
      - ""
      apiVersions:
      - v1
      operations:
      - CREATE
      - UPDATE
      resources:
      - pods
    - apiGroups:
      - apps
      apiVersions:
      - v1
      operations:
      - CREATE
      - UPDATE
      resources:
      - deployments
      - replicasets
      - daemonsets
      - statefulsets
    - apiGroups:
      - batch
      apiVersions:
      - v1
      operations:
      - CREATE
      - UPDATE
      resources:
      - jobs
      - cronjobs
{{- end }}
