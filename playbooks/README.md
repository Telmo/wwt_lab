# ansible-playbooks

The materials in this repo are used to auto-provision hosts for various needs,
some of which are described in the examples below. If you're new to Ansible,
you might want to read this
[introduction](https://www.ansible.com/how-ansible-works). Here's the minimum
you should know:

* **playbook**: a set of configuration settings and orchestration steps,
collectively called "tasks," used to perform actions on or against a set of hosts
* **role**: a collection of tasks that will (presumably) be used by more than
one playbook; think DRY
* **source host**: the host from which a playbook will be *launched*
* **target host(s)**: the hosts on which playbook tasks will be *executed*

The canonical command to run a playbook against one or more target hosts looks
like this:

```shell
ansible-playbook --inventory=<inventory file> <playbook file> -vvv
```

(-vvv is an optional debug switch)

To run an existing playbook for your specific situation, you might modify or add
content in any of the following directories:

* **inventory**: Each file in this directory lists target hosts; a target host
may appear either singly and/or as a member of one or more groups.
* **host_vars**: Each file in host_vars contains target-host-specific variables
such as the host's MAC address or IP addresses.
* **group_vars**: Each directory in group_vars contains files holding variables
that are common to a group of target hosts.
* **files**: Specified content in this directory will be uploaded to target
hosts based on playbook tasks or roles.
* **templates**: Variables are interpolated in a template file, using the
[Jinja2](http://jinja.pocoo.org/) templating engine. Variables can be defined
in many places (group_vars, host_vars, inventory, environment, etc.).

You probably don't want to set a given variable in too many places. See
[Ansible precedence rules](http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable).

## Setup
1. Install Ansible on the source host (for instance, `sudo pip install
ansible`).
1. Clone this repository.
1. Install all role dependencies. You'll need to be on the VPN, and this will
take a few minutes, though not long enough to get a cup of coffee.

   ```shell
   cd ansible-playbooks
   ansible-galaxy install --role-file=requirements.yml --roles-path=roles --force
   ```

1. (Optional) In the root of your working directory, create a file `.vault_password`
   containing the Ansible vault password. You will store this file in the clear,
   so set the perms to 600.
   This filename is in .gitignore so that it won't be pushed to GHE.

   The **Ansible vault password**, [found this this file](https://github.comcast.com/GSD/pi_encrypted_material/blob/master/secrets/ansible-vault-password.txt.gpg),
   is used to encrypt and decrypt any working directory file that contains
   sensitive material (as identified by a filename of the pattern `*vault*`) so
   that it can be saved in GHE. You will need to have GPG set up on your box, of
   course, to view *that* file (the file just linked). If you elect not to save the
   Ansible password in .vault_password, you will be prompted for it each time you
   attempt to commit an unencrypted file and each time you supply the
   --ask-vault-pass switch when running a playbook.

## Example playbooks


