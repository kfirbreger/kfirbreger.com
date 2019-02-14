+++
title = ""
date = 2019-02-14T10:36:34+01:00
categories = ["micro"]
tags = ["k8s", "kubernetes", "shell"]
+++
In kubernetes **Persistance Volume** (pv for short) are, like nodes, resources for the whole cluster and are therefore not namespaced. If the pv is configured for __Retain__ it will not be deleted with the pvc. This can lead to some pv stacking up.

    k get pv | awk '$6 ~ /^sunny*/ {print $1}' | xargs kubectl delete pv

The folowing command wil find all the pv that were made for a pvc from a given namespace (sunny in this command) and delete them. __awk__ is used for the selection and __xargs__ for execution of delete


