## create htpasswd credential
htpasswd -c -B -b /root/users.htpasswd admin redhat123

oc create secret generic htpass-secret --from-file=htpasswd=/root/users.htpasswd -n openshift-config

cat <<EOF > htpasswd.yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: Local 
    mappingMethod: claim 
    type: HTPasswd
    htpasswd:
      fileData:
        name: htpass-secret
EOF

oc apply -f htpasswd.yaml

oc adm policy add-cluster-role-to-user cluster-admin admin
