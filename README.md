# ssh-connect

This script allows you to connect to the mostly used ssh server,reading their informations from a configuration file.

I added a script that builds the configuration file automatically,the default file will'be called `$HOME/.ip_ssh`.

The connection script read from that file and will prompt you to choice which server you have to connect to.

Is not mandatory to use the `build_file_conn.sh` to create the configuration file,below an example

It search for ssh key in `$HOME/.ssh folder`


# Examples

### Configuration file example

```
#ip/fqdn |name|user|port

10.4.0.82|test|root|22|
50.4.0.2|test1|luca|29|
192.168.1.1|test2|test|24|
252.1.1.1|test|test|22|
1.2.0.4|test|test|22|my_ssh_key
mail.debian.local|test|test|22|
```

### Add a host using the script

```
luca@linux:~$ ./build_file_conn.sh 10.1.1.1 SSH-Server root 22

luca@linux:~$ cat $HOME/.ip_ssh
10.4.0.82|test|root|22|
50.4.0.2|test1|luca|23|
192.168.1.1|test2|test|24|
256.1.1.1|test|test|22|
1.2.0.4|test|test|22|
mail.debian.local|test|test|22|
10.1.1.1|SSH-Server|root|22|
```

### Connecting to a server

```
luca@linux:~$ ./ssh_connect.sh [TAB]
KVM
OSMC
Web-server
AWS

```
