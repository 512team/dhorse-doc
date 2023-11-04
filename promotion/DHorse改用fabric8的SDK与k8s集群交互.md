## 现状
在[dhorse](https://github.com/512team/dhorse) 1.4.0版本之前，一直使用k8s官方提供的sdk与k8s集群交互，官方sdk的Maven坐标如下：

```xml
<dependency>
	<groupId>io.kubernetes</groupId>
	<artifactId>client-java</artifactId>
	<version>18.0.0</version>
</dependency>
```

但是自从1.4.0版本以后，dhorse开始支持fabric8的sdk，fabric8的sdk的Maven坐标如下：

```xml
<dependency>
	<groupId>io.fabric8</groupId>
	<artifactId>kubernetes-client</artifactId>
	<version>6.9.0</version>
</dependency>
```

那么，为什么要替换为fabric8的sdk与k8s交互呢？

## k8s官方与fabric8的对比

1.社区方面

两者的关注度上，都差不多，没有太大差别；

但是，fabric8的sdk提供的文档和示例更加完善，而k8s官方提供的示例较少；

2.功能方面

fabric8不仅支持k8s，同时也支持OpenShift，而官方sdk支持k8s；

3.包大小

k8s官方sdk依赖的sdk过大，有30M左右，而fabric8只有不到10M；

使用官方的sdk也会导致dhorse的安装包过大。

4.API使用方面

举个例子，以查询k8s集群的命名空间列表为例，说明代码如下。

官方：

```java
ApiClient apiClient = this.apiClient(clusterPO.getClusterUrl(), clusterPO.getAuthToken());
CoreV1Api coreApi = new CoreV1Api(apiClient);
List<ClusterNamespace> namespaces = new ArrayList<>();
String labelSelector = null;
if(pageParam != null && !StringUtils.isBlank(pageParam.getNamespaceName())) {
	labelSelector = "kubernetes.io/metadata.name=" + pageParam.getNamespaceName();
}
try {
	V1NamespaceList namespaceList = coreApi.listNamespace(null, null, null, null,
		labelSelector, null, null, null, null, null);
} catch (ApiException e) {
	String message = e.getResponseBody() == null ? e.getMessage() : e.getResponseBody();
	LogUtils.throwException(logger, message, MessageCodeEnum.CLUSTER_NAMESPACE_FAILURE);
}
```

fabric8:

```java
try(KubernetesClient client = client(clusterPO.getClusterUrl(), clusterPO.getAuthToken())){
	ListOptions o = new ListOptions();
	if(pageParam != null && !StringUtils.isBlank(pageParam.getNamespaceName())) {
		o.setLabelSelector("kubernetes.io/metadata.name=" + pageParam.getNamespaceName());
	}
	namespaceList = client.namespaces().list(o);
}
```

可以看出，官方提供的API接口不够简洁，而且抛出了不必要的异常。

## 结论

综上，dhorse后续版本会默认选择fabric8的sdk与k8s器群交互，并计划在v1.6的版本里下掉k8s官方的sdk。
