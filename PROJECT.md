# IUT - Weather app

Cette application a pour but de vous familiariser avec le framework PHP Laravel au travers de son développement.

Pour vous aider à comprendre le projet, une démo est présente: [weather.dnvn.dev](https://weather.dnvn.dev)

## Cadre

### Initialisation du projet
Afin de conserver un cadre commun à tous les étudiants, le projet sera initié suivant les instructions de ce dépôt Git, incluant l’usage de Docker.

### English only
Le code ainsi que les commentaires doivent être **impérativement** en anglais.

> Ainsi, tout code en français ou [franglais](https://fr.wikipedia.org/wiki/Franglais) mènera à une ==**pénalité** de **2 points** sur la **note finale**==.

### Base de données
Le projet nécessite une base de données. Afin de simplifier sa gestion, SQLite sera utilisé.

La gestion de cette dernière (création des tables, ...) doit se faire exclusivement avec les [migrations](https://laravel.com/docs/13.x/migrations) de Laravel.

La partie communication quand à elle doit **impérativement** se faire avec l’[ORM](https://fr.wikipedia.org/wiki/Mapping_objet-relationnel) de Laravel (modèles, requêtes, ...) [Eloquent](https://laravel.com/docs/13.x/eloquent).

Enfin, un diagramme *minimal* de la base de données est disponible [ici](https://dbdiagram.io/d/Copy-of-IUT-Weather-6aa9b39baf7c3b0bd1e83315).

==Ce diagramme doit être respecté sous peine de **pénalité de 2 points** sur la **note finale**==

### Front
Étant un cours de développement back orienté PHP, le **design** et le **JavaScript** seront **ignorés** pour la note finale.

Une application peut être rendue avec un fond blanc, des liens bleus et du texte en noir tant que les fonctionnalités sont présentes.

### Données météo
Les données météo proviendront des APIs gratuites d’[OpenWeather](https://openweathermap.org).

Pour cela, il sera nécessaire de créer un compte.

> L'activation du token prends environ 20 minutes

## Fonctionnalités
L’application doit intégrer les fonctionnalités suivantes
- Authentification
- Récupération de la météo courante pour une ville
- Récupération des prévisions météo pour une ville
- Récupération des coordonnées d’une ville
- Écran d’affichage de la météo courante / prévision d’une ville
- Gestion des villes de l’utilisateur
	- Ajout d’une ville
	- Retrait d’une ville
	- Ville favorite
	- Activation / désactivation de l'envoi des prévisions
	- Téléchargement d'un fichier `.xslx` contenant les prévisions d'une ville
	- Affichage des villes utilisateur
- Commandes
	- Envoi des prévisions par mail
	- Affichage de la météo courante d’une ville
- API
	- Création d'un token d'accés
	- Fonctions
		- Récupération de la météo courante pour une ville
		- Récupération des prévisions météo pour une ville
		- Récupération des villes de l’utilisateur
		- Ajout / retrait d’une ville à l’utilisateur
		- Activation / désactivation envoi des prévisions par mail
		- Sélection de la ville favorite
		- Retrait d’une ville
- Mise en cache des données reçues de l'API OpenWeather

### Authentification
Chaque utilisateur de l’application doit pouvoir se connecter avec une adresse mail et un mot de passe.

Cette partie doit être gérée par le package [laravel/breeze](https://laravel.com/docs/13.x/starter-kits) et l'option `Blade with Alpine` doit être choisie durant le processus d'installation.

### Récupération de la météo courante pour une ville
Les données météo doivent provenir de l’API [/data/2.5/weather](https://openweathermap.org/current) d’[OpenWeather](https://openweathermap.org) et récupérés par l’usage du [client HTTP](https://laravel.com/docs/13.x/http-client) de Laravel.

### Récupération des prévisions météo pour une ville 
Les prévisions météo doivent provenir de l’API [/data/2.5/forecast](https://openweathermap.org/forecast5) d’[OpenWeather](https://openweathermap.org) et récupérés par l’usage du client [HTTP de Laravel](https://laravel.com/docs/13.x/http-client).

### Récupération des coordonnées d’une ville
Les prévisions météo doivent provenir de l’API [/geo/1.0/direct](https://openweathermap.org/api/geocoding-api) d’[OpenWeather](https://openweathermap.org) et récupérés par l’usage du client [HTTP de Laravel](https://laravel.com/docs/13.x/http-client).

### Écran d’affichage de la météo courante / prévision d’une ville
Cet écran est libre en terme d’interface mais **doit** être réalisé avec le moteur de template de Laravel, [Blade](https://laravel.com/docs/13.x/blade#main-content).

Les données affichées doivent provenir des APIs d’OpenWeather et mettre à disposition un formulaire pour la selection d’une ville.

> Pour simplifier l’intégration de ce champs, nous partons du principe que les utilisateurs vont saisir des noms de ville complets.

Enfin, l’utilisateur doit pouvoir exporter les prévisions au format `.csv` avec un téléchargement immédiat.

> L'export CSV doit se faire via le package Composer [maatwebsite/excel](https://laravel-excel.com)

### Gestion des villes de l’utilisateur
#### Ajout d’une ville
L’application doit fournir aux utilisateur un moyen d’enregistrer une ville afin de la retrouver ultérieurement.

#### Retrait d’une ville
Les utilisateurs doivent pouvoir retirer une ville de leur liste.

#### Ville favorite
Un utilisateur doit pouvoir marquer une, **et seulement une**, ville comme étant sa favorite.

#### Envoi des prévisions
Un utilisateur doit pouvoir marquer une ou plusieurs villes pour lesquelles il souhaite recevoir les prévisions par mail

#### Écran d’affichage des villes utilisateur
Affichage de la liste de l’ensemble des villes de l’utilisateur avec les actions de retrait et selection de favoris.

Cet écran est libre en terme d’interface mais doit être réalisé avec le moteur de template de Laravel, [Blade](https://laravel.com/docs/13.x/blade#main-content).

### Commandes
#### Envoi des prévisions par mail
Une [commande](https://laravel.com/docs/13.x/artisan#writing-commands) doit permettre d’envoyer une [notification](https://laravel.com/docs/13.x/notifications#main-content) de type mail contenant les prévisions des villes liées et sélectionnées pour chaque utilisateur.

Les prévisions devront être envoyées sous forme de fichier `.csv` avec à minima la date et la température prévu par jour.

Enfin, cette commande devra être placé dans le [scheduler](https://laravel.com/docs/13.x/scheduling#running-the-scheduler) de Laravel pour envoi chaque **jours à 06:00**.

*Seule la mise en place de ce comportement est nécessaire.*

> L'export CSV doit se faire via le package Composer [maatwebsite/excel](https://laravel-excel.com)

#### Affichage de la météo courante d’une ville
Une [commande](https://laravel.com/docs/13.x/artisan#writing-commands) doit permettre d’afficher **dans le terminal** la météo actuelle d’une ville arbitraire définie par un [argument](https://laravel.com/docs/13.x/artisan#arguments).

### API
L’application doit mettre à disposition une API permettant de consommer ses données par un client externe (ex: application mobile).

Les APIs retournant des données doivent exploiter une ou plusieurs [API Resource](https://laravel.com/docs/13.x/eloquent-resources#main-content).

> Une collection & un environnement Postman sont présent sur le [drive](https://kdrive.infomaniak.com/app/share/1754493/05230db3-5bc7-4e54-8bdf-2f7f19e58e8d). **L'API rendue doit être utilisable avec cette collection sous peine de pénalités sur la note finale**

> La collection embarque des placeholders pour les segments `{place}`. Il vous incombe de les modifier en accord avec la base de données

#### Création d'un token
Les routes API doivent être sécurisées avec [laravel/sanctum](https://laravel.com/docs/13.x/sanctum) et l’accès doit se faire un [token](https://laravel.com/docs/13.x/sanctum#mobile-application-authentication).

Pour que les utilisateurs puissent utiliser l'API via un client HTTP (Postman, Insomnia, ...) ces derniers doivent pouvoir générer un token depuis l'interface utilisateur.

Le token ne doit apparaitre qu'une seule et unique fois et la création d'un nouveau token entraine la suppression du token précédent.

> Dans l'application de demo, la génération du token est disponible dans le [profil utilisateur](https://weather.dnvn.dev/profile)

#### Routes

##### Récupération de la météo courante pour une ville
Cette API permet de récupérer la météo courante d’une ville.

| Type  | Value  |
|:--|:--|
| method | GET  |
| endpoint | `/api/v1/weather`  |
| query param | place  |

##### Récupération des prévisions météo pour une ville
Cette API permet de récupérer les prévision météo d’une ville.

| Type  | Value  |
|:--|:--|
| method | GET  |
| endpoint | `/api/v1/forecast`  |
| query param | place  |

##### Récupération des villes de l’utilisateur
Cette API permet de récupérer la liste **paginée** des villes de l’utilisateur.

| Type  | Value  |
|:--|:--|
| method | GET  |
| endpoint | `/api/v1/user/places`  |
| query param | -  |

##### Ajout d’une ville à l’utilisateur
Cette API permet d’ajouter une ville à la liste de l’utilisateur.

| Type  | Value  |
|:--|:--|
| method | POST  |
| endpoint | `/api/v1/user/places`  |
| query param | place  |

##### Retrait d’une ville à l’utilisateur
Cette API permet de retirer une ville de la liste de l’utilisateur.

| Type  | Value  |
|:--|:--|
| method | DELETE  |
| endpoint | `/api/v1/user/places/{place}`  |
| query param | -  |

##### Activation / désactivation envoi des prévisions par mail
Cette API permet d’activer ou désactiver l’envoi par mail des prévisions météo pour une ville données.

| Type  | Value  |
|:--|:--|
| method | PATCH  |
| endpoint | `/api/v1/user/places/{place}/daily-report`  |
| query param | -  |

##### Sélection / désaffection de la ville favorite
Cette API permet de marquer ou retirer le marquage d’une ville comme étant favorite de l’utilisateur.

La ville doit cependant rester présente dans sa liste de l'utilisateur lorsque la mention de favorite lui est retirée.

| Type  | Value  |
|:--|:--|
| method | PATCH  |
| endpoint | `/api/v1/user/places/{place}/favorite`  |
| query param | -  |

##### Récupération de la météo courante de la ville favorite de l'utilisateur

| Type  | Value  |
|:--|:--|
| method | GET  |
| endpoint | `/api/v1/user/places/favorite/weather`  |
| query param | place  |

##### Récupération des prévisions météo de la ville favorite de l'utilisateur

| Type  | Value  |
|:--|:--|
| method | GET  |
| endpoint | `/api/v1/user/places/favorite/forecast`  |
| query param | place  |
