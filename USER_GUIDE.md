<div align="center"><H1> Documentation utilisateur </H1></div>

#### Introduction

Dans un premier temps, il est important d'avoir consulté la documentation administrateur pour la mise en place des machines (serveurs et clientes) et leur configuration respective et s'assurer de leur accessibilité sur le réseau. Pour rappel, l'objectif est d'exécuter un script d'une machine serveur à une machine cliente distante.

#### Prérequis

Pour une utilisation correcte du script, assurez-vous :
* Que votre client et votre serveur communiquent sur le même réseau
* D'avoir suivi toutes les étapes de la documentation administrateur (INSTALL.md)
* D'avoir récupéré le script depuis GitHub et de le mettre sur votre serveur
* D'avoir les permissions nécessaires pour l'exécution du script et de ses commandes (Droits Administrateurs)

----------

<details>
<summary><strong>Utilisation de base : comment utiliser les fonctionnalités clés
</summary></strong>

#### Démarrage

Après vous être assurez du respect des prérequis vous pouvez :

1. Ouvrir un invite de commande sur la machine hôte.
2. Vous rendre dans le répertoire où se situe le script.
3. Lancememt du script.

<details>
<summary><strong>3.1 Linux
</stronge></summary>

-------   

3.1.1 Connetions SSH :

   Pour vous connecter à une machine distante via SSH, vous avez besoin de l'adresse IP de la machine et du nom d'utilisateur. Voici comment faire :
   Ouvrez un terminal sur votre machine locale.
   
   Tapez la commande suivante pour vous connecter à la machine distante :      
   ```bash
   ssh utilisateur@adresse_ip
   ``` 
   Remplaez utilisateur par le nom de l'utilisateur de la machine distante et adresse_ip par l'adresse IP ou le nom de domaine de la machine.
   Exemple de connexion :
   ```bash
    ssh alice@192.168.1.10
   ```
   Lors de la première connexion, il vous sera demandé de confirmer l'empreinte numérique du serveur. Tapez `yes` pour accepter.
   Entre le mot de passe lorsque cela est demandé. Vous serez alors connecté à la machine distante.

-------

3.1.2 Lancement du script :  

<img src="[]" width="100" height="100">


</details>

<details>
<summary><strong>3.2 Windows 
</stronge></summary>


</details>
  
</details>

______

<details> 
<summary><stronge>Utilisation avancée : comment utiliser au mieux les options
</stronge></summary>

______


______
#### FAQ : solutions aux problèmes connus et communs liés à l’utilisation
______
