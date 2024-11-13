
#!/bin/bash

co_ssh () {
# Connexion en SSH sur le poste client pour les actions
read -p "Indiquez l'utilisateur sur lequel vous connecter : " utilisateur
sleep .5s
read -p "Indiquez l'ip du poste client : " ip
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
|       3 : Prise de main à distance			|
|	X : Retour au menu principal			|
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
		echo "$(date +%F-%X) - $USER - Prise de main à distance de $ip sous l'utilisateur $utilisateur" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip
		;;
	x|X)
		echo "$(date +%F -%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		echo "Retour au menu principal."
		sleep 1s
		;;

	*)
		menu_action
		;;
esac
}
gestion_computer () {
clear
echo "
=========================================================
|              Menu action ordinateur                   |
=========================================================
|       1 : Gestion de l'alimentation                   |
|       2 : Gestion des répertoires                     |
|       3 : Gestion du pare-feu     			|
|	4 : Gestion des logiciels			|
|	5 : Mise à jour système  			|
|       X : Retour au menu précédent                    |
=========================================================
"
read -p "Faites votre choix : " choix_computer

case $choix_computer in
	1)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Gestion de l'alimentation" >> /var/log/log_evt.txt
		gestion_alim
		;;
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Gestion des répertoires" >> /var/log/log_evt.txt
		gestion_directory
		;;
	3)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Gestion du pare-feu" >> /var/log/log_evt.txt
		gestion_firewall
		;;
	4)
		echo "$(date +%F-%x) - $USER - Ordinateur - Action - Gestion des logiciels" >> /var/log/log_evt.txt
		gestion_logiciel
		;;
	5)
		echo "$(date +%F-%x) - $USER - Ordinateur - Action - Mise à jour système" >> /var/log/log_evt.txt
		maj_system
		;;
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		menu_action
		;;
	p|P)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt

}
gestion_firewall () {

echo "
=========================================================
|		Gestion du pare-feu			|
=========================================================
| 	1 - Activer le pare-feu				|
| 	2 - Désactiver le pare-feu			|
| 	x - Menu précédent				|
=========================================================
"

read choix

case $choix in 

	1)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Activation du pare-feu" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo ufw enbale"
		sleep 3s
		return
		;;
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Désactivation du pare-feu" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo ufw disable"
		sleep 3s
		return
		;;

	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		echo "Retour au menu précédent" 
		sleep 1s
		gestion_computer
		
		;;
	*)
		gestion_firewall
		;;

esac

}

groupe_user () {

	ssh $utilisateur@$ip "sudo -S groups $utilisateur"
	sleep 3s

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
| 	5 : Gestion des groupes utilisateur	       |
|	x : Retour au menu précedent                   |
| 	p : Retour au menu principal		       |
========================================================
"
read -p "Faites votre choix : " choix_gestion


case $choix_gestion in
	1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Création d'utilisateur" >> /var/log/log_evt.txt
		create_user
		;;
	2)
		ssh $utilisateur@$ip 'sudo -S passwd $wilder'
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Changement de mot de passe de $wilder établi" >> /var/log/log_evt.txt
		sleep 1s
		;;
	3)
		
		sleep 2s
		;;
	4)
		;;
	5)
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Gestions des groupe" >> /var/log/log_evt.txt
		gestion_groupe
		;;
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		echo "Retour au menu précédent"
		sleep 1s
		menu_action
		;;
	p|P)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		echo "Retour au menu principal"
		sleep 1s
		;;
	*)
		gestion_user
		;;
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
	ssh $utilisateur@$ip "sudo -S useradd $wilder"
	echo "$(date +%F-%X) - $USER - Utilisateur $wilder créé" >> /var/log/log_evt.txt
	echo " $wilder vient d'être créé"
	ssh $utilisateur@$ip "sudo -S passwd $wilder"
	echo "$(date +%F-%X) - $USER - Utilisateur - Action - Mot de passe de $wilder établi" >> /var/log/log_evt.txt
	sleep 1s
else 
	echo "$wilder existe déjà"
	sleep 1s
fi
}
menu_info () {
# Menu des informations, choix à faire pour consulter des info sur l'utilisateur, l'ordinateur ou les logs !
clear
echo "
=========================================================
|               Menu Information		        |
=========================================================
|       1 : Information utilisateur			|
| 	2 : Information ordinateur			|
|	3 : Consulter les logs				|
|	4 : Effectuer une recherche sur les logs	|
| 	5 : Retour au menu principal			|
========================================================="

read -p "Faites votre choix : " choix_info

case $choix_info in
	1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Vers les informations utilisateur" >> /var/log/log_evt.txt
		info_user
		;;
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Vers les informations ordinateur" >> /var/log/log_evt.txt
		info_computer
		;;
	3)
		echo "$(date +%F-%X) - $USER - Info - Consultation des logs" >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt > log.txt
		echo "Fichier log.txt établi"
		sleep 1s
		menu_info
		;;
	4)
		echo "$(date +%F-%X) - $USER - Info - Recherche d'évènement logs" >> /var/log/log_evt.txt
		search_log
		;;
	5)
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
search_log () {

clear
echo "
===========================================
| 	     Type de recherche	          |
===========================================
|  1 : Recherche de prise d'information   |
|  2 : Recherche d'action effectuée       |
|  3 : Recherche par mots-clefs		  |
|  x : Retour au menu précédent           |
===========================================
"
read -p " Faites votre choix : " choix_log

case $choix_log in
	1)
		echo "$(date +%F-%X) - $USER - Info - Logs - Recherche d'informations." >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt | grep Info
		cat /var/log/log_evt.txt | grep Info > log_info.txt
		echo "
		
		Création d'un fichier log_info.txt dans le répertoire courant."
		sleep 5s
		;;
	2)
		echo "$(date +%F-%X) - $USER - Info - Logs - Recherche d'actions." >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt | grep Action
		cat /var/log/log_evt.txt | grep Action > log_action.txt
		echo "
		
		Création d'un fichier log_action.txt dans le répertoire courant."
		sleep 5s
		search_log
		;;
	3)
		echo "$(date +%F-%X) -$USER - Info - Logs - Rechercher par mots-clefs" >> /var/log/log_evt.txt
		echo "
		N'importe quel mot-clef
		Format date (aaaa-mm-jj)
		Format heure (hh:mm)"
		read -p "Veuillez renseigner votre recherche : " mot_clef
		cat /var/log/log_evt.txt | grep $mot_clef
		cat /var/log/log_evt.txt | grep $mot_clef > log_$mot_clef.txt
		echo "$(date +%F-%X) - $USER - Info - Logs - Recherche avec $mot_clef comme mots-clefs" >> /var/log/log_evt.txt
		echo "Création d'un fichier log_$mot_clef.txt dans le répertoire courant."
		sleep 5s
		search_log
		;;
	x)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		menu_info
		;;
	*)
		echo "Erreur"
		search_log
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
| 	5 : Retour au menu précédent			|
=========================================================
"
read -p " Faites votre choix : " choix_info

case $choix_info in
	1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Observation de l'activité utilisateur" >> /var/log/log_evt.txt
		activite_user
		;;
	2)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Groupes de l'utilisateur" >> /var/log/log_evt.txt
		groupe_user
		;;
	3)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Historiques des commandes de l'utilisateur" >> /var/log/log_evt.txt
		historique_cmd_user
		;;
	4)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Consultation des droits et permissions de l'utilisateur" >> /var/log/log_evt.txt
		droit_user
		;;
	x)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		menu_info
		;;
	*)
		info_user
		;;
esac


}

info_computer () {


echo "
|=======================================================|
| 		Information Ordinateur 			|
|=======================================================|
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
		activite_ordi
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

info_disk () {
clear
echo "
==============================================================
| 		Information Disque                           |
==============================================================
| 	1 : Afficher nombre de disque			     |
| 	2 : Afficher les informations partitions par disque  |
| 	3 : Afficher l'espace disque restant		     |
| 	4 : Afficher le nom et l'espace disque d'un dossier  |
| 	5 : Afficher les lecteurs montés		     |
| 	P : Retour au menu principal		 	     |
=============================================================="

read -p "Veuillez renseigner le disque à consulter : " choix_disque

 case $choix_disque in 
 
  		1)  echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher le nombre de disques" >> /var/log/log_evt.txt
  		read -p "Sur quel disque voulez vous l'information ? " disque
		ssh $utilisateur@$ip "sudo -S fdisk -l /dev/$disque" 
  		sleep 5s
		;;
  		2) echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher les informations partitions par disques" >> /var/log/log_evt.txt
  		ssh $utilisateur@$ip "sudo -S df-h"
  		sleep 5s
		;;
  		3) echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher l'espace disque restant" >> /var/log/log_evt.txt
  		ssh $utilisateur@$ip "sudo -S df"
  		sleep 5s
		;;
  		4) echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher le nom espace disque d'un dossier" >> /var/log/log_evt.txt
  		ssh $utilisateur@$ip "sudo -S df -k"
  		sleep 5s
		;;
  		5) echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher les lecteurs montés" >> /var/log/log_evt.txt
  		ssh $utilisateur@$ip "sudo -S lsblk"
  		sleep 5s
		;;
		p | P) echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		sleep 1s
		;;
  		*) echo "Erreur"
  		info_disk
		;;
  		
esac  			
}

list_app () {

	read -p "Quel filtre souhaitez-vous appliquer ?" filtre
	ssh $utilisateur@$ip "dpkg --list | grep $filtre"
	sleep 3s
	return
}

list_services () {

	read -p "Quel filtre souhaitez-vous appliquer ?" filtre
	ssh $utilisateur@$ip "ps | grep $filtre"
	sleep 3s
	return
}

list_users () {

	ssh $utilisateur@$ip "cat /etc/passwd"
	sleep 3s
	return
}

activite_ordi () {
clear
echo "
==================================================
| 		Activité ordinateur		 |
| 1 : Liste des applications / paquets installés |
| 2 - Liste des services en cours d'exécution	 |
| 3 - Liste des utilisateurs locaux		 |
| X : Retour au menu précédent			 |
==================================================
"
read -p "Faites votre choix : " choix_activite

case $choix_activite in

	1) 
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Liste des applications/paquets installés" >> /var/log/log_evt.txt
		list_app
		sleep 3s
		;;

	2) 
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Liste des services en cours d'exécution" >> /var/log/log_evt.txt
		list_services
		sleep 3s
		;;

	3)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Liste des utilisateurs locaux" >> /var/log/log_evt.txt
		list_users
		sleep 3s
		;;
	x|X)
		info_computer
		;;

	*)	
		activite_ordi
		;;
esac

}
# Menu principal, avec le début de l'enregistrement des logs.
sudo chmod 777 /var > /dev/null
sudo chmod 777 /var/log > /dev/null
sudo chmod 777 /var/log/log_evt.txt > /dev/null
echo "------
$(date +%F-%X) - $USER - *******Start Script*******" >> /var/log/log_evt.txt
echo "$(date +%F-%X) - $USER - Sélection d'un utilisateur et d'un poste" >> /var/log/log_evt.txt
co_ssh
while true
do
	clear
echo "
=========================================================
|               Menu Principal			        |
=========================================================
|       1 : Obtenir une informations		        |
|       2 : Effectuer une action		        |
|       3 : Changer d'utilisateur et de poste           |
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
			echo "$(date +%F-%X) - $USER - Changement d'utilisateur et/ou de poste" >> /var/log/log_evt.txt
			co_ssh
			;;
		4)
			echo "$(date +%F-%X) - $USER - *******Stop Script*******" >> /var/log/log_evt.txt
			exit
			;;
		*)
			;;
	esac
done
