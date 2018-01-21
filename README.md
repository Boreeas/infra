# Provisioning scripts
I decided to move from manually configuring my servers to automating the process with ansible. Maybe you find these useful.

# Prerequisites
* Install ansible (preferably 2.4.0 or higher)
* Run `ansible-galaxy install --roles-path roles -r roles.yml`
* Run `./setup-deps.sh`

# Configuration
Add your hosts to `host.yml`. Give each host a `hostname` (this will be used to modify /etc/hostname on the remote). Optionally, use a nice name for the host and set `ansible_ssh_host`.

Set some variables you may not want to be publically available in `host_vars/<host>`. I set the (crypted) root password, user password and my mail address. To generate crypted passwords, check out `mkpasswd.py`.

Modify `file/authorized_keys`. Add your own, optionally remove mine.

Global configuration can be done in `provision.yml`: Default user name, dotfiles source, some log files, ...

# Run it
`ansible-playbook -i hosts.yml provision.yml` for the initial setup steps. This bootstraps python on the remote if not already installed.

`ansible-playbook -i hosts.yml update-dotfiles.yml` to update dotfiles on all users and /etc/skel after changes have been pushed to master.

`ansible-playbook -i hosts.yml services.yml` to install all services. Use `--tags <tag>` to limit what services to install, but note that there are some internal dependencies.

# Provided roles
## make_user
Generates a user, configures zsh and sets authorized_keys.

Required variables:
* user
* password
* mail

Optional:
* ugroups: List of groups that the user should be added to

## letsencrypt
Has two modes:
* Setup acme-tiny environment (with some apache specific configuration)
* Request a certificate for a domain (apache vhost must be configured)

Variables:
* do_setup: true for setup, false to request certificate
* domain: set to fqdn if requesting a certificate
* aliases: optionally, specify aliases to name in certificate

## apache2
Set up apache2, configured for an arch environment.

Required variables:
* host
* mail

## znc
Install and configure znc

Required variables:
* znc_user_pass: Password of the system account (called `znc`)
* znc_listeners:
    * Port
    * Optional: ipv4 (Y/n), ipv6 (Y/n), ssl (Y/n)
* znc_modules: Names of global modules to load. `webadmin` is always loaded.
* znc_users:
    * name
    * admin (y/N)
    * altname (= name_)
    * ident (= name)
    * realname (= `[REDACTED]`)
    * modules (= [])
    * settings (= [])
    * networks:
        * name
        * address
        * ssl (y/N)
        * port
        * modules (= [])
        * settings (= [])
* znc_passwords: map from user to (method,hash,salt) (see `znc-mkpasswd.py`)
* znc_settings:
    * Additional settings
* znc_host: hostname for irc (used in cert)
