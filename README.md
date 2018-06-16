cans.cerebro-container-setup
============================

[![Build Status](https://img.shields.io/travis/marvinpinto/ansible-role-docker/master.svg?style=flat-square)](https://travis-ci.org/cans/cerebro-container-setup)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-cans.cerebro--container--setup-blue.svg?style=flat-square)](https://galaxy.ansible.com/cans/cerebro-container-setup)
[![License](https://img.shields.io/badge/license-GPLv2-brightgreen.svg?style=flat-square)](LICENSE)

Provisions and starts a container running Cerebro for ElasticSearch


Requirements
------------

This role has the requirements of Ansible's
[`docker_container`](https://docs.ansible.com/ansible/latest/modules/docker_container_module.html)
module: it requires the `docker` python module.

Note: Ansible error messages often mention the `docker-py` module which is
deprecated and obsolete. Do install the `docker` one (use the provided
`requirements.txt` file). If you use specific version of Ansible, check the
documentation to install the proper version.


Role Variables
--------------

All variables in this roles are namespaced with the `cerebrosetup_` prefix.
Additionnally variables which are relevant to both the container or the host are
prefixed accordingly: `cerebrosetup_container_` or `cerebrosetup_host_`.

### Input variables

- `cerebrosetup_elasticsearch_hosts`: the list of elasticsearch clusters cerebro
  should connect to. Each element in the list should be as follows:

  ```yaml
  uri: "https://cluster.elastic.search:9300/"  # The URI of the cluster
  name: "production cluster"                   # The name to be given to the cluster
  auth:                                        # Credentials to connect to the cluser (optional)
    username: "johndoe"
    password: "some password"
  ```

  See also the example playbook below. (default: `[]`)


### Output variables

- `cerebrosetup_container`: the role will register the data returned by the
  module responsible for creating the container in this variable. The content
  of that variable is described in Ansible's [`docker_container` module
  documentation](https://docs.ansible.com/ansible/latest/modules/docker_container_module.html)

### Defaults

- `cereborsetup_application_secret`: a pseudo random string use to produce
  cookie signing key;
- `cerebrosetup_container_config_dir`: the path to cerebro's configuration directory
  within the container. See also the `cerebrosetup_host_config_dir` variable.
  Mostly depends on the images version (default: `"/opt/cerebro/conf");
- `cerebrosetup_container_labels`: labels to assign to the container (default: `{}`);
- `cerebrosetup_container_memory`: Maximum amount of memory the container will be
  allowed to use (default: `"512M"`);
- `cerebrosetup_container_name`: The name the the container to start, or to be given if
  provisioning the container is needed (default: `"cerebro"`);
- `cerebrosetup_container_network_mode`: the Docker network mode the container should
  user (default: `"default"`)
- `cerebrosetup_container_port`: TCP port number on which Cerebro will listen
  to, inside the container (default: `9000`);
- `cereborsetup_container_rootfs_ro`: whether to make the container root
  filesystem read only (default: `false`);
  *MUST BE FALSE FOR NOW* (looks like cerebro writes a db somewhere, and making
  the system RO prevents its creation [for http sessions ?]).
- `cerebrosetup_container_state`: the state the container should end-up in
  (default: `started`);
- `cerebrosetup_host_bind_address`: IP address on which bind the cerebro server running
  (default: `"127.0.0.1"`);
- `cerebrosetup_host_config_dir`: directory in which find the `application.conf`
  file on the host. It will be mounted within the container (default: `"config/"`);
- `cerebrosetup_host_log_dir`: where to store logs on the docker host machine. Useful only
  if you mount want to mount a volume to store logs (default: `"/tmp"`);
- `cerebrosetup_host_port`: TCP port number on which Cerebro will be published,
  on the host (default: `9000`);
- `cerebrosetup_image`: name of the container image to use to create
  the container (default: `"yannart/cerebro:latest"`);
- `cerebrosetup_image_pull`: whether to force checking if the image
  is up-to-date, eventually pulling it and updating the container if needed.
  (default: `false`);


Dependencies
------------

This role has no dependency.


Example Playbook
----------------

This create a container that will run a Cerebro server, reachable on
localhost:9000 and that can interact and display data about two
Elasticsearch clusters.

```yaml
- hosts: servers
  roles:
    - role: "cans.cerebro-setup"
      cerebrosetup_container_name: "cerebro-test"
      cerebrosetup_host_config_dir: "~/cerebro/conf"
      cerebrosetup_host_log_dir: "/tmp/logs"
      # The two clusters Cerebro will be capable of interecting with.
      cerebrosetup_elasticsearch_hosts:
        - uri: https://elastic-cluster.example.com:9300/
          name: "The Elastic Cluster"
          auth:
            username: "bar"
            password: "bazword"
        - uri: https://unyielding-cluster.example.com:9300/
          name: "The Unyielding Cluster"
          # If no credentials are required, omit the `auth` key.
```


TODO
----

- Manage to generate an application secret (not so important if used bound
  to the loopback address, as is by default);

License
-------

GPL 2.0

Author Information
------------------

Copyright © 2018, Nicolas CANIART.
