# Dowcipy XXL FOSS

Nowoczesna aplikacja z potężną bazą żartów, kawałów i dowcipów, stworzona jako darmowa i otwartoźródłowa.

Projekt ten jest inspirowany popularną, lecz niestety niedostępną już w sklepach aplikacją **"Dowcipy XXL"**. Aby zachować dziedzictwo tamtej kultowej aplikacji, ta wersja korzysta z jej oryginalnej bazy danych, dzięki czemu fani mają ponowny dostęp do tysięcy świetnych tekstów.

## Funkcje

- **Ogromna baza danych:** Tysiące dowcipów podzielonych na przejrzyste kategorie (pochodzące bezpośrednio z oryginalnego "Dowcipy XXL").
- **Zapamiętywanie postępu:** Aplikacja automatycznie zapisuje, na którym dowcipie w danej kategorii skończyłeś czytać (widoczny pasek postępu).
- **Ulubione:** Z łatwością dodawaj najlepsze żarty do ulubionych, aby mieć do nich szybki dostęp w dowolnym momencie.
- **Wyszukiwarka:** Szybko znajdź dowcip, którego szukasz, za pomocą zintegrowanej wyszukiwarki.
- **Udostępnianie:** Dziel się najlepszymi kawałami ze znajomymi jednym kliknięciem.
- **Wsparcie dla motywów i Material You:** Wybieraj między klasycznym jasnym i ciemnym motywem, lub pozwól aplikacji dopasować się do kolorów Twojej tapety na urządzeniach z systemem Android 12+.
- **Statystyki:** Sprawdzaj ogólną liczbę przeczytanych dowcipów i zarządzaj swoim postępem.

## Technologie

Aplikacja została napisana we frameworku **Flutter** (Dart) z wykorzystaniem nowoczesnych narzędzi:

- `flutter_riverpod` - bezpieczne zarządzanie stanem aplikacji.
- `sqflite` - szybki dostęp do lokalnej bazy danych z kawałami.
- `go_router` - deklaratywna nawigacja i routing.
- `shared_preferences` - lokalne zapamiętywanie konfiguracji oraz postępu użytkownika.

## Uruchomienie

Aby skompilować aplikację na własnym urządzeniu, musisz posiadać środowisko Flutter.

```bash
flutter clean
flutter pub get
flutter run
```

---

*Nota: Aplikacja ma charakter edukacyjny, a oryginalna struktura bazy danych i treści należą do twórców pierwotnej wersji Dowcipy XXL.*
