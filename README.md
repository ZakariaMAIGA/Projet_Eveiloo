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
│   │   │   ├── activity_play_page.dart
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