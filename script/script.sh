#!/bin/bash

# Barre de chargement (pur fake)
progress_bar() {
DURATION=25
local progress=0
 
# Longueur de la barre de chargement
local max=50
local completed
local remaining
local percent

    while [ $progress -le $DURATION ]; do
        completed=$((progress * max / DURATION))
        remaining=$((max - completed))
        percent=$((progress * 100 / DURATION))

        # Affiche la barre de chargement
        printf "\r["
        printf "%0.s#" $(seq 1 $completed)
        printf "%0.s-" $(seq 1 $remaining)
        printf "] %d%%" "$percent"

        # Attendre une seconde et incrémenter
        sleep 1
        progress=$((progress + 1))
    done

    # Nouvelle ligne après la fin
    echo ""
sleep 5s
}

co_ssh () {
# Connexion en SSH sur le poste client pour les actions
read -p "Indiquez l'utilisateur sur lequel vous connecter : " utilisateur
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
	# Accès au menu gestion utilisateur
	1)
		echo "$(date +%F-%X) - $USER - Action - Vers la gestion utilisateur" >> /var/log/log_evt.txt
		gestion_user
		;;
  	# Accès au menu gestion ordinateur
	2)
		echo "$(date +%F-%X) - $USER - Action - Vers la gestion ordinateur" >> /var/log/log_evt.txt
		gestion_computer
		;;
	# Accès au menu Prise de main à distance
	3)
		echo "$(date +%F-%X) - $USER - Action - Prise de main à distance de $ip sous l'utilisateur $utilisateur" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip
		;;
  	# Retour au menu principal
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		echo "Retour au menu principal."
		sleep 1s
		;;
	# En cas d'erreur, retour au menu de la fonction
	*)
		menu_action
		;;
esac
}

# Menu de gestion de l'ordinateur
gestion_computer () {
clear
echo "
=========================================================
|              Menu Gestion Ordinateur                  |
=========================================================
|       1 : Gestion de l'alimentation                   |
|       2 : Gestion des répertoires                     |
|       3 : Gestion du pare-feu     			|
|	4 : Gestion des logiciels			|
|	5 : Mise à jour système  			|
|       X : Menu précédent 		                |
|	P : Menu principal 				|
=========================================================
"
read -p "Faites votre choix : " choix_computer

case $choix_computer in
	# Accès au menu Gestion de l'alimentation de l'ordinateur cible
	1)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Gestion de l'alimentation" >> /var/log/log_evt.txt
		gestion_alim
		;;
  	# Accès au menu Gestion des répertoires de l'ordinateur cible
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Gestion des répertoires" >> /var/log/log_evt.txt
		gestion_directory
		;;
  	# Accès au menu Gestion du pare-feu de l'ordinateur cible
	3)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Gestion du pare-feu" >> /var/log/log_evt.txt
		gestion_firewall
		;;
  	# Accès au menu Gestion des logiciels de l'ordinateur cible
	4)
		echo "$(date +%F-%x) - $USER - Ordinateur - Action - Gestion des logiciels" >> /var/log/log_evt.txt
		gestion_logiciel
		;;
  	# Accès à la Mise à jour du système cible
	5)
		echo "$(date +%F-%x) - $USER - Ordinateur - Action - Mise à jour système" >> /var/log/log_evt.txt
		maj_system
		;;
  	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		menu_action
		;;
  	# Retour au menu principal
	p|P)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		sleep 1s
		;;
esac
}

# Menu de Gestion de l'alimentation
gestion_alim() {
clear
echo "
=========================================================
|		Gestion de l'alimentation		|
=========================================================
| 	1 - Arrêt ordinateur				|
| 	2 - Redémarer l'ordinateur			|
| 	3 - Verrouiller l'ordinateur			|
| 	x - Menu précédent				|
=========================================================
"

read -p "Faites votre choix : " choix_computer

case $choix_computer in
	# Arrêter l'ordinateur cible
	1)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Arret Ordinateur" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S shutdown now"
		co_ssh
		;;
  	# Redémarrer l'ordinateur cible
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Redemarrage Ordinateur" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S shutdown -r now"
		progress_bar
		;;
  	# Verrouiller l'ordinateur cible
	3)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Verrouillage Ordinateur" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S gnome-screensaver-command -l"
		;;
  	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		gestion_computer
		;;
  	# En cas d'erreur, retour au menu de la fonction
	*)
		gestion_alim
		;;

esac
}

# Menu de Gestion des répertoires
gestion_directory () {
echo "
=========================================================
|          Gestion des répertoires 	                |
=========================================================
|       1 - Création de répertoire    		        |
|       2 - Mdoification de répertoire                  |
|       3 - Suppression de répertoire                   |
|       x - Menu précédent 		                |
=========================================================
"

read -p "Faites votre choix : " choix_directory


case $choix_directory in 
	# Créer le répertoire à partir du nom et du chemin renseignés
	1)
		read -p "Quel dossier souhaitez-vous créer ?(Chemin absolu)" directory
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Création de Répertoire $directory" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S mkdir $directory"
		echo "Création de $directory effectuée."
		sleep 1s
		return
		;;
	# Modifier le répertoire à partir du nom, du chemin et du nouveau nom renseignés
	2)
		read -p "Quel dossier souhaitez vous modifier ?(Chemin absolu. ex : /home/wilder/dossier)" directory
		read -p "Quel est le nouveau nom souhaitez ?" dir_name
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Modification de Répertoire $directory" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S mv $directory $dir_name"
		echo "Modification de $directory en $dir_name effectuée."
		sleep 1s
		gestion_directory
		;;
	# Supprimer le répertoire à partir du nom et du chemin renseignés 
	3)
		read -p "Quel dossier souhaitez-vous supprimer ? " directory
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Suppression de Répertoire" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S rm -r $directory"
		echo "Suppression de $directory effectuée."
		sleep 1s
		gestion_directory
		;;
	# Retour au menu précédent
	x|X)	
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt	
		echo "Retour Menu Précédent"
		menu_action
		;;
  	# En cas d'erreur, retour au menu de la fonction
  	*)
   		gestion_directory
     		;;
esac		
}

# Menu de Gestion du pare-feu
gestion_firewall () {
clear
echo "
=========================================================
|		Gestion du pare-feu			|
=========================================================
| 	1 - Activer le pare-feu				|
| 	2 - Désactiver le pare-feu			|
| 	x - Menu précédent				|
=========================================================
"

read -p "Faites votre choix : " choix_firewall

case $choix_firewall in 
	# Activer le pare-feu
	1)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Activation du pare-feu" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S ufw enable"
		echo "Pare-feu activé !"
		sleep 8s
		return
		;;
  	# Désactiver le pare-feu
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Désactivation du pare-feu" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S ufw disable"
		echo "Pare-feu désactivé !"
		sleep 1s
		return
		;;
	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		echo "Retour au menu précédent" 
		sleep 1s
		gestion_computer
		;;
  	# En cas d'erreur, retour au menu de la fonction
	*)
		gestion_firewall
		;;

esac
}

# Menu de Gestion logiciel
gestion_logiciel () {
clear
echo "
=========================================================
|		Gestion logiciel			|
=========================================================
| 	1 :  Installation logiciel			|
| 	2 :  Désinstallation logiciel			|
| 	x :  Menu précédent 				|
=========================================================
"

read -p "Faites votre choix : " choix_logiciel

case $choix_logiciel in
	# Installer l'application
	1)
		read -p "Renseignez le nom de l'application à installer : " app
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Installation de l'application $app" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo apt install $app"
		sleep 3s
		;;
	# Désinstaller l'application
	2)
		read -p "Renseignez le nom de l'application à désinstaller : " app
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Désinstallation de l'application $app" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo apt remove $app --purge "
		sleep 3s
		;;
	# Retour au menu précédent
	x|X)
		echo "Retour au menu précédent"
		sleep 1s		
		;;
	# En cas d'erreur, retour au menu de la fonction
	*)
		gestion_utilisateur
		;;
esac

}

# Mise à jour du système 
maj_system () {

# Mise à jour des dépôts de paquets
echo "Mise à jour des dépôts de paquets"
ssh $utilisateur@$ip "sudo -S apt update"

# Mise à jour des paquets installés
echo "Mise à jour des paquets installés"
ssh $utilisateur@$ip "sudo -S apt upgrade"

echo "Le système doit être redémarré pour appliquer les mises à jour du noyau."

read -p "Voulez-vous redémarrer votre ordinateur ?" restart

case $restart in

	# Oui pour redémarrer le système cible après la mise à jour
        o|O|y|Y|Oui|oui|yes|Yes)
		echo "$(date +%F-%X) - $USER - Ordinateur - Action - Redémarrage du système." >> /var/log/log_evt.txt
                ssh $utilisateur@$ip 'sudo -S shutdown -r now'
		progress_bar
		;;
  	# Tout autre valeur pour ne pas redémarrer le système cible
        *)
                echo "Pensez à redémarrer votre ordinateur pour l'applications des paquets installés."
                echo "Retour au menu principal"
                sleep 2s
                ;;
esac
}

# Menu de Gestion Utilisateur
gestion_user() {
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
	# Accès à la création d'utilisateur
	1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Création d'utilisateur" >> /var/log/log_evt.txt
		create_user
		;;
  	# Modification du mot de passe de l'utilisateur cible
	2)
		read -p "De quel utilisateur souhaitez vous modifier le mot de passe ? " wilder
		ssh $utilisateur@$ip "passwd $wilder"
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Changement de mot de passe de $wilder établi" >> /var/log/log_evt.txt
		sleep 1s
		;;
  	# Suppression de l'utilisateur cible
	3)
		read -p "Quel compte utilisateur souhaitez-vous supprimer ? " user
		ssh $utilisateur@$ip "sudo -S userdel $user"
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Suppression de $user effectuée" >> /var/log/log_evt.txt
		echo "Suppression de $user effectuée"
		sleep 10s
		;;
  	# Désactivation de l'utilisateur cible
	4)
		read -p "Quel compte utilisateur souhaitez-vous désactiver ? " user
		ssh $utilisateur@$ip "sudo -S passwd -l $user"
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Désactivation du compte utilisateur $user" >> /var/log/log_evt.txt
		echo "Désactivation de $user réussie."
		sleep 1s
		;;
  	# Accès à la gestion des groupes
	5)
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Gestions des groupe" >> /var/log/log_evt.txt
		gestion_groupe
		;;
  	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		echo "Retour au menu précédent"
		sleep 1s
		menu_action
		;;
  	# Retour au menu principal
	p|P)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		echo "Retour au menu principal"
		sleep .5s
		;;
  	# En cas d'erreur, retour au menu de la fonction
	*)
		gestion_user
		;;
esac
}

# Fonction pour la création d'un utilisateur
create_user () {

read -p "Veuillez renseigner le nom de l'utilisateur à créer : " wilder

if ssh $utilisateur@$ip "getent passwd $wilder > /dev/null 2>&1"
then	 
	echo "$wilder existe déjà"
	sleep 1s
	gestion_user
else
       	ssh $utilisateur@$ip "sudo -S adduser $wilder"
        echo "$(date +%F-%X) - $USER - Utilisateur $wilder créé" >> /var/log/log_evt.txt
	sleep 1s
fi
}

# Menu de Gestion des groupes
gestion_groupe () {
clear
echo "
=========================================================
|		Gestion des groupes			|
=========================================================
| 1 - Ajout à un groupe d'administration		|
| 2 - Ajout à un groupe local				|
| 3 - Sortie d'un groupe local				|
| x - Menu précédent					|
=========================================================
"

read -p "Faites votre chox : " choix_groupe

case $choix_groupe in
	# Ajout de l'utilisateur cible au groupe d'administration
	1)
		read -p "Indiquez quel utilisateur à ajouter au groupe d'administration : " wilder
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Ajout de l'utilisateur : $wilder au groupe administrateur" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S usermod -aG sudo $wilder"
		sleep 1s
		return
		;;
	# Ajout de l'utilisateur cible à un groupe local
	2)
		read -p "Renseignez l'utilisateur sur lequel travailler : " wilder
		read -p "Renseignez le groupe auquel vous souhaitez ajouter l'utilisateur : " groupe
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Ajout de l'utilisateur : $wilder au groupe : $groupe" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S usermod -aG $groupe $wilder"
		sleep 1s
		return
		;;
	# Sortie de l'utilisateur cible d'un groupe local
	3)
		read -p "Renseignez l'utilisateur sur lequel travailler : " wilder
		read -p "Renseignez le groupe auquel vous souhaitez supprimer l'utilisateur : " groupe
		echo "$(date +%F-%X) - $USER - Utilisateur - Action - Suppression de l'utilisateur : $wilder du groupe : $groupe" >> /var/log/log_evt.txt
		ssh $utilisateur@$ip "sudo -S usermod -G $groupe $wilder"
		sleep 1s
		return
		;;
	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		gestion_user
		;;
	# En cas d'erreur, retour au menu de la fonction
	*)
		gestion_groupe
		;;

esac
}
menu_info () {
# Menu des informations, choix à faire pour consulter des info sur lutilisateur, lordinateur ou les logs !
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
	# Accès aux informations de l'utilisateur cible
	1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Vers les informations utilisateur" >> /var/log/log_evt.txt
		info_user
		;;
  	# Accès aux informations de l'ordinateur cible
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Vers les informations ordinateur" >> /var/log/log_evt.txt
		info_computer
		;;
  	# Accès à la consultation des journaux (logs)
	3)
		echo "$(date +%F-%X) - $USER - Info - Consultation des logs" >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt > log.txt
		echo "Fichier log.txt établi"
		sleep 1s
		menu_info
		;;
  	# Recherche d'évènements particuliers ou généraux dans les logs
	4)
		echo "$(date +%F-%X) - $USER - Info - Recherche d'évènement logs" >> /var/log/log_evt.txt
		search_log
		;;
  	# Retour au menu principal
	5)
		echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
		echo "Retour menu principal"
		sleep 1s
		;;
  	# En cas d'erreur, retour au menu informations
	*)
		echo "Erreur, réessayer"
		sleep 1s
		menu_info
		;;
esac
}

# Menu de recherche dans les logs
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
	# Accès à la recherche d'informations cibles
	1)
		echo "$(date +%F-%X) - $USER - Info - Logs - Recherche d'informations." >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt | grep Info
		cat /var/log/log_evt.txt | grep Info > log_info.txt
		echo "
		
		Création d'un fichier log_info.txt dans le répertoire courant."
		sleep 5s
		;;
  	# Accès à la recherche d'actions cibles
	2)
		echo "$(date +%F-%X) - $USER - Info - Logs - Recherche d'actions." >> /var/log/log_evt.txt
		cat /var/log/log_evt.txt | grep Action
		cat /var/log/log_evt.txt | grep Action > log_action.txt
		echo "
		
		Création d'un fichier log_action.txt dans le répertoire courant."
		sleep 5s
		search_log
		;;
  	# Accès à la recherche par mots-clefs
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
  	# Retour au menu précédent
	x)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		menu_info
		;;
  	# En cas d'erreur, retour au menu de recherche d'évènements
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
| 	x : Retour au menu précédent			|
=========================================================
"
read -p " Faites votre choix : " choix_info

case $choix_info in
	# Accès aux informations de l'activité de l'utilisateur cible
	1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Observation de l'activité utilisateur" >> /var/log/log_evt.txt
		activite_user
		;;
  	# Accès aux informations d'appartenance à un groupe de l'utilisateur cible
	2)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Groupes de l'utilisateur" >> /var/log/log_evt.txt
		groupe_user
		;;
  	# Accès à l'historique des commandes de l'utilisateur cible
	3)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Historiques des commandes de l'utilisateur" >> /var/log/log_evt.txt
		historique_cmd_user
		;;
  	# Accès à la consultation des droits et permissions de l'utilisateur cible
	4)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Consultation des droits et permissions de l'utilisateur" >> /var/log/log_evt.txt
		droits_user
		;;
  	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		menu_info
		;;
  	# Retour au menu de la fonction
	*)
		info_user
		;;
esac
}

# Menu Informations de l'activité de l'utilisateur
activite_user () {
clear
echo "
===========================================================
|        INFORMATION ACTIVITE UTILISATEUR                 |
===========================================================
|   1 : Date des dernières connexions de l'utilisateur    |
|   2 : Date des dernières changements de mot de passe    |
|   3 : Liste des sessions ouvertes pour l'utilisateur    |
|   x : Retour au menu précédent                          |
===========================================================
"
read -p "Faites votre choix : " choix_user

case $choix_user in
	# Informations sur les dernières connexions de l'utilisateur cible
                1) 
			echo "$(date +%F-%X) - $USER - Utilisateur - Information - Dernières connexions de l'utilisateur" >> /var/log/log_evt.txt
			read -p "Nom d'utilisateur " user
              		echo " Date de dernière connexion pour $user :"
                	ssh $utilisateur@$ip "sudo -S lastlog -u $user"
               		sleep 5s
			;;
   	# Informations derniers changements de mot de passe de l'utilisateur cible
                2) 
			echo "$(date +%F-%X) - $USER - Utilisateur - Information - Derniers changements de mot de passe" >> /var/log/log_evt.txt
			read -p "Nom d'utilisateur " user
	                echo "Date de dernière modification du mot de passe pour $user"
                   	ssh $utilisateur@$ip 'sudo -S grep passwd /var/log/auth.log'
                	sleep 5s
			;;
   	# Informations liste des sessions ouvertes de l'utilisateur cible
                3) 
			echo "$(date +%F-%X) - $USER - Utilisateur - Information - Liste des sessions ouvertes de l'utilisateur" >> /var/log/log_evt.txt
			read -p "Nom d'utilisateur " user
                 	echo "Liste des sessions ouvertes pour l'utlisateur $user"
                	ssh $utilisateur@$ip "sudo -S who | grep $user"
                	sleep 5s
			;;
   	# Retour au menu précédent
                x|X)
			echo "$(date +%x-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
			info_user
                	;;
                *)
                	activite_utilisateur
                	;;
esac
}

# Fonction groupe d'appartenance de l'utilisateur cible
groupe_user () {

	ssh $utilisateur@$ip "sudo -S groups $utilisateur"
	sleep 3s
}

# Historique de commandes de l'utilisateur cible
historique_cmd_user () {
	echo "$(date +%F-%X) - $USER - Utilisateur - Info - Historique des commandes de $utilisateur" >> /var/log/log_evt.txt
	ssh $utilisateur@$ip "cat .bash_history -n | tail -30" > history_$utilisateur.txt
	echo "Fichier history_$utilisateur.txt établi avec l'historique des commandes de $utilisateur"
	sleep 1s
}

# Menu de Gestion des droits utilisateurs
droits_user() {

echo "
=========================================================
|		Gestion droits utilisateur		|
=========================================================
| 1 - Droits utilisateur fichier			|
| 2 - Droits utilisateur dossier			|
| x - Menu précédent					|
=========================================================
"

read -p "Faites votre choix : " choix_utilisateur

    case $choix_utilisateur in
	# Affiche les droits utilisateurs d'un fichier particulier
        1)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Affichage des droits d'un fichier" >> /var/log/log_evt.txt
        	read -p "Entrez le nom du fichier : " nom_fichier
        if "ssh $utilisateur@$ip -f $mon_fichier"
	then
                echo "Droits attribués au fichier $nom_fichier :"
                ssh $utilisateur@$ip "sudo -S ls -l $nom_fichier"
        else
                echo "Le fichier $nom_fichier n'existe pas."
        fi
        sleep 5s    
	;;
 	# Affiche les droits utilisateurs d'un dossier cible
        2)
		echo "$(date +%F-%X) - $USER - Utilisateur - Info - Affichage des droits d'un dossier" >> /var/log/log_evt.txt
        	read -p "Entrez le nom du dossier : " nom_dossier
       	 if "ssh $utilisateur@$ip -d $nom_dossier"
	 then
                echo "Droits attribués au dossier $nom_dossier :"
               ssh $utilisateur@$ip "sudo -S ls -ld $nom_dossier"
         else
                echo "Le dossier $nom_dossier n'existe pas."
         fi
         sleep 5s   
	 ;;
	# Retour au menu précédent
	x|X)
		echo "$(date +%F-%X) - $USER - Retour au menu précédent" >> /var/log/log_evt.txt
		info_user
		;;
	# Retour au menu de la fonction
        *)
            fonction_droits_utilisateur
            ;;
    esac
}

# Menu Informations de l'ordinateur
info_computer () {

clear
echo "
=========================================================
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
	# Accès aux informations sur la version du système d'exploitation du système cible
	1)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Version du système d'exploitation" >> /var/log/log_evt.txt
		version_os
		;;
  	# Accès aux informations des diques du système cible
	2)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Informations des disques" >> /var/log/log_evt.txt
		info_disk
		;;
  	# Accès aux informations de l'activité du système cible
	3)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Activité de l'ordinateur" >> /var/log/log_evt.txt
		activite_ordi
		;;
  	# Accès aux informations de la RAM du système cible
	4)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Information sur la RAM" >> /var/log/log_evt.txt
		info_ram
		;;

  	# En cas d'erreur, retour au menu de la fonction
	*)
		info_computer
		;;

esac

}

# Fonction pour obtenir la version de l'OS
version_os () {

	echo "$(date +%F-%X) - $USER - Ordinateur - Info - Version de l'OS" >> /var/log/log_evt.txt
	ssh $utilisateur@$ip "cat /etc/*release"
	sleep 3s
}

# Menu Informations des disques
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

read -p "Faites votre choix : " choix_disque

 case $choix_disque in 
 	# Afficher le nombre de disques du système cible
  		1)  echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher le nombre de disques" >> /var/log/log_evt.txt
  		read -p "Sur quel disque voulez vous l'information ? " disque
		ssh $utilisateur@$ip "sudo -S fdisk -l /dev/$disque" 
  		sleep 5s
		;;
  	# Afficher les informations des partitions des disques du système cible
  		2) echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher les informations partitions par disques" >> /var/log/log_evt.txt
  		ssh $utilisateur@$ip "sudo -S df -h"
  		sleep 5s
		;;
  	# Afficher l'espace restant des disques
  		3) 
			echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher l'espace disque restant" >> /var/log/log_evt.txt
  			ssh $utilisateur@$ip "sudo -S df"
  			sleep 5s
			;;
   	# Afficher le nom et l'espace disque d'un dossier cible
  		4) 
			echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher le nom et l'espace disque d'un dossier" >> /var/log/log_evt.txt
  			read -p "Indiquez le dossier sur lequel le disque est monté" disk
			ssh $utilisateur@$ip "sudo -S df -k $disk"
  			sleep 5s
			;;
   	# Afficher les lecteurs montés du système cible
  		5)	
		       	echo "$(date +%F-%X) - $USER - Ordinateur - Info - Afficher les lecteurs montés" >> /var/log/log_evt.txt
  			ssh $utilisateur@$ip "sudo -S lsblk"
  			sleep 5s
			;;
   	# Retour au menu principal
		p|P)
		       	echo "$(date +%F-%X) - $USER - Retour au menu principal" >> /var/log/log_evt.txt
			sleep 1s
			;;
   	# En cas d'erreur, retour au menu de la fonction
  		*)
		       	echo "Erreur"
  			info_disk
			;;
  		
esac  			
}

# Fonction afficher listes applications
list_app () {

	read -p "Quel filtre souhaitez-vous appliquer ?" filtre
	ssh $utilisateur@$ip "dpkg --list | grep $filtre"
	sleep 3s
	return
}

# Fonction afficher liste services
list_services () {

	read -p "Quel filtre souhaitez-vous appliquer ?" filtre
	ssh $utilisateur@$ip "ps | grep $filtre"
	sleep 3s
	return
}

# Fonction afficher les utilisateurs
list_users () {

	ssh $utilisateur@$ip "cat /etc/passwd"
	sleep 3s
	return
}

# Menu de l'activité de l'ordinateur cible
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
	# Affichage de la liste des applications/ paquets installés sur l'ordinateur cible
	1) 
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Liste des applications/paquets installés" >> /var/log/log_evt.txt
		list_app
		sleep 3s
		;;
	# Affichage de la liste des services en cours d'exécution
	2) 
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Liste des services en cours d'exécution" >> /var/log/log_evt.txt
		list_services
		sleep 3s
		;;
	# Affichage de la liste des utilisateurs locaux
	3)
		echo "$(date +%F-%X) - $USER - Ordinateur - Info - Liste des utilisateurs locaux" >> /var/log/log_evt.txt
		list_users
		sleep 3s
		;;
  	# Retour au menu précédent
	x|X)
 		echo "Retour au menu précédent"
		info_computer
		;;

	# En cas d'erreur, retour au menu de la fonction
	*)	
		activite_ordi
		;;
esac

}

# Fonction affichage de la RAM
info_ram () {

	ssh $utilisateur@$ip "sudo -S free -h -m"
	sleep 3s

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
	# Accès menu informations
		1)
			echo "$(date +%F-%X) - $USER - Redirection vers menu informations" >> /var/log/log_evt.txt
			menu_info
			;;
   	# Accès menu actions
		2)
			echo "$(date +%F-%X) - $USER - Redirection vers le menu des actions" >> /var/log/log_evt.txt
			menu_action
			;;
	# Changement d'utilisateur et/ou de système
		3)	
			echo "$(date +%F-%X) - $USER - Changement d'utilisateur et/ou de poste" >> /var/log/log_evt.txt
			co_ssh
			;;
   	# Sortir du script
		4)
			echo "$(date +%F-%X) - $USER - *******Stop Script*******" >> /var/log/log_evt.txt
			exit
			;;
   	# En cas d'erreur, renvoie au menu principal
		*)
			;;
	esac
done
