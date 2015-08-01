# ssh-connect
This script allow you to connect tp the mostly used ssh server,reading their informations from a configuration file.
The intent is to have a sort of database,where you'll add all connection informations of your ssh servers.
I added also a script that build that configuration file,the default file will'be called .ip_ssh and it'll be placed in the home of the user that run the script.
The connection script read from that file and will prompt you to choice which server you have to connect to.
Is not mandatory to use the build_file__conn.sh to create the configuration file,you can also manually add it,i added
an example file called ip_ssh that you can use.
That file need to have 4 column for each raw separated by a space. 
