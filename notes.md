# Notas de estudo

``` 
docker ps -a | grep myapp

docker logs myapp

docker logs -f myapp

Alternativas ao MiniKube:
 - Microk8S
 - k3s
 - kind

Ingress - proxy reverso	(Nginx), expõem para fora dos containers, load balancer da app

// namespace default: kube-system 
$ kubectl get pods -n kube-system

NAME                             READY   STATUS    RESTARTS   AGE
coredns-558bd4d5db-ljpjn         1/1     Running   0          34s
etcd-dev.to                      1/1     Running   0          34s
kube-apiserver-dev.to            1/1     Running   0          34s
kube-controller-manager-dev.to   1/1     Running   0          34s
kube-proxy-pjskb                 1/1     Running   0          34s
kube-scheduler-dev.to            1/1     Running   0          34s
storage-provisioner              1/1     Running   0          35s


// Ainda nao tem nada no namespace criado com o nome de 'dev-to'
$ kubectl get pods -n dev-to
No resources found in dev-to namespace.


Boa prática
 - 1 container por pod

Atentar a diferença:
 - Profile: dev.to
 - Namespace: dev-to


$ kubectl apply -f k8s/mysql/;
deployment.apps/mysql created
service/mysql created

// status do pod
$ kubectl get pods -n dev-to
NAME                     READY   STATUS              RESTARTS   AGE
mysql-7cb6ff7595-tzwdk   0/1     ContainerCreating   0          24s

// Acessar o cluster via ssh
$ minikube -p dev.to ssh
docker@dev:~$ 

docker@dev:~$ docker ps
docker@dev:~$ docker images


// deletando do cache 
$ minikube cache delete java-k8s:latest

// listando imagens no cache
$ minikube cache list
java-k8s:latest

// status da aplicacao e o mysql rodando
$ kubectl get pods -n dev-to
NAME                     READY   STATUS    RESTARTS   AGE
myapp-754dd85d67-vmdsl   0/1     Running   0          79s
mysql-7cb6ff7595-tzwdk   1/1     Running   0          44m


// serviços rodando
$ kubectl get services -n dev-to
NAME    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
myapp   NodePort    10.103.3.107   <none>        8080:32045/TCP   2m40s
mysql   ClusterIP   None           <none>        3306/TCP         45m


// obtendo url da aplicação
$ minikube -p dev.to service -n dev-to myapp --url
http://192.168.49.2:32045

http://192.168.49.2:32045/app/hello

http://dev.local/app/hello


// escalar 2 pods
kubectl -n dev-to scale deployment/myapp --replicas=2

// testando várias requisições
while true do curl "http://dev.local/app/hello" echo sleep 2 done

// debug remoto
1) Necessário configurar isso: JAVA_OPTS: "-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n -XX:MaxRAMPercentage=80"
2) Executar comando (tem que escolher o pod que vai depurar)
	kubectl port-forward -n=dev-to <pod_name> 5005:5005
	kubectl port-forward -n=dev-to myapp-5brtwr322rdce2 5005:5005
3) Criar debug remote na IDE
4) Fazer curl (colocar os breakpoints antes)

// Deletar e stop geraç
make k-delete

// Executar todos os passos
make k-all

// logs
stern -n dev-to myapp
```