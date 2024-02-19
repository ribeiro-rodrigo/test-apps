{
  local d = (import 'doc-util/main.libsonnet'),
  '#':: d.pkg(name='v1alpha1', url='', help=''),
  matchResources: (import 'matchResources.libsonnet'),
  namedRuleWithOperations: (import 'namedRuleWithOperations.libsonnet'),
  paramKind: (import 'paramKind.libsonnet'),
  paramRef: (import 'paramRef.libsonnet'),
  validatingAdmissionPolicy: (import 'validatingAdmissionPolicy.libsonnet'),
  validatingAdmissionPolicyBinding: (import 'validatingAdmissionPolicyBinding.libsonnet'),
  validatingAdmissionPolicyBindingSpec: (import 'validatingAdmissionPolicyBindingSpec.libsonnet'),
  validatingAdmissionPolicySpec: (import 'validatingAdmissionPolicySpec.libsonnet'),
  validation: (import 'validation.libsonnet'),
}
