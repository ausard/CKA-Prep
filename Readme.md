# README

This README will guide you through the steps to run the `Vagrantfile` provided. The `Vagrantfile` sets up a multi-node Kubernetes cluster on VirtualBox using Ubuntu 20.04 (Focal Fossa) as the base operating system.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/docs/installation/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

# Vagrant Kubernetes Cluster Setup

This repository contains a Vagrantfile and provisioning scripts to set up a Kubernetes cluster using Vagrant and VirtualBox.

## Setup

1. Clone this repository to your local machine:

    ```sh
    git clone <repository-url>
    ```

2. Navigate to the repository directory:

    ```sh
    cd <repository-directory>
    ```

3. Edit the `Vagrantfile` if needed to adjust the cluster configuration.

4. Run the following command to start provisioning the cluster:

    ```sh
    vagrant up
    ```

5. After the provisioning is complete, you will have a Kubernetes master node (`kmaster`) and worker nodes (`kworker1`, `kworker2`, etc.) set up.

6. Access the master node and start working with your Kubernetes cluster!

## Cluster Configuration

- The master node has the hostname `kmaster.example.com` and IP address `192.168.60.100`.
- The worker nodes have hostnames `kworker1.example.com`, `kworker2.example.com`, etc., with IP addresses `192.168.60.101`, `192.168.60.102`, etc.

## Customization

You can customize the cluster configuration in the `Vagrantfile` to adjust the number of worker nodes, memory, CPUs, and more.

## Provisioning Scripts

The provisioning scripts for both the master node and worker nodes can be found in this repository. You can find the scripts in the respective files: `master.sh` and `worker.sh`.

## Contribution

Feel free to contribute to this repository by opening issues or pull requests.
