# TP Terraform - Azure Infrastructure as Code

## Objectif du TP

L'objectif de ce TP est d'apprendre à déployer une infrastructure Azure avec Terraform plutôt qu'avec Azure CLI.

Avec Azure CLI, on indique **comment créer** les ressources.

Avec Terraform, on décrit **les ressources que l'on souhaite obtenir** et Terraform se charge du déploiement.

---

# Exercice 1.1 - Comprendre le provider Azure

## 1. Quelle version du provider Azure est utilisée ?

Le provider utilisé est **HashiCorp AzureRM**.

La version utilisée est :

```hcl
version = "~> 4.0"
```

Le symbole **~>** signifie :

- Terraform accepte toutes les mises à jour mineures de la version 4.
- Terraform refuse automatiquement une version majeure (5.0).

Exemples :

✅ 4.10

✅ 4.80

❌ 5.0

Pourquoi ?

Pour éviter qu'une nouvelle version casse le projet.

---

## 2. Que signifie use_oidc = true ?

Terraform utilise **OIDC (OpenID Connect)** pour s'authentifier auprès d'Azure.

Il n'utilise donc pas de mot de passe.

À la place, Azure reçoit un jeton temporaire fourni par GitHub Actions ou GitLab CI.

Avantages :

- aucune information sensible dans le dépôt Git ;
- authentification plus sécurisée ;
- jeton temporaire.

C'est exactement le même principe que les **Federated Identity Credentials** utilisées dans notre projet GitLab.

---

## 3. À quoi sert le bloc features {} ?

Le bloc

```hcl
features {}
```

est obligatoire pour le provider Azure.

Même vide, Terraform en a besoin pour fonctionner.

Il permet également d'activer certaines fonctionnalités avancées du provider Azure.

---

## Ce que j'ai appris

✔ Un provider est un plugin qui permet à Terraform de communiquer avec Azure.

✔ Terraform ne sait pas parler directement à Azure.

✔ Le provider AzureRM traduit les instructions Terraform en commandes compréhensibles par Azure.

✔ La commande `terraform init` télécharge automatiquement ce provider.

---

## Vocabulaire

| Mot | Définition |
|------|------------|
| Provider | Plugin permettant à Terraform de communiquer avec un cloud. |
| AzureRM | Provider officiel permettant de gérer Azure. |
| OIDC | Authentification sécurisée sans mot de passe. |
| HCL | Langage utilisé par Terraform. |

4. 3 : Que contient terraform.tfstate ?

Le fichier terraform.tfstate contient l'état complet de l'infrastructure gérée par Terraform.

On y retrouve notamment :

les ressources créées (Storage Account, App Service, Function App, Container, VNet, NSG, etc.) ;
leurs identifiants Azure (id) ;
leurs propriétés (nom, emplacement, tags, configuration...) ;
les outputs (app_service_url, function_app_url, etc.) ;
les dépendances entre les ressources.

Que se passe-t-il si on le supprime ?

Si on supprime terraform.tfstate, Terraform perd la mémoire de ce qu'il a déjà créé.

Les ressources existent toujours dans Azure, mais Terraform ne les connaît plus. Au prochain terraform plan, il considérera qu'il n'y a plus d'infrastructure gérée et cherchera à recréer les ressources, ce qui peut provoquer des erreurs ou des conflits de noms.

4. 3 Pourquoi ne faut-il jamais le committer ?

Parce qu'il contient des informations sensibles.

Dans notre fichier, on voit par exemple :

des clés d'accès aux Storage Accounts (primary_access_key) ;
des connection strings ;
des mots de passe des App Services (site_credential.password) ;
d'autres informations d'authentification.

C'est précisément pour cette raison qu'en équipe, on utilise un Remote State stocké dans Azure Blob Storage plutôt que de versionner ce fichier dans Git.

4.4 : Terraform ne peut pas modifier l’image de ce Container Group directement. Il doit :

supprimer l’ancien conteneur ;
recréer un nouveau conteneur avec nginx:1.25.
Ce n’est pas une mise à jour en place ~. C’est une recréation -/+.