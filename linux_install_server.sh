#! /bin/bash

# MariaDB met à disposition un scripte qui permet de télécharger les packages les plus récents.
# Les lignes ci-dessous sont issues du site officiel et permettent de télécharger ces packages.
# https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/
#
# NOTE: MariaDB MaxScale (https://mariadb.com/kb/en/maxscale/) est une extension de MariaDB.
# Etant donné mon faible niveau actuel, je ne m'en sers pas.
sudo apt-get -qqy update
sudo apt-get -qqy install curl ca-certificates apt-transport-https
curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --skip-maxscale

# Les lignes ci-dessous sont issues du site officiel et permettent d'installer les packages.
# https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/#installing-packages-on-debian-and-ubuntu
sudo apt-get -qqy update
sudo apt-get -qqy install mariadb-server mariadb-client

# Il existe plusieurs fichiers de configuration.
# Le paramètre dans un fichier peut écraser la valeur du même paramètre défini dans un fichier chargé précédemment.
# La ligne ci-dessous affiche la liste des fichiers de configuration pour le programme mariadbd
# https://mariadb.com/kb/en/configuring-mariadb-with-option-files/
#mariadbd --help --verbose | head

# Les options du daemon sont nombreuses, elles figurent à cette adresse:
# https://mariadb.com/kb/en/mysqld-options/
#
# Parmi elles, ont trouve l'option bind-address qui permet d'indiquer quelle est l'adresse écoutée par le serveur.
# Par mesure de sécurité, certaines distros initialisent cette adresse à localhost.
# La ligne ci-dessous indique au serveur d'écouter toutes les adresses.
# https://mariadb.com/kb/en/configuring-mariadb-for-remote-client-access/#editing-the-defaults-file
echo -e "\n[mysqld]\nbind-address = 0.0.0.0" | sudo tee -a /etc/mysql/my.cnf > /dev/null

# Pour des raisons de sécurité, l'utilisateur root ne peut initialement accèder à la base qu'à partir
# du serveur.
# Les lignes ci-dessous permettent de créer un utilisateur "cedric" ayant le mot de passe "password"
# ayant un accès à tout depuis n'importe quel poste.
#
# ATTENTION: Par mesure de sécurité, ceci ne doit JAMAIS être fait dans la réalité.
# https://mariadb.com/kb/en/configuring-mariadb-for-remote-client-access/#granting-user-connections-from-remote-hosts
echo "GRANT ALL PRIVILEGES ON *.* TO 'cedric'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;" | sudo mysql
#echo "SELECT User, Host FROM mysql.user;" | sudo mysql

# Il existe une commande pour démarrer manuellement MariaDB.
# Le site officiel n'indique pas comment arrêter MariaDB manuellement.
# En faisant Ctrl+C, j'ai réussi à l'arrêter mais j'ai été incapable de le redémarrer.
# Pour cette raison, je pense qu'il est préférable d'utiliser les commandes pour le démarrage automatique.
# https://mariadb.com/kb/en/systemd/
#
# La ligne ci-dessous permet de redémarrer le daemon avec les nouveaux paramètres.
sudo systemctl restart mariadb.service

# La commande facultative ci-dessous permet de savoir si le service est actif ou non.
#systemctl status mariadb.service

# Pour se connecter, on peut alors utiliser la ligne ci-dessous:
# -u<user>
# -p<password>
# -h<host>
# -P<port> (3306 par défaut)
# https://mariadb.com/kb/en/mysql-command-line-client/
#mariadb -ucedric -ppassword -h0.0.0.0 -P3306
