{{- define "containerCheckExpressions.allowedCapabilities" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.capabilities) || !has({{ . }}.securityContext.capabilities.add) || {{ . }}.securityContext.capabilities.add.all(cap, params.allowedCapabilities.exists(allowedCap, cap == allowedCap)){{- end }}
{{- define "containerCheckExpressions.dropCapabilities" }}has({{ . }}.securityContext) && has({{ . }}.securityContext.capabilities) && has({{ . }}.securityContext.capabilities.drop) && {{ . }}.securityContext.capabilities.drop.exists(cap, cap == 'ALL'){{- end }}
{{- define "containerCheckExpressions.appArmor" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.appArmorProfile) || !has({{ . }}.securityContext.appArmorProfile.type) || {{ . }}.securityContext.appArmorProfile.type != 'Unconfined'{{- end }}
{{- define "containerCheckExpressions.runAsNonRoot" }}(has({{ .key }}.securityContext) && has({{ .key }}.securityContext.runAsNonRoot) && {{ .key }}.securityContext.runAsNonRoot == true){{ if eq .key "container" }} || ( {{ .extra }} && (!has({{ .key }}.securityContext) || !has({{ .key }}.securityContext.runAsNonRoot) ) ){{ end }}{{- end }}
{{- define "containerCheckExpressions.nonRootUser" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.runAsUser) || {{ . }}.securityContext.runAsUser != 0{{- end }}
{{- define "containerCheckExpressions.privilegeEscalation" }}has({{ . }}.securityContext) && has({{ . }}.securityContext.allowPrivilegeEscalation) && {{ . }}.securityContext.allowPrivilegeEscalation == false{{- end }}
{{- define "containerCheckExpressions.privilegedContainer" }}!(has({{ . }}.securityContext)) || ((!(has({{ . }}.securityContext.priviliged)) || {{ . }}.securityContext.privileged != true) && (!(has({{ . }}.securityContext.capabilities)) || !(has({{ . }}.securityContext.capabilities.add)) || {{ . }}.securityContext.capabilities.add.all(cap, cap != 'SYS_ADM'))){{- end }}
{{- define "containerCheckExpressions.hostPort" }}!has({{ . }}.ports) || !{{ . }}.ports.exists(port, has(port.hostPort)){{- end }}
{{- define "containerCheckExpressions.hostNetwork" }}!(has({{ . }}.hostNetwork)) || {{ . }}.hostNetwork == false{{- end }}
{{- define "containerCheckExpressions.hostIpcPid" }}((!(has({{ . }}.hostPID)) || {{ . }}.hostPID == false) && (!(has({{ . }}.hostIPC)) || {{ . }}.hostIPC == false)){{- end }}
{{- define "containerCheckExpressions.hostPathVolumes" }}!has({{ . }}.volumes) || {{ . }}.volumes.all(vol, !(has(vol.hostPath))){{- end }}
{{- define "containerCheckExpressions.selinuxType" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.seLinuxOptions) || !has({{ . }}.securityContext.seLinuxOptions.type) || ['container_t','container_init_t','container_kvm_t','container_engine_t'].exists(type, {{ . }}.securityContext.seLinuxOptions.type == type){{- end }}
{{- define "containerCheckExpressions.selinuxUsers" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.seLinuxOptions) || !has({{ . }}.securityContext.seLinuxOptions.user) || {{ . }}.securityContext.seLinuxOptions.user == ''{{- end }}
{{- define "containerCheckExpressions.selinuxRoles" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.seLinuxOptions) || !has({{ . }}.securityContext.seLinuxOptions.role) || {{ . }}.securityContext.seLinuxOptions.role == ''{{- end }}
{{- define "containerCheckExpressions.procMount" }}!has({{ . }}.securityContext) || !has({{ . }}.securityContext.procMount) || {{ . }}.securityContext.procMount == 'Default'{{- end }}
{{- define "containerCheckExpressions.seccomp" }}(has({{ .key }}.securityContext) && has({{ .key }}.securityContext.seccompProfile) && has({{ .key }}.securityContext.seccompProfile.type) && {{ .key }}.securityContext.seccompProfile.type != 'Unconfined'){{ if eq .key "container" }} || {{ .extra }} && (!has({{ .key }}.securityContext) || !has({{ .key }}.securityContext.seccompProfile)|| !has({{ .key }}.securityContext.seccompProfile.type)){{ end }}{{- end }}
{{- define "containerCheckExpressions.appArmorAnnotation" }}!has({{ . }}.metadata.annotations) || {{ . }}.metadata.annotations.filter(annotation, annotation.matches("container.apparmor.security.beta.kubernetes.io/*")).all(currentAnnotation, {{ . }}.metadata.annotations[currentAnnotation] != 'unconfined'){{- end }}
