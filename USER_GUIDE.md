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

   - Quand vous éxecuter le script, vous devez rentre les infotmation de l'utilisateur et de l'addrese IP :
   <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-28%20144830.png?raw=true" width="600" height="100">
   

</details>

<details>
<summary><strong>3.2 Windows 
</stronge></summary>

------
   
3.2.1 Connection WinRM 

Pour vous connecter à une machine Windows via WinRM, vous avez besoin de l'adresse IP de la machine et des informations d'identification d'un utilisateur ayant des droits administratifs. Voici comment faire :

Ouvrez un terminal PowerShell sur votre machine locale.
Exécutez la commande suivante pour vous connecter à la machine distante :
```powershell
Enter-PSSession -ComputerName $client -Credential $utilisateur
```
Remplacez $client par le nom de l'ordinateur de la machine distante, et $utilisateur par les informations d'identification de l'utilisateur ayant les permissions nécessaires.

------

3.2.1 Lancement du Script

 - Pour le lancement d'un script, c'est la même chose que pour la partie Linux. La commande pour lancer le script est :
   ```powershell
   .\test.ps1
   ```
   Ensuite, entrez les mêmes informations demandées, comme pour la partie Linux.

</details>


</details>

______

<details> 
<summary><stronge>Utilisation avancée : comment utiliser au mieux les options
</stronge></summary>

#### Notion Avancer

Cette partie sert a vous guider dans l'utilisation avancer des fonctionnaliter du script : 



<details>
<summary><strong>1. Linux
</stronge></summary>

Le script ce découpe en plussieur type de Menu et Sous-Menu

   - Menu Action

     <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20114447.png?raw=true" width="400" height="200">


      I.   Gestions de l'utilisateur

      <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20125255.png?raw=true" width="400" height="200">

      II.   Gestions de l'ordinateur

      <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20125400.png?raw=true" width="400" height="200">

      III.  Prise de main à distance

     <img src="" width="600" height="100">

     
   - Menu Information

     <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20114403.png?raw=true" width="400" height="200">


      I.    Information Utilisateur

      <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20125453.png?raw=true" width="400" height="200">

      II.   Information Ordinateur

      <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20125510.png?raw=true" width="400" height="200">

      III.  Consulter les logs

     
     
      IV.   Effectuer une recherche sur les logs

      <img src="https://github.com/WildCodeSchool/TSSR-ANGOU-2409-P2-G1/blob/script/Capture%20d'%C3%A9cran%202024-11-29%20125546.png?raw=true" width="400" height="200">

</details> 

<details>
<summary><strong>2. Windows 
</stronge></summary>


Le script ce découpe en plussieur type de Menu et Sous-Menu


   - Menu Action

     <img src="https://media.discordapp.net/attachments/1294750817202733097/1312030754175451146/VirtualBoxVM_H2R4sddZ8f.png?ex=674b035c&is=6749b1dc&hm=dbb1a43396a103ca2510bd9de278b602806dcc1bd386d56fde641cf844306cac&=&format=webp&quality=lossless&width=502&height=171" width="400" height="200">


      I.   Gestions de l'utilisateur

      <img src="https://media.discordapp.net/attachments/1294750817202733097/1312030765000691722/VirtualBoxVM_HzKN3DwBdl.png?ex=674b035e&is=6749b1de&hm=d85d7da28daf85fd7d950c498731568b4411fa30aed8ee4719356a89d6fa7346&=&format=webp&quality=lossless&width=401&height=213" width="400" height="200">

      II.   Gestions de l'ordinateur

      <img src="https://media.discordapp.net/attachments/1294750817202733097/1312030772940505139/VirtualBoxVM_SvImDU4AjC.png?ex=674b0360&is=6749b1e0&hm=b4c31d0d17eb7a16a580b487e9f178cd8bc91794affdc41cf78eedc8c307f2c0&=&format=webp&quality=lossless&width=373&height=237" width="400" height="200">

      III.  Prise de main à distance

     <img src="" width="600" height="100">

     
   - Menu Information

     <img src="https://media.discordapp.net/attachments/1294750817202733097/1312030688106778704/VirtualBoxVM_UajK4DUUwo.png?ex=674b034c&is=6749b1cc&hm=b4dd516e480cd0c162d83caef92adce6234f2734cd775ed88d309c134d9e6625&=&format=webp&quality=lossless&width=502&height=191" width="400" height="200">


      I.    Information Utilisateur

      <img src="https://media.discordapp.net/attachments/1294750817202733097/1312030710978183198/VirtualBoxVM_eG3K28mFWc.png?ex=674b0351&is=6749b1d1&hm=af1990809d508e7909d961c267e5e77d5baf5f75c970c7384cefd5d1632fe80d&=&format=webp&quality=lossless&width=502&height=207" width="400" height="200">

      II.   Information Ordinateur

      <img src="https://media.discordapp.net/attachments/1294750817202733097/1312030730544615525/VirtualBoxVM_qA9azlCrFb.png?ex=674b0356&is=6749b1d6&hm=c7df51ecefcb4a3373f7bd36813f753600134cba2dbe75233adcb8a25f43fa49&=&format=webp&quality=lossless&width=377&height=175" width="400" height="200">

      III.  Consulter les logs

     
     
      IV.   Effectuer une recherche sur les logs

      

</details>   



</details> 

-----

#### FAQ : solutions aux problèmes connus et communs liés à l’utilisation



