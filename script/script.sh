#!/bin/bash

co_ssh () {
# Connexion en SSH sur le poste client pour les actions
read -p "Indiquez l'utilisateur sur lequel vous connecter : " utilisateur
sleep .5s
read -p "Indiquez l'ip du poste client : " ip

ssh $utilisateur@$ip "mkdir crabouille"


}
menu_action () {
# Menu des actions, choix à faire pour intéragir sur un compte utilisateur ou sur une machine directement

	clear
	echo "
=========================================================
|  		   	Menu Action	                |
=========================================================
|       1 : Gestion de l'utilisateur	                |
|       2 : Gestion de l'ordinateur			|
|       3 : Retour au menu principal			|
=========================================================
"
read -p "Faites votre choix : " choix_action

case $choix_action in
	1)
		echo "$(date +%F-%X) - $USER - Vers la gestion utilisateur" >> /var/log/log_evt.txt
		gestion_user
		;;
	2)
		echo "$(date +%F-%X) - $USER - Vers la gestion ordinateur" >> /var/log/log_evt.txt
		gestion_computer
		;;
	3)
		echo "Retour au menu principal."
		sleep 1s
		;;
	*)
		menu_action
		;;
esac
}

gestion_user() {
clear
read -p "Sur quel utilisateur souhaitez-vous intervenir ? " wilder

sudo ssh $utilisateur@$ip "id -u $wilder > /dev/null"

if sudo ssh $utilisateur@$ip $? = "0" 
then
	clear
	echo "
========================================================
|              Menu Gestion utilisateur                |
========================================================
|       1 : Création d'un compte utilisateur           |
|       2 : Modification du mot de passe               |
|       3 : Suppression d'un compte utilisateur	       |
|	4 : Désactivation d'un compte utilisateur      |
========================================================
"
read -p "Faites votre choix : " choix_gestion


case $choix_gestion in
	1)
		echo "$(date +%F-%X) - $USER - Création d'utilisateur" >> /var/log/log_evt.txt
		create_user
		;;
	2)
		passwd $wilder
		echo "$(date +%F-%X) - $USER - Changement de mot de passe de $wilder établi" >> /var/log/log_evt.txt
		sleep 1s
		;;
	3)
		mkdir $wilder
		sleep 2s
		;;
	4)

esac

else
	echo "$(date +%F-%X) - $USER - L'utilisateur renseigné n'existe pas" >> /var/log/log_evt.txt
	read -p "$wilder n'existe pas. Voulez vous le créer ? " noexist
	case $noexist in
		o|O|y|Y|Oui|oui|yes|Yes)
			echo "Redirection vers la création d'utilisateur"
			echo "$(date +%F-%X) - $USER - Créer cet utilisateur" >> /var/log/log_evt.txt
			create_user
			;;
		N|n|No|no|Non|non)
			echo "Retour au menu gestion utilisateur"
			echo "$(date +%F-%X) - $USER - Ne créer pas cet utilisateur, redirection menu gestion utilisateur" >> /var/log/log_evt.txt
			gestion_user
			;;
		*)
			echo "$(date +%F-%X) - $USER - Retour au menu principale" >> /var/log/log_evt.txt
			echo "Erreur, retour au menu principal"
			;;
	esac
fi



}

create_user () {

read -p "Veuillez renseigner le nom de l'utilisateur à créer : " wilder

ssh $utilisateur@$ip "id -u $wilder > /dev/null"

if ssh $utilisateur@$ip "$? = "1" "
then
	ssh $utilisateur@$ip "sudo useradd $wilder"
	echo "$(date +%F-%X) - $USER - Utilisateur $wilder créé" >> /var/log/log_evt.txt
	echo " $wilder vient d'être créer."
	ssh $utilisateur@$ip "passwd $wilder"
	echo "$(date +%F-%X) - $USER - Mot de passe de $wilder établi" >> /var/log/log_evt.txt
	sleep 1s
else 
	echo "$wilder existe déjà"
	sleep 1s
fi



}



menu_info () {
# Menu des informations, choix à faire pour consulter des info sur l'utilisateur, l'ordinateur ou les logs !
	clear

echo " Menu d'information "
echo " 1 : Information utilisateur"
echo " 2 : Information ordinateur"
echo " 3 : Consulter les logs"
echo " 4 : Retour au menu principal"
read -p "Faites votre choix : " choix_info

case $choix_info in
	1)
		echo "$(date +%F-%X) - $USER - Vers les informations utilisateur" >> /var/log/log_evt.txt
		info_user
		;;
	2)
		echo "$(date +%F-%X) - $USER - Vers les informations ordinateur" >> /var/log/log_evt.txt
		info_computer
		;;
	3)
		echo "$(date +%F-%X) - $USER - Consultation des logs" >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt > log.txt
		;;
	4)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		echo "Retour menu principal"
		sleep 1s
		;;
	*)
		echo "Erreur, réessayer"
		sleep 1s
		menu_info
		;;
esac

}

info_user () {
# Menu des informations sur l'utilisateur
clear
echo "
=========================================================
|		Menu Information Utilisateur		|
=========================================================
|	1 : Activité de l'utilisateur			|
|	2 : Groupe d'appartenance de l'utilisateur	|
|	3 : Historique des commandes de l'utilisateur	|
|	4 : Droits et permissions de l'utilisateur	|
========================================================="
read -p " Faites votre choix : " choix_info

case $choix_info in
	1)
		echo "$(date +%F-%X) - $USER - Observation de l'activité utilisateur" >> /var/log/log_evt.txt
		activite_user
		;;
	2)
		echo "$(date +%F-%X) - $USER - Groupes de l'utilisateur" >> /var/log/log_evt.txt
		groupe_user
		;;
	3)
		echo "$(date +%F-%X) - $USER - Historiques des commandes de l'utilisateur" >> /var/log/log_evt.txt
		historique_cmd_user
		;;
	4)
		echo "$(date +%F-%X) - $USER - Consultation des droits et permissions de l'utilisateur" >> /var/log/log_evt.txt
		droit_user
		;;
	*)
		info_user
		;;
esac


}
info_computer () {
# Menu des infos sur la machine
	clear
echo "
=========================================================
|               Menu Information Ordinateur             |
=========================================================
|       1 : Version du système d'exploitation           |
|       2 : Informations des disques		 	|
|       3 : Activité de l'ordinateur			|
|       4 : Informations sur la RAM			|
=========================================================
"
read -p "Faites votre choix : " choix_computer

case $choix_computer in
	1)
		echo "$(date +%F-%X) - $USER - Version du système d'exploitation" >> /var/log/log_evt.txt
		version_os
		;;
	2)
		echo "$(date +%F-%X) - $USER - Informations des disques" >> /var/log/log_evt.txt
		info_disk
		;;
	3)
		echo "$(date +%F-%X) - $USER - Activité de l'ordinateur" >> /var/log/log_evt.txt
		activite_computer
		;;
	4)
		echo "$(date +%F-%X) - $USER - Information sur la RAM" >> /var/log/log_evt.txt
		info_ram
		;;
	*)
		info_computer
		;;
esac
}

# Menu principal, avec le début de l'enregistrement des logs.
echo "------
$(date +%F-%X) - $USER - *******Start Script*******" >> /var/log/log_evt.txt

while true
do
	clear
echo "
=========================================================
|               Menu Principal			        |
=========================================================
|       1 : Obtenir une informations		        |
|       2 : Effectuer une action		        |
|       3 : Connexion SSH avec le client	        |
|       4 : Quitter			                |
=========================================================
"
read -p "Faites votre choix : " choix
 
	case $choix in

		1)
			echo "$(date +%F-%X) - $USER - Redirection vers menu informations" >> /var/log/log_evt.txt
			menu_info
			;;
		2)
			echo "$(date +%F-%X) - $USER - Redirection vers le menu des actions" >> /var/log/log_evt.txt
			menu_action
			;;

		3)
			echo "$(date +%F-%X) - $USER - Connexion à un poste client" >> /var/log/log_evt.txt
			co_ssh
			;;

		4)
			echo "$(date +%F-%X) - $USER - *******Stop Script*******" >> /var/log/log_evt.txt
			exit
			;;
		*)
			echo "Erreur"
			;;
	esac
done
