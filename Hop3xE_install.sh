#!/bin/bash

BOLD='\e[1m'
NORMAL='\e[0m'

echo "******************************************"
echo "* Unofficial Hop3x Installer - v19.02.04 *"
echo "******************************************"
echo ""
echo "Avant de procéder à l'installation, assurez-vous d'être :"
echo "- connecté à internet"
echo "- en possession des droits administrateur"
echo "- placé dans le répertoire dans lequel vous souhaitez installer Hop3x"
echo ""
echo "En cas de problème, n'hésitez pas à visiter http://hop3x.univ-lemans.fr pour consulter la procédure d'installation officielle."
echo ""
path=`pwd`
read -s -p "Hop3x va être installé dans ${path} : [ENTREE] pour continuer, [CRTL + C] pour quitter"

# Téléchargement et installation des paquets requis
echo -e "\n\n${BOLD}Mise à jour de la liste des paquets...${NORMAL}"
sudo apt-get -y update
echo -e "\n${BOLD}Installation du paquet software-properties-common...${NORMAL}"
sudo apt-get -y install software-properties-common
echo -e "\n${BOLD}Ajout du dépôt universe (requis pour OpenJDK 8 sous Ubuntu)...${NORMAL}"
sudo add-apt-repository -y universe
echo -e "\n${BOLD}Mise à jour de la liste des paquets...${NORMAL}"
sudo apt-get -y update

echo -e "\n${BOLD}Installation des outils de développement (2 paquets) :${NORMAL}"
echo -e "${BOLD}(1/2) Installation du paquet build-essential...${NORMAL}"
sudo apt-get -y install build-essential
echo -e "\n${BOLD}(2/2) Installation du paquet xterm...${NORMAL}"
sudo apt-get -y install xterm

echo -e "\n${BOLD}Installation du paquet openjdk-8-jdk...${NORMAL}"
sudo apt-get -y install openjdk-8-jdk
echo -e "\n${BOLD}Met Java 8 commme version par défaut...${NORMAL}"
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

echo -e "\n${BOLD}Installation de Ruby 2.3 (3 paquets) :${NORMAL}"
echo -e "${BOLD}(1/3) Installation du paquet ruby2.3...${NORMAL}"
sudo apt-get -y install ruby2.3
echo -e "\n${BOLD}(2/3) Installation du paquet ruby2.3-dev...${NORMAL}"
sudo apt-get -y install ruby2.3-dev
echo -e "\n${BOLD}(3/3) Installation du paquet ruby2.3-doc...${NORMAL}"
sudo apt-get -y install ruby2.3-doc

echo -e "\n${BOLD}Installation du gem rake...${NORMAL}"
sudo gem install rake

echo -e "\n${BOLD}Installation de GTK (3 paquets) :${NORMAL}"
echo -e "${BOLD}(1/3) Installation du gem gtk2...${NORMAL}"
sudo gem install gtk2
echo -e "\n${BOLD}(2/3) Installation du gem gtk3...${NORMAL}"
sudo gem install gtk3
echo -e "\n${BOLD}(3/3) Installation du paquet glade...${NORMAL}"
sudo apt-get -y install glade

echo -e "\n${BOLD}Installation du gem mp3info...${NORMAL}"
sudo gem install mp3info

echo -e "\n${BOLD}Installation de MySQL Server (3 paquets) :${NORMAL}"
echo -e "${BOLD}(1/3) Installation du paquet mysql-server...${NORMAL}"
sudo apt-get -y install mysql-server
echo -e "\n${BOLD}(2/3) Installation du paquet default-libmysqlclient-dev...${NORMAL}"
sudo apt-get -y install default-libmysqlclient-dev
echo -e "\n${BOLD}(3/3) Installation du gem mysql2...${NORMAL}"
sudo gem install mysql2

echo -e "\n${BOLD}Installation de SQLite 3 (2 paquets) :${NORMAL}"
echo -e "${BOLD}(1/2) Installation du paquet libsqlite3-dev...${NORMAL}"
sudo apt-get -y install libsqlite3-dev
echo -e "\n${BOLD}(2/2) Installation du gem sqlite3...${NORMAL}"
sudo gem install sqlite3

echo -e "\n${BOLD}Installation du gem activerecord...${NORMAL}"
sudo gem install activerecord

# Téléchargement de Hop3x
if [ -f Hop3xE.jar ]
then
	echo -e "\n${BOLD}Hop3xE.jar existe déjà ! Que voulez-vous le re-télécharger ? [o/n]${NORMAL}"
	choix=""
	while [ "$choix" != "o" ] && [ "$choix" != "n" ]
	do
		read -p "choix > " choix
		case $choix in
			o) 	echo -e "\n${BOLD}Suppression de Hop3xE.jar...${NORMAL}"
				sudo rm Hop3xE.jar
				echo -e "\n${BOLD}Téléchargement de Hop3xE.jar...${NORMAL}"
				wget http://hop3x.univ-lemans.fr/Hop3xE.jar ;;
			n)	;;
			*)	echo -e "CHOIX INVALIDE !\n" ;;
		esac
	done
else
	echo -e "\n${BOLD}Téléchargement de Hop3xE.jar...${NORMAL}"
	wget http://hop3x.univ-lemans.fr/Hop3xE.jar
fi

# Launcher et PATH
echo -e "${BOLD}Attribution du droit d'éxécution de Hop3xE.jar...${NORMAL}"
chmod +x Hop3xE.jar
echo -e "\n${BOLD}Création du launcher portable...${NORMAL}"
mkdir launcher && echo -e "#!/bin/bash\n\ncd ${path} && java -jar Hop3xE.jar" > launcher/hop3x
chmod +x launcher/hop3x
echo -e "\n${BOLD}Ajout de hop3x dans le PATH...${NORMAL}"
echo -e "export PATH=$PATH:${path}/launcher" >> ~/.bashrc

# Lancement
echo -e "\n${BOLD}Voulez-vous lancer Hop3x ? [o/n]${NORMAL}"
choix=""
while [ "$choix" != "o" ] && [ "$choix" != "n" ]
do
	read -p "choix > " choix
	case $choix in
		o)	echo -e "\n${BOLD}Lancement de Hop3x...${NORMAL}"
			java -jar Hop3xE.jar ;;		
		n) 	;;
		*)	echo -e "CHOIX INVALIDE !\n" ;;
	esac
done

# Informations lancement
echo -e "\n${BOLD}Hop3x est désormais installé ! Voici comment le lancer :${NORMAL}"
echo -e "[interface graphique] : double clic sur Hop3xE.jar (ou clic gauche -> ouvrir avec -> OpenJDK 8)"
echo -e "[terminal] : hop3x (ou java -jar Hop3xE.jar)"
