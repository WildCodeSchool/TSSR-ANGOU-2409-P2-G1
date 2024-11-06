<div align="center"><H1> Documentation administrateur </H1></div>
_____________________

#### Prérequis techniques
_____________________
> Accès adminsitrateur sur les machines (utilisateur root ou membre du groupe sudo)  
> Connexion internet pour télécharger les paquets  
> Pare-feu désactivé  

_____________________
#### Étapes d'installation et de conf. : instruction étape par étape
_____________________
**Serveur Debian 12**
_____________________
* Configurer les paramètres de la machine serveur :

>  Nom : SRVLX01  
>  Système d'exploitation : Debian 12 Bookworm  
>  Compte : root  
>  Mot de passe : Azerty1*  
>  Adresse IP : 172.16.10.10/24  


* Ajouter un utilisateur au groupe sudo :

Pour ajouter un nouvel utilisateur au groupe sudo, utiliser cette commande :

```bash
usermod -aG sudo <utilisateur>
```

Pour vérifier que l'utilisateur ajouté précédemment appartient bien au groupe sudo, taper :

```bash
groups <utilisateur>
```

Pour changer d'utilisateur :

```bash
su <utilisateur>
```

* Installation de OpenSSH

**Serveur Windows Server 2022**
_____________________


**Client Windows 10**
_____________________


**Client Ubuntu 24.04 LTS**
_____________________

* Configurer les paramètres du client :

 > Nom : CLILIN01  
 > Système d'exploitation : Ubuntu 24.04 LTS  
 > Compte : wilder1  
 > Mot de passe : Azerty1*  
 > Adresse IP fixe : 172.16.10.30/24  

  * Installation de sudo :
 
  * Installation de OpenSSH : 

  * 

_____________________
#### FAQ : solutions aux problèmes connus et communs liés à l’installation et à la configuration
_____________________
