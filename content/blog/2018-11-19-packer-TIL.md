+++
title = "TIL: Packer stuff"
date = "2018-11-19 18:00:00"
tags = ["hashicorp", "packer", "devops", "deploy"]
+++
Today I spent a large part of my time fighting with Packer.The task at hand was relative simple. There are two configurations file I needed copied to a specific directory inside the AMI created.

### First attempt
Packer has a [file provisioner](https://www.packer.io/docs/provisioners/file.html) just for that purporse. So, without actually reading all the docs, I just dove in. It looks really straight forward. `source`, `destination`. How hard can it be. Its just a copy. Well, I got permission denied. It turns out, unlike, for instance Docker, while the image is building your provisioning are not running as priveleged and you cannot just copy files where you want to.

__TIL file provisioners should copy files to tmp directory and then use shell provisioner to copy / move them inside the image__


### Second attempt
So I copied the files into the `/tmp/confg` directory then tried to move them to the correct location inside the image using the [shell provisioner](https://www.packer.io/docs/provisioners/shell.html). I kept getting stats errors. Doing listing the files in /tmp showed config was there. After so more searching I tried to look inside /tmp/config and got a stats error again. Diving deeper into the docs revealed that directories need to exist. Packer will not create them while provisioning.

__TIL file provisioner will not raise errors when trying to copy to non existing directories bu will fail silently__

### Third attempt
Ok. So I just put the two files in `/tmp` and then mv them from there. Fail again. This time permission denied because the source directory is for a specific user. No problem. I will just chown them. Which didn't work because permission denied. Searching some more I found that indeed normally this is not allowed. However by changing the way Packer executes the shell provisioning, it is possible to run commands under `sudo`

__TIL Its possible to run the provisioner as sudo by changing the [execute_command](https://www.packer.io/docs/provisioners/shell.html#execute_command)__

And so, after some hours of work and frustations, there is an AMI with the files as needed. this feels harder than it should be.
