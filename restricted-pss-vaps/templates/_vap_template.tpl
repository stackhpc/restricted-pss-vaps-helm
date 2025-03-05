{{- define "restricted-pss-vaps.vap" }}
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicy
metadata:
  name: {{ .name }}-{{ .resource | lower }}
spec:
{{- template "restricted-pss-vaps.pod-resource-preamble" }}
  {{ if .hasParams }}
  paramKind:
    apiVersion: stackhpc.com/v1
    kind: PSSParams
  {{ end }}
  validations:
  {{ if ne .resource "pod"}}
  - expression: |
      object.kind != 'Pod' || !has(object.spec.{{ .resource }}) || object.spec.{{ .resource }}.all(container, {{ .podExpression }} )
    message: {{ .message }}
  - expression: |
      ['Deployment','ReplicaSet','DaemonSet','StatefulSet','Job'].all(kind, object.kind != kind) || !has(object.spec.template.spec.{{ .resource }}) || object.spec.template.spec.{{ .resource }}.all(container, {{ .deploymentExpression }} )
    message: {{ .message }}
  - expression: |
      object.kind != 'CronJob' || !has(object.spec.jobTemplate.spec.{{ .resource }}) || object.spec.jobTemplate.spec.{{ .resource }}.all(container, {{ .jobExpression }} )
    message: {{ .message }}
  {{ else }}
  - expression: |
      object.kind != 'Pod' || {{ .podExpression }}
    message: {{ .message }}
  - expression: |
      ['Deployment','ReplicaSet','DaemonSet','StatefulSet','Job'].all(kind, object.kind != kind) || {{ .deploymentExpression }}
    message: {{ .message }}
  - expression: |
      object.kind != 'CronJob' || {{ .jobExpression }}
    message: {{ .message }}
  {{ end }}
{{- end }}
