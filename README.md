# eveiloo_enfant


# La structure du projet 
eveiloo/
│
├── android/
├── ios/
├── assets/
│
├── lib/
│   ├── core/
│   ├── features/
│   ├── models/
│   ├── widgets/
│   ├── routes/
│   ├── theme/
│   └── main.dart
│
├── test/
│
├── pubspec.yaml
└── README.md

# La structure detaillé

EVEILOO/
│
├── android/
├── ios/
├── web/
├── build/
│
├── lib/
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── firebase_collections.dart
│   │   │   └── app_assets.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── formatters.dart
│   │   │   └── helpers.dart
│   │   │
│   │   └── services/
│   │       ├── firebase_service.dart
│   │       ├── storage_service.dart
│   │       └── notification_service.dart
│   │
│   ├── features/
│   │   │
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   ├── forgot_password_page.dart
│   │   │   └── auth_service.dart
│   │   │
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   │
│   │   ├── children/
│   │   │   ├── children_page.dart
│   │   │   ├── child_detail_page.dart
│   │   │   ├── add_child_page.dart
│   │   │   └── child_service.dart
│   │   │
│   │   ├── activities/
│   │   │   ├── activities_page.dart
│   │   │   ├── activity_detail_page.dart
│   │   │   ├── activityplay_page.dart
│   │   │   └── activity_service.dart
│   │   │
│   │   ├── progressions/
│   │   │   ├── progression_page.dart
│   │   │   └── progression_service.dart
│   │   │
│   │   ├── toys/
│   │   │   ├── toys_page.dart
│   │   │   ├── toy_detail_page.dart
│   │   │   └── toy_service.dart
│   │   │
│   │   ├── tutorials/
│   │   │   ├── tutorials_page.dart
│   │   │   ├── tutorial_detail_page.dart
│   │   │   └── tutorial_service.dart
│   │   │
│   │   ├── articles/
│   │   │   ├── articles_page.dart
│   │   │   ├── article_detail_page.dart
│   │   │   └── article_service.dart
│   │   │
│   │   ├── favorites/
│   │   │   └── favorites_page.dart
│   │   │
│   │   ├── cart/
│   │   │   ├── cart_page.dart
│   │   │   └── cart_service.dart
│   │   │
│   │   ├── orders/
│   │   │   ├── orders_page.dart
│   │   │   ├── order_detail_page.dart
│   │   │   └── order_service.dart
│   │   │
│   │   ├── notifications/
│   │   │   └── notifications_page.dart
│   │   │
│   │   └── profile/
│   │       ├── profile_page.dart
│   │       └── settings_page.dart
│   │
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   ├── app_card.dart
│   │   ├── toy_card.dart
│   │   ├── child_card.dart
│   │   ├── activity_card.dart
│   │   ├── loading_widget.dart
│   │   └── error_widget.dart
│   │
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── child_model.dart
│   │   ├── toy_model.dart
│   │   ├── category_model.dart
│   │   ├── activity_model.dart
│   │   ├── progression_model.dart
│   │   ├── tutorial_model.dart
│   │   ├── article_model.dart
│   │   ├── favorite_model.dart
│   │   ├── cart_model.dart
│   │   ├── order_model.dart
│   │   └── notification_model.dart
│   │
│   ├── routes/
│   │   └── app_routes.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   │
│   └── main.dart
│
├── assets/
│   ├── images/
│   │   ├── toys/
│   │   ├── activities/
│   │   ├── tutorials/
│   │   └── articles/
│   │
│   ├── icons/
│   ├── logos/
│   ├── animations/
│   └── fonts/
│
├── test/
│
├── pubspec.yaml
├── README.md
└── .gitignore

## !Les tâches 
AUTHENTIFICATION
│
├── Inscription parent
├── Connexion
├── Mot de passe oublié
├── Déconnexion
└── Gestion de session

UTILISATEURS
│
├── Profil parent
├── Modification profil
├── Avatar
└── Paramètres

ENFANTS
│
├── Ajouter un enfant
├── Liste des enfants
├── Détail profil enfant
├── Modifier profil enfant
└── Suppression éventuelle



Équipe B — Catalogue & Contenu

Membres :

Salif
Cheick
Sylla

Cette équipe a beaucoup de collections :

CATEGORIES
JOUETS
TUTORIELS
ACTIVITES
QUESTIONS

Je recommande cette division :

Membre	Responsabilité
Salif	Catégories + Jouets
Cheick	Tutoriels
Sylla	Activités + Questions


Équipe C — Achat & Engagement

Membres :

Sissoko
Mahamadou
Soukouna
Kanouté

Je conseille :

Membre	Responsabilité
Sissoko	Panier
Mahamadou	Commandes + paiement simulé
Soukouna	Favoris + Avis
Kanouté	Notifications + Journal de progression

Zakaria Nouhou
15:59
Répartition en sous-équipes — tout le monde code, y compris le lead
*Équipe A — Comptes & Utilisateurs (3 personnes, dont le lead)**
`UTILISATEURS`, `ENFANTS`, authentification Firebase Auth, gestion de profil, avatars.
Les noms: Zakaria, Moulaye et Chitan Founé
**Équipe B — Catalogue & Contenu (3 personnes)**
`CATEGORIES`, `JOUETS`, `TUTORIELS`, `ACTIVITES`, `QUESTIONS`. Écrans de découverte/liste/détail, recherche, filtres.
Les noms: Salif, Cheick  et Sylla

*Équipe C — Achat & Engagement (4 personnes)**
`PANIER_ARTICLES`, `COMMANDES`, `FAVORIS`, `AVIS`, `NOTIFICATIONS`, `JOURNAL_PROGRES` — c'est le lot le plus gros, donc une personne de plus.
Les noms Sissoko, Mahamadou, Soukouna et Kanouté


## 3. Hiérarchie des dépendances — dans quel ordre développer
**Niveau 0 — Fondations (rien ne marche sans ça)**
`UTILISATEURS` et `ENFANTS` (équipe A) : quasiment toutes les autres collections référencent `utilisateurId` ou `enfantId`.
 C'est pour ça que l'équipe A (avec le lead dedans) doit livrer une version basique de l'auth et du profil enfant en tout premier, même sans finitions.
**Niveau 1 — Contenu de base (dépend seulement du niveau 0, ou de rien)**
`CATEGORIES`, `JOUETS`, `TUTORIELS`, `ACTIVITES` (équipe B) : ne dépendent pas des utilisateurs pour être *affichés*, donc peuvent démarrer en parallèle du niveau 0. `
QUESTIONS` dépend de `ACTIVITES` (via `activiteId`), donc à faire juste après.

*Niveau 2 — Interactions utilisateur (dépendent des niveaux 0 et 1)**
`PANIER_ARTICLES`, `FAVORIS`, `AVIS` (équipe C) : ont besoin d'un utilisateur/enfant connecté (niveau 0) ET d'un jouet/élément à référencer (niveau 1) pour avoir un sens.
 Impossible de les tester sérieusement avant que ces deux niveaux existent au moins en version simple.

**Niveau 3 — Conséquences (dépendent du niveau 2)**
`COMMANDES` dépend de `PANIER_ARTICLES` (on commande ce qu'il y a dans le panier). 
`NOTIFICATIONS` dépend de `COMMANDES` (accusé de réception, etc.) et d'autres événements. 
`JOURNAL_PROGRES` dépend de `ENFANTS` + `ACTIVITES`/`TUTORIELS` (on ne peut enregistrer une progression que sur une activité qui existe, pour un enfant qui existe).