# Provisioning scripts
I decided to move from manually configuring my servers to automating the process with ansible. Maybe you find these useful.

# Prerequisites
Install ansible (preferably 2.4.0 or higher)

# Configuration
Add your hosts to `host.yml`. Give each host a `hostname` (this will be used to modify /etc/hostname on the remote). Optionally, use a nice name for the host and set `ansible_ssh_host`.

Set some variables you may not want to be publically available in `host_vars/<host>`. I set the (crypted) root password, user password and my mail address.

Modify `file/authorized_keys`. Add your own, optionally remove mine.

Global configuration can be done in `provision.yml`: Default user name, dotfiles source, some log files, ...

# Run it
`ansible-playbook -i hosts.yml provision.yml` for the initial setup steps. This bootstraps python on the remote if not already installed.
