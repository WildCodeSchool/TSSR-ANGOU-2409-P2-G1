<div align="center"><H1> Documentation administrateur </H1></div>

### Prérequis Techniques

- Accès administrateur sur les machines (utilisateur root ou membre du groupe sudo)
- Connexion internet pour télécharger les paquets
- Pare-feu désactivé temporairement pour faciliter l'installation et la configuration initiale
- Avoir un Active Directory fonctionnel avec un utilisateur et des droits fonctionnels. Référez-vous à [_ce lien_](https://www.it-connect.fr/creer-un-domaine-ad-avec-windows-server-2016/).

----------------------------------------------------------------------
 
### Étapes d'Installation et de Configuration : Instructions Pas-à-Pas

----------------------------------------------------------------------

<details>
<summary><strong>Serveur Debian 12
</stronge></summary>

1. **Configuration des paramètres de la machine serveur :**
   - Nom : **SRVLX01**
   - Système d'exploitation : **Debian 12 Bookworm**
   - Compte : **Administrateur**
   - Mot de passe : **Azerty1***
   - Adresse IP : **172.16.10.10/24**

2. **Ajouter un utilisateur au groupe sudo :**
   - Pour ajouter un nouvel utilisateur au groupe sudo :
     ```bash
     usermod -aG sudo <utilisateur>
     ```
   - Pour vérifier que l'utilisateur appartient au groupe sudo :
     ```bash
     groups <utilisateur>
     ```
   - Pour changer d'utilisateur :
     ```bash
     su <utilisateur>
     ```

3. **Installation de OpenSSH :**
   - Mettre à jour les paquets et installer le service SSH :
     ```bash
     sudo apt update && sudo apt install -y openssh-server
     ```
   - Vérifier l'état du service SSH :
     ```bash
     sudo systemctl status ssh
     ```
   - Démarrer, arrêter ou redémarrer le service SSH :
     ```bash
     sudo systemctl start ssh
     sudo systemctl stop ssh
     sudo systemctl restart ssh
     ```

4. **Connexion à distance au serveur depuis un client :**
   - Pour se connecter au serveur via SSH :
     ```bash
     ssh utilisateur@<IP_du_serveur>
     ```
   - Pour sortir de la session SSH :
     ```bash
     exit
     ```
</details>


<details>
<summary><stronge>Client Ubuntu 24.04 LTS
</stronge></summary>

1. **Configuration des paramètres du client :**
   - Nom : **CLILIN01**
   - Système d'exploitation : **Ubuntu 24.04 LTS**
   - Compte : **wilder1**
   - Mot de passe : **Azerty1***
   - Adresse IP fixe : **172.16.10.30/24**

2. **Installation de OpenSSH :**
   - Mise à jour des paquets et installation d'OpenSSH :
     ```bash
     sudo apt update && sudo apt install -y openssh-server
     ```
   - Vérification de l'état du service SSH :
     ```bash
     sudo systemctl status ssh
     ```
   - Commandes pour démarrer, arrêter ou redémarrer le service SSH :
     ```bash
     sudo systemctl start sshd
     sudo systemctl stop sshd
     sudo systemctl restart sshd
     ```
</details> 

------------------------------------------------------------------

<details>
<summary><stronge>Serveur Windows Server 2022</stronge></summary>

1. **Configuration des paramètres de la machine serveur :**
   - Nom : **SRVWIN01**
   - Système d'exploitation : **Windows Server 2022**
   - Compte : **root**
   - Mot de passe : **Azerty1**
   - Adresse IP : **172.16.10.5/24**

2. **Installation de OpenSSH via PowerShell :**
   - **Étapes pour installer et configurer OpenSSH** :
   
     1. **Installation de OpenSSH** :
        ```powershell
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        ```
     2. **Démarrage du service SSH** :
        ```powershell
        Start-Service -Name sshd
        ```
     3. **Vérification de l'état du service SSH** :
        ```powershell
        Get-Service -Name sshd
        ```
     4. **Configurer le démarrage automatique du service SSH** :
        ```powershell
        Set-Service -Name sshd -StartupType 'Automatic'
        ```

3. **Connexion à distance vers un serveur Windows via SSH :**
   - Utilisez la commande suivante depuis un terminal compatible SSH (par exemple, PowerShell sur le client) :
     ```powershell
     ssh utilisateur@<IP_du_serveur>
     ```
   - Pour fermer la session SSH :
     ```powershell
     exit
     ```
</details>

<details>
<summary><stronge>Client Windows 10 Pro
</stronge></summary>   

1. **Configuration des paramètres de la machine client :**
   - Nom : **CLIWIN01**
   - Système d'exploitation : **Windows 10 Pro**
   - Compte : **root**
   - Mot de passe : **Azerty1***
   - Adresse IP : **172.16.10.20/24**

2. **Installation de OpenSSH via PowerShell :**
   - **Étapes pour installer et configurer OpenSSH** :
     1. **Installation de OpenSSH** :
        ```powershell
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
        ```
     2. **Démarrage du service SSH** :
        ```powershell
        Start-Service -Name sshd
        ```
     3. **Vérification de l'état du service SSH** :
        ```powershell
        Get-Service -Name sshd
        ```
     4. **Configurer le démarrage automatique du service SSH** :
        ```powershell
        Set-Service -Name sshd -StartupType 'Automatic'
        ```
</details>

<details>
<summary><stronge>Instalation et configuration de WinRM Client et Serveur 
</stronge></summary>
 
 
 1) Vérifier si WinRM est activé

Sous Windows Server, la « Gestion à distance » est activée par défaut, ce qui implique que WinRM est actif. Pour vous en assurer, contrôlez l’état du service **WinRM** avec la commande suivante :

```powershell
Get-Service WinRM
```

2) Activer WinRM

Activez WinRM en démarrant le service avec la commande suivante :

```powershell
Start-Service WinRM
```

3) Tester WinRM

Testez WinRM avec la commande suivante :

```powershell
Enter-PSSession -ComputerName PCTEST -Credential "NOMUTILISATEUR"
```

- `-ComputerName` : remplacez **PCTEST** par le nom de la machine distante.
- `-Credential` : remplacez **NOMUTILISATEUR** par le nom de l'utilisateur ayant les droits d'accès à la machine distante.

Notes supplémentaires

- Vérifiez que le pare-feu autorise les connexions sur le port **5985** (HTTP) ou **5986** (HTTPS).
- Utilisez `Enable-PSRemoting` si WinRM n'est pas configuré sur la machine.
    
</details>

----------------------------------------------------

### FAQ : Solutions aux Problèmes Connus et Courants

- **Problème : Erreur de connexion SSH depuis un client vers le serveur.** 
  - _Solution : Vérifiez que le service SSH est bien démarré sur le serveur et que le pare-feu autorise le port 22._


- **Problème : L'utilisateur ajouté n'a pas les droits sudo sur Debian.**
  - _Solution : Vérifiez que l'utilisateur fait bien partie du groupe sudo en utilisant la commande `groups <utilisateur>`._


- **Problème : OpenSSH n'est pas disponible dans les fonctionnalités Windows.**
  - _Solution : Assurez-vous que votre version de Windows est compatible et que votre système est à jour._


- **Problème : Comment ce connecter en SSH.**
  - _Solution : Voir le `Uuer_Guide`._


- **Problème :  Erreur lors de la connections en ssh sur le port 22.**
  - _Solution :  taper la commmande pour ouvire le port 22 :_ 

  Bash
  ```bash
  sudo ufw allow 22/tcp comment 'Allow SSH'
  ```
