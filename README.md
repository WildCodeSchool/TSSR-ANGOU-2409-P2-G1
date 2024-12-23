![210px-WildCodeSchool_logo_pink_background_400x220.png](https://upload.wikimedia.org/wikipedia/fr/thumb/e/e4/WildCodeSchool_logo_pink_background_400x220.png/210px-WildCodeSchool_logo_pink_background_400x220.png)

<div align="center"><H1> Projet Scripting Groupe 1 </H1></div>

## Présentation du projet et des objectifs finaux
_______

Le projet consiste à créer un script qui s’exécute sur une machine et effectue des tâches sur des machines distantes. Deux versions du script sont attendues : une version en bash et une seconde en PowerShell. Dans l'ensemble, le script doit réaliser des tâches comme des actions ou de simples requêtes d'information. Ce projet se réalise en équipe, avec la rédaction d'une documentation de toutes les étapes et une démonstration est attendue pour la réalisation finale. 

L’ensemble des machines sont sur le même réseau avec la mise en place d'une architecture client/serveur : 
> Debian 12 Bookworm x Ubuntu 24.04 LTS  
> Windows Server 2022 x Windows 10 Pro  
> Debian 12 Bookworm x Windows 10 Pro  
> Windows Server 2022 x Ubuntu 24.04 LTS  

_______
## Introduction : mise en contexte
_______

Un script est un outil puissant permettant d'automatiser des tâches. Il permet de réduire les charges de travail manuelles, améliorer la précision et l'efficacité des processus. En raison de ses multiples avantages, l'utilisation de scripts est devenue une pratique courante dans de nombreux secteurs, administration, service informatique, etc. L'automatisation des tâches, peu importe leur nature, est aujourd'hui un élément important, parfois sous-estimé, qui peut faire gagner beaucoup de temps et donc de l'argent. En intégrant des scripts d’automatisation, les professionnels peuvent significativement améliorer l’efficacité de leurs workflows, réduire les erreurs et libérer du temps pour des tâches à plus grande valeur ajoutée.
_______
## Membres du groupe de projet et Rôles par sprint
_______
| | Théophile | Fabrice | Dylan | Axel | Bastien |
| :-: | :-: | :-: | :-: | :-: | :-: |
| Semaine 1 | Techos | Techos | Scrum Master | Product Owner | Techos |
| Semaine 2 | Techos | Techos | Product Owner | Scrum Master | Techos |
| Semaine 3 | Scrum Master | Product Owner | Techos | Techos | Techos |
| Semaine 4 | Techos | Scrum Master | Techos | Techos | Product Owner |
| Semaine 5 | Product Owner | Techos | techos | Techos | Scrum Master |

_______
## Choix techniques : quel OS, quelle version, etc.
_______
Pour ce projet, nous avons mis en place 4 machines virtuelles :

Un client et un serveur Windows ainsi qu'un client et un serveur Linux.

> Pour le **client Windows** :  
>       OS : Microsoft Windows ; Version : Windows 10 - Pro  
> Pour le **client Linux** :  
>       OS : Linux ; Version : Ubuntu 24.04 LTS  
> Pour le **serveur Windows** :  
>       OS : Windows ; Version : Windows Server 2022  
> Pour le **serveur Linux** :  
>       Os : Debian ; Version : Debian 12 Bookworn (64-bit).  

_______
## Difficultés rencontrées : problèmes techniques rencontrés
_______

1. Bash :
> 1.1 Demande du mot de passe récurrente  
> 1.2 Modification du mot de passe (passwd)

2. PowerShell : 
> 2.1 Get-CimInstance -ClassName Win32_PhysicalMemory, commande pour obtenir les informations RAM, ne fonctionne pas sur les VMs  
> 2.2 Problèmes avec les commandes SSH dans l'exécution du script  
> 2.3 Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize, affiche les informations RAM en Ko et non en Go ou Mo  
> 2.4 Le pare-feu bloquait WinRM  
> 2.5 La portée des variables n'atteint pas le scriptBlock de Invoke-Command

_______
## Solutions trouvées : Solutions et alternatives trouvées
_______

1. Bash :
> 2.1 Pas de solution  
> 2.2 Faire attention à la syntaxe du mot de passe

2. PowerShell :
> 2.1 Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize, commande pour obtenir les informations RAM  
> 2.2 Mise en place de WinRM et d'un AD  
> 2.3 Pas de solution trouvée  
> 2.4 Passer en mode RéseauNat avec un préfixe de réseau prédéfinie, connexion en domaine qui ne bloque plus le WinRM (Saint Esprit ?)  
> 2.5 Etablir les variables dans les Invoke-Command
_______
## Améliorations possibles : suggestions d’améliorations futures
_______

- Trouver un moyen de ne pas avoir à taper le mot de passe à chaque action du script  
- Trouver un moyen pour contourner le besoin d'un AD et de ses commandes
- Plutôt que d'avoir toutes les fonctions dans le même script, établir un script qui appelle chaque action par le biais d'autres scripts

