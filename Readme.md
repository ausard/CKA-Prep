# README

This README will guide you through the steps to run the `Vagrantfile` provided. The `Vagrantfile` sets up a multi-node Kubernetes cluster on VirtualBox using Ubuntu 20.04 (Focal Fossa) as the base operating system.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/docs/installation/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Steps

1. Clone the repository containing the `Vagrantfile`.

2. Open a terminal/command prompt and navigate to the directory containing the `Vagrantfile`.

3. Run the following command to start the setup process:
```
vagrant up
```
4. The command will take a few minutes to complete as it sets up the virtual machines and provisions them with the necessary scripts.

5. Once the setup is complete, you can log into each machine using the following command:
```
vagrant ssh [machine-name]
```
6. The `machine-name` can be either `kmaster` or `kworker1`, `kworker2`, etc. depending on the number of worker nodes specified in the `Vagrantfile`.

7. The `master.sh` script sets up a Kubernetes master node and the `worker.sh` script sets up a Kubernetes worker node.

That's it! You now have a multi-node Kubernetes cluster set up and ready to use.
