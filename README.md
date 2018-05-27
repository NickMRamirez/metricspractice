# Metrics Practice

Practice using Telegraf, InfluxDB, Chronograf and Statsd.

Usage:

1. Spin up a Kubernetes cluster using Azure Container Service (AKS).

```
~$ cd terraform
~$ terraform init
~$ terraform apply
```

2. Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

3. Connect to the [Kubernetes cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough#connect-to-the-cluster)

```
~$ az login
~$ az aks get-credentials --resource-group "aks_resourcegroup" --name "akscluster1"
```

4. Use `kubectl` to create the Kubernetes resources.

```
~$ cd kubernetes
~$ kubectl apply -f .
```

5. In the Azure Portal, use the link to *View Kubernetes Dashboard* to see the load balanced public IP.