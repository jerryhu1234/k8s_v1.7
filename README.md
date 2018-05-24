# k8s_v1.7
1、从1.6版本起，使用kubeadm安装时，将所有模块部署在static pods中；
2、默认使用rabc认证授权；
3、master使用kubeadm后，默认不能在此节点上安装pods; 
4、默认关闭了kube-apiserver的http的访问，使用tls增加安全。
5、部署dashboard时，一般需要使用rabc进行授权。
