$logc = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $env:USERNAME - $env:COMPUTERNAME"


#Menu action
function menu_action {

Clear-Host
Write-Host
"
=========================================================
|  		   	Menu Action	                |
=========================================================
|       1 : Gestion de l'utilisateur	                |
|       2 : Gestion de l'ordinateur		      	|
|       3 : Prise de main à distance	(CLI)         	|
|	X : Retour au menu principal	                |
=========================================================
"
$choix_action = Read-Host "Faites votre choix"

switch ($choix_action) {

    1 {
        # Redirection vers la gestion d'utilisateur
        Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Vers la gestion utilisateur"
        gestion_user
        }
    2 {
          # Redirection vers la gestion ordinateur
          Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Vers la gestion ordinateur"
          gestion_computer
          }
    3 {
          # Prise de main Ã  distance
          Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Prise de main Ã  distance"
	      Enter-PSSession -ComputerName $client -Credential $utilisateur
          exit
          }
    X {
          # Retour au menu principal
          Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu principal"
          Write-Host "Retour au menu principal"
          Start-Sleep -Seconds 1
          } 
    default {
            # Retour au menu en cours en cas d'erreur
          menu_action
          }
  }
}

# Menu de Gestion Utilisateur
function gestion_user {
    Clear-Host
    Write-Host "============================================="
    Write-Host "|         Menu Gestion Utilisateur          |"
    Write-Host "============================================="
    Write-Host "| 1 - Création d'un compte utilisateur      |"
    Write-Host "| 2 - Modification du mot de passe          |"
    Write-Host "| 3 - Suppression d'un compte utilisateur   |"
    Write-Host "| 4 - Désactivation d'un compte utilisateur |"
    Write-Host "| 5 - Gestion des groupes utilisateur       |"
    Write-Host "| x - Retour au menu précédent              |"
    Write-Host "| p - Retour au menu principal              |"
    Write-Host "============================================="

    $choix_gestion = Read-Host "Faites votre choix : "

    switch ($choix_gestion) {
        # Accès à la création d'utilisateur
        1 { 
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Création d'utilisateur" ;
            $petit_script = {
                param($wilder, $motdepasse)
                $wilder = Read-Host "Veuillez renseigner le nom de l'utilisateur à créer : " ;
                $motdepasse = Read-Host "Renseignez le mot de passe pour l'utilisateur à créer : " -AsSecureString ;
		New-LocalUser -Name $wilder -Password $motdepasse
            }
            Invoke-Command -ComputerName $client -ScriptBlock $petit_script -ArgumentList $Nom, $motdepasse -Credential $credential ;
            Write-Host "Création de l'utilisateur local : $wilder" ;
            Start-Sleep -Seconds 2
        }

        # Modification du mot de passe de l'utilisateur cible
        2 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Changement de mot de passe" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $wilder = Read-Host "De quel utilisateur souhaitez-vous modifier le mot de passe" ;
            $NewPwd = Read-Host -AsSecureString ;
	    Get-LocalUser -Name $wilder | Set-LocalUser -Password $NewPwd ;
            Write-Host "Le mot de passe de $wilder a été modifié avec succès" } -Credential $utilisateur
            Start-Sleep -Seconds 2
        }

        # Suppression de l'utilisateur cible
        3 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Suppression d'un utilisateur'" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $wilder = Read-Host "Quel compte utilisateur souhaitez-vous supprimer ? " ;
            Remove-LocalUser -Name $wilder ;
            Write-Host "L'utilisateur $wilder a bien été supprimé" ;} -Credential $utilisateur
            Start-Sleep -Seconds 2 -Credential $utilisateur
        }

        # Désactivation de l'utilisateur cible
        4 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Désactivation d'un utilisateur" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $wilder = Read-Host "Quel compte utilisateur souhaitez-vous désactiver ? " ;
            Disable-LocalUser -Name "$wilder" ;
            Write-Host "Désactivation de $wilder réussie" ; } -Credential $utilisateur
            Start-Sleep -Seconds 2 ; 
        }

        # Accès à la gestion des groupes
        5 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Gestion des groupes" ;
            gestion_groupe
        }

        # Retour au menu précédent
        x {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu précédent " ;
            Write-Host "Retour au menu précédent" ;
            Start-Sleep -Seconds 2 ;
            menu_aciton
        }

        #Retour au menu principal
        P {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu principal " ;
            Write-Host "Retour au menu principal" ;
            Start-Sleep -Seconds 2 ;
            #           menu_principal
        }

        # En cas d'erreur, retour au menu de la fonction
        Default {
            gestion_user
        }
    }
}


# Menu de Gestion des groupes
function gestion_groupe {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "|          Gestion des groupes           |"
    Write-Host "=========================================="
    Write-Host "| 1 - Ajout Ã  un groupe d'administration|"
    Write-Host "| 2 - Ajout Ã  un groupe local           |"
    Write-Host "| 3 - Sortie d'un groupe local           |"
    Write-Host "| x - Menu précédent                     |"
    Write-Host "=========================================="

    $choix_groupe = Read-Host "Faites votre choix : "

    switch ($choix_groupe) {
        # Ajout de l'utilisateur cible au groupe d'administration
        1 {  
        Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Ajout d'un utilisateur au groupe administrateur" ;	
 	    Invoke-Command -ComputerName $client -ScriptBlock {
  	    $wilder = Read-Host "Indiquez quel utilisateur Ã  ajouter au groupe d'administration" ;
        Add-LocalGroupMember -Group "Administrateurs" -Member "$wilder" ; } -Credential $utilisateur
        Start-Sleep -Seconds 2
        }

        # Ajout de l'utilisateur cible au groupe local
        2 {  
        Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Ajout d'un utilisateur à un groupe" ;
        Invoke-Command -ComputerName $client -ScriptBlock {    
        $wilder = Read-Host "Renseignez l'utilisateur sur lequel travailler : " ;
        $groupe = Read-Host "Renseignez le groupe auquel vous souhaitez ajouter l'utilisateur : " ;
        Add-LocalGroupMember -Group $groupe -Member $wilder ;} -Credential $utilisateur
        Start-Sleep -Seconds 2
        }

        # Sortie de l'utilisateur cible d'un groupe local
        3 {  
        Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Suppression d'un utilisateur d'un groupe" ;
        Invoke-Command -ComputerName $client -ScriptBlock {    
        $wilder = Read-Host "Renseignez l'utilisateur sur lequel travailler : " ;
        $groupe = Read-Host "Renseignez le groupe auquel vous souhaitez supprimer l'utilisateur" ;
        Remove-LocalGroupMember -Group "$groupe" -Member "$wilder" ;} -Credential $utilisateur
        Start-Sleep -Seconds 2
        }

        # Retour au menu prÃ©cÃ©dent
        x {  Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu prÃ©cÃ©dent" ;
            Write-Host "Retour au menu prÃ©cÃ©dent" ;
            Start-Sleep -Seconds 2
        }
        # En cas d'erreur, retour au menu de la fonction
        Default {
            gestion_groupe
        }
    }
    
}
# Menu de gestion de l'ordinateur
function gestion_computer {
    Clear-Host
    Write-Host "
    ======================================
    |      Menu Gestion Ordinateur       |
    ======================================
    | 1 - Gestion de l'alimentation      |
    | 2 - Gestion des répertoires        |
    | 3 - Gestion du pare-feu            |
    | 4 - Gestion des logiciels          |
    | 5 - Mise à jour système            |
    | x - Menu précédent                 |
    | p - Menu principal                 |
    ======================================
    "
    $choix_computer = Read-Host "Faites votre choix : "

    switch ($choix_computer) {
        # AccÃ¨s au menu Gestion de l'alimentation de l'ordinateur cible
        1 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value " $logc - Action - Gestion de l'alimentation " ;
            gestion_alim
        }

        # AccÃ¨s au menu Gestion des rÃ©pertoires de l'ordinateur cible
        2 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value " $logc - Action - Gestion de l'alimentation " ;
            gestion_directory
        }

        # AccÃ¨s au menu Gestion du pare-feu de l'ordinateur
        3 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value " $logc - Action - Gestion de l'alimentation " ;
            gestion_firewall
        }

        # AccÃ¨s au menu Gestion des logiciels de l'ordinateur cible
        4 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value " $logc - Action - Gestion de l'alimentation " ;
            gestion_logiciel
        }

        # AccÃ¨s Ã  la Mise Ã  jour du systÃ¨me cible
        5 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value " $logc - Action - Gestion de l'alimentation " ;
            maj_system
        }

        # Retour au menu prÃ©cÃ©dent
        x {
            Write-Host "Retour au menu prÃ©cÃ©dent" ;
            Start-Sleep -Seconds 2 ;
            menu_action
        }

        # Retour au menu principal
        p {
            Write-Host "Retour au menu principal" ;
            Start-Sleep -Seconds 2
        }
        
        # En cas d'erreur retour au menu de la fonction
        Default {
            gestion_computer
        }
    }

}

# Fonction pour la gestion de l'alimentation du PC cible

function gestion_alim {
    Clear-Host
    Write-Host "
=========================================================
|               Gestion de l'alimentation               |
=========================================================
|     1 - Arrêter l'ordinateur                          |
|     2 - Redémarrer l'ordinateur                       |
|     3 - Verrouiller l'ordinateur                      |
|     X - Menu précédent                                |
=========================================================
"
    $choix_alim = Read-Host "Faites votre choix"

   switch ($choix_alim) {
        1 {
            Invoke-Command -ComputerName $client -ScriptBlock {
    $confirm = Read-Host "Êtes-vous sûr de vouloir arrêter l'ordinateur ? (o/n)"
            if ($confirm -match '^(o|O)$') {
                Stop-Computer -Force
            } else {
                Write-Host "Action annulÃ©e."} } -Credential $utilisateur
                Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Ordinateur - Action - Arrêt Ordinateur"
                Start-Sleep -Seconds 1
                gestion_alim
        	}
        
        2 {
    Invoke-Command -ComputerName $client -ScriptBlock {
            $confirm = Read-Host "ÃŠtes-vous sÃ»r de vouloir redÃ©marrer l'ordinateur ? (o/n)"
            if ($confirm -match '^(o|O)$') {
                Restart-Computer -Force}
             else {
                Write-Host "Action annulÃ©e." } } -Credential $utilisateur
                Add-Content -Path C:\Logs\log_evt.log -Value "$logc - Ordinateur - Action - RedÃ©marrage Ordinateur"
                Start-Sleep -Seconds 1  
                gestion_alim
            }
        
        3 {
    Invoke-Command -ComputerName $client -ScriptBlock {
            rundll32.exe user32.dll, LockWorkStation } -Credential $utilisateur
            Add-Content -Path "C:\Logs\log_evt.txt" -Value "$logc - Ordinateur - Action - Verrouillage Ordinateur"
        }
         X {
             Add-Content -Path "C:\PerfLogs\log_evt.log" -Value "$logc - Retour au menu prÃ©cÃ©dent"
            
            Write-Host "Retour au menu prÃ©cÃ©dent."
            gestion_computer
        }
        Default {
            Write-Host "Option invalide. Veuillez rÃ©essayer."
            Start-Sleep -Seconds 1
            gestion_alim
            }
    }

}

# Fonction pour la gestion de rÃ©pertoires
function gestion_directory {
    Clear-Host
    Write-Output "=================================="
    Write-Output "|   Gestion des répertoires      |"
    Write-Output "=================================="
    Write-Output "| 1 - Création de répertoire     |"
    Write-Output "| 2 - Modification de répertoire |"
    Write-Output "| 3 - Suppression de répertoire  |"
    Write-Output "| x - Menu précédent             |"
    Write-Output "=================================="
    
    $Choix_Directory = Read-Host "Faites votre choix : "
  
    switch ($Choix_Directory) {
    # Créer le répertoire Ã  partir du nom et du chemin renseigné
        1 { Invoke-Command -Computername $client -ScriptBlock {$pathdir = Read-Host "Quel est le chemin du dossier que vous souhaitez crÃ©er ?" ; 
            $directory = Read-Host "Quel dossier souhaitez-vous crÃ©er Ã  partir de $pathdir ?" ; 
            New-Item -Path $pathdir\ -ItemType Directory -Name $directory ;
            Write-Output "CrÃ©ation de $directory effectuÃ©e."} -Credential $utilisateur
	    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - CrÃ©ation de RÃ©pertoire $directoy" ;
        }
    # Modifier le rÃ©pertoire Ã  partir du nom, du chemin et du nouveau nom renseignÃ©s
        2 { Invoke-Command -ComputerName $client ScriptBlock {
	$pathdir = Read-Host "Quel est le chemin du dossier que vous souhaitez modifier ?" ;
        $directory = Read-Host "Quel est le nom du dossier que vous souhaitez modifier ?" ;
        $dir_name = Read-Host "Quel nouveau nom souhaitez lui donner ?" ;
        Rename-Item -Path $pathdir\$directory -NewName $dir_name ;
        Write-Output "Modification de $directory en $dir_name effectuÃ©e."} -Credential $utilisateur
	Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Modification de RÃ©pertoire $directory" ;
        }
    # Supprimer le rÃ©pertoire Ã  partir du nom et du chemin renseignÃ©s 
        3 { Invoke-Command -ComputerName $client -ScriptBlock {
	$pathdir = Read-Host "Quel est le chemin du dossier que vous souhaitez supprimer ?" ; 
            $directory = Read-Host "Quel dossier souhaitez-vous supprimer ?" ;
            Remove-Item -Path $pathdir\$directory ;
            Write-Output "Suppression de $directory effectuÃ©e"} -Credential $utilisateur
	Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Modification de RÃ©pertoire $directory" ;
        }
    # Retour au menu prÃ©cÃ©dent
        x { Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu prÃ©cÃ©dent $directory" ;
            Write-Host "Retour Menu PrÃ©cÃ©dent" ; 
            menu_action
        }
    # Retour au menu prÃ©cÃ©dent
        X { Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu prÃ©cÃ©dent $directory" ;
            Write-Host "Retour Menu Précédent" ; 
            menu_action
        }
    # En cas d'erreur, retour au menu de la fonction
        Default { Write-Output "Erreur retour au choix" ; 
            gestion_directory
        }
    }
}


#gestion_firewall.ps1

# Menu de Gestion du pare-feu
function gestion_firewall {
    Clear-Host
    Write-Host "=============================="
    Write-Host "|     Gestion du pare-feu    |"
    Write-Host "=============================="
    Write-Host "| 1 - Activer le pare-feu    |"
    Write-Host "| 2 - Désactiver le pare-feu |"
    Write-Host "| x - Menu précédent         |"
    Write-Host "=============================="

    $choix_firewall = Read-Host "Faites votre choix : "
    
    switch ($choix_firewall) {
        # Activer le pare-feu
        1 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Activation du pare-feu" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True ;
            Write-Host "Pare-feu activé" ;
            Start-Sleep -Seconds 2
            } -Credential $utilisateur
        }
        # Désactiver le pare-feu
        2 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Désactivation du pare-feu" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False ;
            Write-Host "Pare-feu désactivé" ;
            Start-Sleep -Seconds 2
            } -Credential $utilisateur
        }
        # Retour au menu précédent
        x {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu précédent" ;
            Write-Host "Retour au menu précédent" ;
            Start-Sleep -Seconds 2 ;
            gestion_computer
        }

        # En cas d'erreur, retour au menu de la fonction
        Default {
            gestion_firewall
        }
    }
}

#gestion_logicielle.ps1

# Menu de Gestion logiciel
function gestion_logiciel {
    Clear-Host
    Write-Host "================================"
    Write-Host "|       Gestion logiciel       |"
    Write-Host "================================"
    Write-Host "| 1 - Installation logiciel    |"
    Write-Host "| 2 - Désinstallation logiciel |"
    Write-Host "| x - Menu précédent           |"
    Write-Host "================================"
    

    switch ($choix_logiciel) {
        # Installer le logiciel cible
        1 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Installation d'un paquet" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $app = Read-Host "Renseignez le nom de l'application à installer : " ;
            Install-Package -Name $app -Verbose } -Credential $utilisateur
            Start-Sleep -Seconds 2
        }
        
        # Désinstaller le logiciel cible
        2 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Désinstallation d'un paquet" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $app = Read-Host "Renseignez le nom de l'application à installer : " ;
            Uninstall-Package -Name $app -Verbose } -Credential $utilisateur ;
            Start-Sleep -Seconds 2
        }
        
        # Retour au menu précédent
        x {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu précédent " ;
            Write-Host "Retour au menu précédent" ;
            Start-Sleep -Seconds 2
        }
        
        # En cas d'erreur, retour au menu de la fonction
        Default {
            gestion_logiciel
        }
    }
}

# Mise Ã  jour du systÃ¨me 
function maj_system {
# Vérifier si le module PSWindowsUpdate est installÃ©
   Invoke-Command -Computername $client -Scriptblock  {
	If (-Not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Installation du module PSWindowsUpdate..." 
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
    }

    # Importer le module PSWindowsUpdate
    Import-Module PSWindowsUpdate

    # Installer les mises Ã  jour disponibles
    Write-Host "Ordinateur - Action : Installation des mises à jour..." 
    Try {
        Get-WindowsUpdate -AcceptAll -Install
        Write-Host "Mises Ã  jour installÃ©es avec succÃ¨s." 
    } Catch {
        Write-Error "Une erreur est survenue lors de l'installation des mises à jour : $_"
        Return
    }

    # Demander à l'utilisateur s'il souhaite redémarrer
    Write-Host "Le système doit être redémarrer pour appliquer certaines mises Ã  jour." 
    $choix_system = Read-Host "Voulez-vous redémarrer votre ordinateur ? (o/n)"

    # Utilisation de conditions If pour éviter les erreurs
    If ($choix_system -eq "o" -or $choix_action -eq "oui" -or $choix_action -eq "y" -or $choix_action -eq "yes") {
        Write-Host "Ordinateur - Action : Redémarrage du système..." 
        Restart-Computer
    } Else {
        Write-Host "Pensez Ã  redémarrer votre ordinateur pour appliquer les mises à jour." 
        Write-Host "Retour au menu principal." -ForegroundColor Cyan
        Start-Sleep -Seconds 2
    }
	} -Credential $utilisateur
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Action - Mise à jour du système effectuée"
}
# Menu info
function menu_info {
Clear-Host
Write-Host "
=========================================================
|               Menu Information        		|
=========================================================
|       1 : Information utilisateur		      	|
| 	2 : Information ordinateur	            	|
|	3 : Consulter les logs        			|
|	4 : Effectuer une recherche sur les logs       	|
| 	p : Retour au menu principal             	|
=========================================================
"

$choix_info = Read-Host "Faites votre choix"

switch($choix_info) {

    1 {
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Vers les informations utilisateur"
    info_user
    }
    2 {
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Vers les informations ordinateur"
    info_computer
    }
    3 {
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Consulation des logs"
    Add-Content -Path C:\Users\Administrateur\log.txt -Value (Get-Content -Path C:\PerfLogs\log_evt.log)
    Start-Sleep -Seconds 1
    menu_info
    }
    4 {
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Recherche d'Ã©vÃ¨nements logs"
    search_log
    }
    p {
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu principal"
    Write-Host "Retour au menu principal"
    Start-Sleep -Seconds 1
    }
    default {
    Write-Host "Erreur, veuillez rÃ©essayer"
    Start-Sleep -Seconds 1
    menu_info
    }
    }    
}

# Menu des informations sur l'utilisateur
function info_user {
	Clear-Host
	Write-Host 

"
=========================================================
|		Menu Information Utilisateur		|
=========================================================
|	1 : Activité de l'utilisateur		        |
|	2 : Groupe d'appartenance de l'utilisateur      |
|	3 : Historique des commandes de l'utilisateur	|
|	4 : Droits et permissions de l'utilisateur	|
| 	x : Retour au menu précédent			|
=========================================================

"
$choix_info = Read-Host "Faites votre choix"

switch ($choix_info) {
 

	1 {
    # Redirection vers l'activitÃ© d'utilisateur

    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Observation de l'activitÃ© utilisateur"
    
    activitÃ©_user }


    2   { # Redirection vers Groupe d'appartenance de l'utilisateur

    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Groupes de l'utilisateur"

    groupe_user }


    3  {  # Redirection  vers l' historique des commandes de l'utilisateur

  Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Historique des commandes de l'utilisateur"

  historique_cmd_user }

   4 {     # Redirection vers les Droits et permissions de l'utilisateur

  Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Droits et permissions de l'utilisateur "

  droits_user }

   x  {  #  Retour au menu precedent


  Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu precedent"
  
  Write-Host "Retour au menu precedent"

  Start-Sleep -Seconds 1
  menu_info
}

}
}

# Menu Informations de l'activitÃ© de l'utilisateur
function activite_user {
    Clear-Host
    Write-Host "=============================================================="
    Write-Host "|           Information Activite Utilisateur                 |"
    Write-Host "=============================================================="
    Write-Host "| 1 - Date des dernières connexions de l'utilisateur         |"
    Write-Host "| 2 - Date des derniers changements de mot de passe          |"
    Write-Host "| 3 - Liste des sessions ouvertes pour l'utilisateur         |"
    Write-Host "| x - Retour au menu précédent                               |"
    Write-Host "=============================================================="

    $choix_user = Read-Host "Faites votre choix : "

    switch ($choix_user) {
        # Informations sur les derniÃ¨res connexions de l'utilisateur cible
        1 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - DerniÃ¨res connexions de l'utilisateur" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $wilder = Read-Host "Renseignez le nom de l'utilisateur cible" ;
            Write-Host "Dates des derniÃ¨res connexions de l'utilisateur $wilder : " ;
                $DCList = Get-ADDomainController -Filter * | Sort-Object Name | Select-Object Name
                $TargetUser = $wilder
                $TargetUserLastLogon = $null
                Foreach($DC in $DCList){

                    $DCName = $DC.Name
             
                    Try {
                        
                        # RÃ©cupÃ©rer la valeur de l'attribut lastLogon Ã  partir d'un DC (chaque DC tour Ã  tour)
                        $LastLogonDC = Get-ADUser -Identity $TargetUser -Properties lastLogon -Server $DCName
            
                        # Convertir la valeur au format date/heure
                        $LastLogon = [Datetime]::FromFileTime($LastLogonDC.lastLogon)
            
                        # Si la valeur obtenue est plus rÃ©cente que celle contenue dans $TargetUserLastLogon
                        # la variable est actualisée : ceci assure d'avoir le lastLogon le plus récent Ã  la fin du traitement
                        If ($LastLogon -gt $TargetUserLastLogon)
                        {
                            $TargetUserLastLogon = $LastLogon
                        }
             
                        # Nettoyer la variable
                        Clear-Variable LastLogon
                        }
            
                    Catch {
                        Write-Host $_.Exception.Message -ForegroundColor Red
                    }
            }
            
            Write-Host "Date de derniÃ¨re connexion de $TargetUser :"
            Write-Host $TargetUserLastLogon
            } ;
            Start-Sleep -Seconds 5
        }

        # Informations sur les derniers changements de mot de passe de l'utilisateur cible
        2 {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Derniers changements de mot de passe" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $wilder = Read-Host "Renseignez le nom de l'utilisateur cible" ;
            Write-Host "Dates des derniÃ¨res modifications du mot de passe pour $wilder : " ;
            Get-ADUser -filter $wilder -properties passwordlastset, passwordneverexpires |ft Name, passwordlastset, Passwordneverexpires} -Credential $utilisateur ;
            Start-Sleep -Seconds 5
        } 

        # Informations liste des sessions ouvertes de l'utilisateur cible
        3 {
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Liste des sessions ouvertes de l'utilisateur" ;
            Invoke-Command -ComputerName $client -ScriptBlock {
            $wilder = Read-Host "Renseignez le nom de l'utilisateur cible : " ;
            Write-Host "Liste des sessions ouvertes pour l'utilisateur $wilder" ;
            Get-localUser -name $using:utilisateur | Select-Object Enabled } -Credential $utilisateur ;
            Start-Sleep -Seconds 5
        }
        
        # Retour au menu prÃ©cÃ©dent
        x {  
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu prÃ©cÃ©dent" ;
            Write-Host "Retour au menu précédent" ;
            Start-Sleep -Seconds 5 ;
            info_user
        }

        # En cas d'erreur, retour au menu de la fonction
        Default {
            activite_user
        }
    }

}


function groupe_user {
    
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Consultation groupe d'appartenance de $wilder"
    Invoke-Command -ComputerName $client -ScriptBlock {
     $wilder = Read-Host "Renseignez l'utilisateur cible"
     Get-ADUser -Identity $wilder -Properties memberof | Select-Object memberof -ExpandProperty memberof } -Credential $utilisateur
    Start-Sleep -Seconds 5

}

function historique_cmd_user {
 # AccÃ¨s Ã  l'historique des commandes de l'utilisateur cible
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Utilisateur - Info - Historique des commandes de l'utilisateur"
            Invoke-Command -ComputerName $client -ScriptBlock {Write-Host "Consultation de l'historique des commandes de l'utilisateur en cours..."
            Get-History | Format-Table -AutoSize} -Credential $utilisateur
	    Start-Sleep -Seconds 5
}
function droits_user {
Clear-Host
Write-Host "
=========================================================
|             Information droits utilisateur            |
=========================================================
| 	1 - Droits utilisateur fichier                  |
|	2 - Droits utilisateur dossier                  |
|	x - Menu précédent                              |
========================================================="

    $choix_utilisateur = Read-Host "Quels informations souhaitez-vous ?"

    switch ($choix_utilisateur) {
        1 {
	Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Droits utilisateur fichier"
            Invoke-Command -ComputerName $client -ScriptBlock {
		$nom_fichier = Read-Host "Entrez le nom du fichier"
           	if (Test-Path -Path $nom_fichier -PathType Leaf) {
                Write-Host "Droits attribuÃ©s au fichier $nom_fichier :"
                Get-Acl -Path $nom_fichier | Format-List
            } else {
                Write-Host "Le fichier $nom_fichier n'existe pas."
            }
	} -Credential $utilisateur
 	Start-Sleep -Seconds 5
        }
        2 {
	Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Droits utilisateur dossier"
            Invoke-Command -ComputerName $client -Scriptblock {
		$nom_dossier = Read-Host "Entrez le nom du dossier"
            if (Test-Path -Path $nom_dossier -PathType Container) {
                Write-Host "Droits attribuÃ©s au dossier $nom_dossier :"
                Get-Acl -Path $nom_dossier | Format-List
            } else {
                Write-Host "Le dossier $nom_dossier n'existe pas."
            }
	} -Credential $utilisateur
 	Start-Sleep -Seconds 5
        }
        "x" { 
            # Retour au menu prÃ©cÃ©dent
            return
        }
        default {
            Write-Host "Option invalide, veuillez rÃ©essayer."
            droits_user
        }
    }
}

# Menu information de l'ordinateur

function info_computer {

Clear-Host 
Write-Host
"
===========================================
|	Informations Ordinateur  	  |
===========================================
| 1 - Version du système d'exploitation   |
| 2 - Informations des disques	          |
| 3 - Activité de l'ordinateur		  |
| 4 - Informations sur la RAM             |
| x - Retour au menu précédent		  |
==========================================="

$choix_computer = Read-Host "Faites votre choix : "

switch ($choix_computer) {
  # AccÃ¨s aux informations sur la version du systÃ¨me d'exploitation du systÃ¨me cible
    1  { 
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Version du systÃ¨me d'exploitation" ;
    version_os 
    }
  
  # AccÃ¨s aux informations des diques du systÃ¨me cible
    2 {  
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info -  Informations des disques" ;
    info_disk
    }

  # AccÃ¨s aux informations de l'activitÃ© du systÃ¨me cible
    3 { 
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Activité de l'ordinateur" ;
    activité_ordi
    }
  
  # AccÃ¨s aux informations de la RAM du systÃ¨me cible
    4 { 
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Informations sur la RAM " ;
    info_ram
    }

    x {
      Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu prÃ©cÃ©dent " ;
      Start-Sleep -Seconds 2 ;
      menu_info
    }
  # En cas d'erreur, retour au menu de la fonction
    Default {
      info_computer
    }
  }
} 

# Afficher la version de l'OS
function version_OS {
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Version de l'OS"
    Invoke-Command -ComputerName $client -ScriptBlock {
    Get-WmiObject Win32_OperatingSystem | findstr /C:"Version"
    } -Credential $utilisateur
    Start-Sleep -Seconds 5
}

# Fonction des commande qui concerne les information disque
function info_disk {
Clear-Host
Write-Host "
==============================================================
|              Information Disque                            |
==============================================================
|   1 : Afficher nombre de disque                            |
|   2 : Afficher les informations partitions par disque      |
|   3 : Afficher l'espace disque restant                     |
|   4 : Afficher le nom et l'espace disque d'un dossier      |
|   5 : Afficher les lecteurs montés                         | 
|   P : Retour au menu principal                             |
=============================================================="

    $choix_disque = Read-Host "Faites votre choix : "

    switch ($choix_disque) {
        1 {
            # Affiche le ou les disque
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Ordinateur - Info - Afficher le nombre de disques"
            Invoke-Command -ComputerName $client -Credential $utilisateur -ScriptBlock { Get-Disk | Format-Table Number, FriendlyName, OperationalStatus, Size -AutoSize }
            Start-Sleep -Seconds 5
        }
        2 {
            # Affiche la table des partions du ou des disques 
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Ordinateur - Info - Afficher les informations partitions par disques"
            Invoke-Command -ComputerName $client -Credential $utilisateur -ScriptBlock { Get-Partition | Format-Table DiskNumber, PartitionNumber, DriveLetter, Size -AutoSize } 
            Start-Sleep -Seconds 5
        }
        3 {
            # Affiche l'espace disque utiliser et restant du ou des diques 
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Ordinateur - Info - Afficher l'espace disque restant"
            Invoke-Command -ComputerName $client -Credential $utilisateur -ScriptBlock { Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='FreeSpace(GB)';
	    Expression={[math]::round($_.Free/1GB,2)}}, @{Name='UsedSpace(GB)';
     	    Expression={[math]::round(($_.Used/1GB),2)}} | Format-Table -AutoSize } 
            Start-Sleep -Seconds 5
        }
        4 { 
            # Affiche le nom et l'espace disque d'un dossier
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Ordinateur - Info - Afficher le nom et l'espace disque d'un dossier"
            Invoke-Command -ComputerName $client -Credential $utilisateur -ScriptBlock { 
	    Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name='FreeSpace(GB)';
	    Expression={[math]::round($_.Free/1GB,2)}}, @{Name='UsedSpace(GB)';Expression={[math]::round(($_.Used/1GB),2)}} | Format-Table -AutoSize }
            Start-Sleep -Seconds 5
        }
        5 {
            # Affiche les lecteurs montès
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Ordinateur - Info - Afficher les lecteurs montÃ©s"
            Invoke-Command -ComputerName $client -Credential $utilisateur -ScriptBlock { Get-Volume | Format-Table DriveLetter, FileSystemLabel, FileSystem, SizeRemaining, Size -AutoSiz }
            Start-Sleep -Seconds 5
        }
        "P" {
            # Retour au menu principal
             Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Retour au menu principal"
             Start-Sleep -Seconds 1
        }
        default {
            # Option invalide
            Write-Host "Erreur : Option invalide."
            info_disk
        }
    }
}

# Menu de l'activitÃ© de l'ordinateur cible
function activite_ordi {

    Clear-Host
    Write-Host "
    ==================================================
    | 		Activité ordinateur	             |
    | 1 : Liste des applications / paquets installés |
    | 2 : Liste des services en cours d'exécution    |
    | 3 : Liste des utilisateurs locaux		     |
    | X : Retour au menu précédent		     |
    ==================================================
        "
    $choix_activite = Read-Host "Faites votre choix"

    Switch ($choix_activite) {
	# Affichage de la liste des applications/ paquets installÃ©s sur l'ordinateur cible
        1 {
            Invoke-Command -ComputerName $client -Scriptblock {
		Write-Host "Ordinateur - Info - Liste des applications / paquets installÃ©es :"
           	Get-Package } -Credential $utilisateur
	    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Liste des applications/paquets installés"
            Start-Sleep -Seconds 5
            activite_ordi
        	}
	# Affichage de la liste des services en cours d'exÃ©cution
        2 { 
            Invoke-Command -Computername $client -ScriptBlock  {
		Write-Host "Ordinateur - Info - Liste des services en cours d'execution :"
          	Get-Service | Where-Object { $_.Status -eq "Running" } 
		} -Credential $utilisateur
	    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Liste des services en cours d'exécution"
            Start-Sleep -Seconds 5
            activite_ordi
        }
	# Affichage de la liste des utilisateurs locaux
        3 { 
            Write-Host "Ordinateur - Info - Liste des utilisateurs locaux :"
            Invoke-Command -Computerame $client -Scriptblock { Get-LocalUser | Format-Table -AutoSize } -Credential $utilisateur
            Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Information - Liste des utilisateurs locaux"
            Start-Sleep -Seconds 5
            activite_ordi
        }
	# Retour au menu prÃ©cÃ©dent
        x {
	Write-Host "Retour Menu PrÃ©cÃ©dent" ; 
        menu_action
	}

        Default {
	Write-Output "Erreur retour au choix" ; 
	activite_ordi
	}
    }
}

function info_ram {
    Clear-Host
    Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Info - Version de l'OS"
    Invoke-Command -ComputerName $client -ScriptBlock {
    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize
    } -Credential $utilisateur
    Start-sleep -Seconds 5
}


function search_log {
Clear-Host
Write-Host "
===========================================
| 	     Type de recherche	          |
===========================================
|  1 : Recherche sur l'utilisateur        |
|  2 : Recherche sur l'ordinateur         |
|  3 : Recherche par mots-clefs		  |
|  x : Retour au menu précédent           |
===========================================
    "

$choix_log = Read-Host "Faites votre choix : "

switch ($choix_log)
{

    1{
        Add-Content -Path C:\PerfLogs\log_evt.log -Value "$logc - Logs - Recherche sur l'utilisateur"
        Write-Host "Recherche par utilisateur"
        $recherche = $env:USERNAME
        Get-Content -Path .\log_evt.log | findstr "$recherche"
	Start-Sleep -Seconds 10
        }
    2{
        Write-Host "Recherche par Ordinateur"
        $recherche = $env:COMPUTERNAME
        Get-Content -Path .\log_evt.log | findstr "$recherche"
	Start-Sleep -Seconds 10
        }
    3{
        Write-Host "Recherche par mots-clefs"
        $recherche = Read-Host "Renseignez le ou les mot(s) clef(s) "
        Get-Content -Path .\log_evt.log | findstr "$recherche"
	Start-Sleep -Seconds 10
        }
    x {
        Write-Host "Retour au menu prÃ©cÃ©dent"
        menu_info
        }

    default {
        Write-Host "Erreur, rÃ©essayer"
        sleep -Seconds 1
        search_log
        }
    }
}


# DÃ©but des logs avec le start script
 Add-Content -Path C:\PerfLogs\log_evt.log -Value  "$logc - *******Start Script*******"

    # Demander nom utilisateur     
    $utilisateur = Read-Host "indiquez l'utilisateur sur lequel vous connecter "                                                 
    # Demander l'IP de l'utilisateur
    $client = Read-Host "indiquer le nom du poste client"

 # Menu principal

 While ($true) {
 Clear-host
 Write-Host 
 "
=========================================================
|               Menu Principal			        |
=========================================================
|       1 : Obtenir une informations		        |
|       2 : Effectuer une action		        |
|       3 : Quitter			                |
========================================================="

$choix = Read-Host "Faites votre choix"

switch ($choix) {

    1 { 
   	  Add-Content -Path C:\PerfLogs\log_evt.log -Value  "$logc - Redirection vers menu information"
   	  menu_info
        }
    2 {
       	 Add-Content -Path C:\PerfLogs\log_evt.log -Value  "$logc - Redirection vers menu action"
     	 menu_action
        }
    3 {
       	 Add-Content -Path C:\PerfLogs\log_evt.log -Value  "$logc - *******Stop Script*******"
     	 exit
        }
    default {
        }
    }
}
