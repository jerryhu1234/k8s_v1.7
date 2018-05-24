# k8s_v1.7
1、从1.6版本起，使用kubeadm安装时，将所有模块部署在static pods中；
2、默认使用rabc认证授权；
3、master使用kubeadm后，默认不能在此节点上安装pods; 
4、默认关闭了kube-apiserver的http的访问，使用tls增加安全。
5、部署dashboard时，一般需要使用rabc进行授权。

参考文档：
https://github.com/zhuchuangang/k8s-install-scripts/tree/master/kubeadm
https://my.oschina.net/binges/blog/1616020
https://pan.baidu.com/s/1dzQyiq#list/path=%2Fkubernetes1.9.2
https://github.com/kubernetes/dashboard/releases
https://zhuanlan.zhihu.com/p/30684413?from_voters_page=true
https://github.com/rootsongjc/kubernetes-handbook/blob/master/manifests/dashboard-1.7.1/kubernetes-dashboard.yaml
https://github.com/rootsongjc/kubernetes-handbook/blob/master/manifests/dashboard-1.7.1/admin-role.yaml
