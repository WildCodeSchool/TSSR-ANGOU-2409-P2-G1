$NomdeProjet=$args[0]

if ( -not $NomdeProjet)
{
Write-Host "Aucun nom fourni, appelation 'Projet' par défaut"
$NomdeProjet="Projet"
}
Else
{
Write-Host "Initialisation du projet $NomdeProjet"
}
New-Item -Name $NomdeProjet -ItemType Directory -Path C:\Users\basti\Projets\
Write-Host "Création du dossier C:\Users\basti\Projets\$NomdeProjet"
New-Item -Name Source -ItemType Directory -Path C:\Users\basti\Projets\$NomdeProjet\
New-Item -Name Test -ItemType Directory -Path C:\Users\basti\Projets\$NomdeProjet\
New-Item -Name README.txt -ItemType File -Path C:\Users\basti\Projets\$NomdeProjet\
Set-Content -Path C:\Users\basti\Projets\$NomdeProjet\README.txt -Value "# $NomdeProjet's readme"
Write-Host "Création des dossiers : 
- C:\Users\basti\Projets\$NomdeProjet\Source
- C:\Users\basti\Projets\$NomdeProjet\Test
- C:\Users\basti\Projets\$NomdeProjet\README.txt
"
Write-Host "Finalisation du projet $NomdeProjet"
