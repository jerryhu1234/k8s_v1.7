yum install glusterfs glusterfs-fuse

在apiserver中加--allow-privileged=true

给nodes加标签
kubectl label node k8s-node-1 storagenode=glusterfs


