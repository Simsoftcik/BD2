# Dokumentowe bazy danych – MongoDB

ćwiczenie 2

---

**Imiona i nazwiska autorów:**

1. Bartłomiej Szubiak
2. Szymon Kubiczek
3. Konrad Armatys

---

## Yelp Dataset

- [www.yelp.com](http://www.yelp.com) - serwis społecznościowy – informacje o miejscach/lokalach
- restauracje, kluby, hotele itd. `businesses`,
- użytkownicy odwiedzają te miejsca - "meldują się" `check-in`
- użytkownicy piszą recenzje `reviews` o miejscach/lokalach i wystawiają oceny oceny,
- przykładowy zbiór danych zawiera dane z 5 miast: Phoenix, Las Vegas, Madison, Waterloo i Edinburgh.

# Zadanie 1 - operacje wyszukiwania danych

Dla zbioru Yelp wykonaj następujące zapytania

W niektórych przypadkach może być potrzebne wykorzystanie mechanizmu Aggregation Pipeline

[https://www.mongodb.com/docs/manual/core/aggregation-pipeline/](https://www.mongodb.com/docs/manual/core/aggregation-pipeline/)

1. Zwróć dane wszystkich restauracji (kolekcja `business`, pole `categories` musi zawierać wartość "Restaurants"), które są otwarte w poniedziałki (pole hours) i mają ocenę co najmniej 4 gwiazdki (pole `stars`).  Zapytanie powinno zwracać: nazwę firmy, adres, kategorię, godziny otwarcia i gwiazdki. Posortuj wynik wg nazwy firmy.

2. Ile każda firma otrzymała ocen/wskazówek (kolekcja `tip` ) w 2012. Wynik powinien zawierać nazwę firmy oraz liczbę ocen/wskazówek Wynik posortuj według liczby ocen (`tip`).

3. Recenzje mogą być oceniane przez innych użytkowników jako `cool`, `funny` lub `useful` (kolekcja `review`, pole `votes`, jedna recenzja może mieć kilka głosów w każdej kategorii).  Napisz zapytanie, które zwraca dla każdej z tych kategorii, ile sumarycznie recenzji zostało oznaczonych przez te kategorie (np. recenzja ma kategorię `funny` jeśli co najmniej jedna osoba zagłosowała w ten sposób na daną recenzję)

4. Zwróć dane wszystkich użytkowników (kolekcja `user`), którzy nie mają ani jednego pozytywnego głosu (pole `votes`) z kategorii (`funny` lub `useful`), wynik posortuj alfabetycznie według nazwy użytkownika.

5. Wyznacz, jaką średnia ocenę uzyskała każda firma na podstawie wszystkich recenzji (kolekcja `review`, pole `stars`). Ogranicz do firm, które uzyskały średnią powyżej 3 gwiazdek.

   a) Wynik powinien zawierać id firmy oraz średnią ocenę. Posortuj wynik wg id firmy.

   b) Wynik powinien zawierać nazwę firmy oraz średnią ocenę. Posortuj wynik wg nazwy firmy.

## Zadanie 1 - rozwiązanie

> Wyniki:
>
> przykłady, kod, zrzuty ekranów, komentarz ...

```js
--  ...
```

# Zadanie 2 - modelowanie danych

Zaproponuj strukturę bazy danych dla wybranego/przykładowego zagadnienia/problemu

Należy wybrać jedno zagadnienie/problem (A lub B)

Przykład A

- Wykładowcy, przedmioty, studenci, oceny
  - Wykładowcy prowadzą zajęcia z poszczególnych przedmiotów
  - Studenci uczęszczają na zajęcia
  - Wykładowcy wystawiają oceny studentom
  - Studenci oceniają zajęcia

Przykład B

- Firmy, wycieczki, osoby
  - Firmy organizują wycieczki
  - Osoby rezerwują miejsca/wykupują bilety
  - Osoby oceniają wycieczki

a) Warto zaproponować/rozważyć różne warianty struktury bazy danych i dokumentów w poszczególnych kolekcjach oraz przeprowadzić dyskusję każdego wariantu (wskazać wady i zalety każdego z wariantów)

b) Kolekcje należy wypełnić przykładowymi danymi

c) W kontekście zaprezentowania wad/zalet należy zaprezentować kilka przykładów/zapytań/zadań/operacji oraz dla których dedykowany jest dany wariantów

W sprawozdaniu należy zamieścić przykładowe dokumenty w formacie JSON ( pkt a) i b)), oraz kod zapytań/operacji (pkt c)), wraz z odpowiednim komentarzem opisującym strukturę dokumentów oraz polecenia ilustrujące wykonanie przykładowych operacji na danych

Do sprawozdania należy kompletny zrzut wykonanych/przygotowanych baz danych (taki zrzut można wykonać np. za pomocą poleceń `mongoexport`, `mongdump` …) oraz plik z kodem operacji zapytań (załącznik powinien mieć format zip).

## Zadanie 2 - rozwiązanie przykłady B (firmy, wycieczki, osoby)

### Wariant I: #TYTUL TODO

#### Kolekcja Companies

- `_id`: unikalny identyfikator firmy
- `name`: nazwa firmy
- `adress`: adres firmy **obiekt**
  - `country`: kraj
  - `postalCode`: adres pocztowy
  - `city`: miasto
  - `street`: ulica z adresem
- `trips`: tablica odwołań do wycieczek organizowanych przez tę firmę

#### Kolekcja Trips

- `_id`: unikalny identyfikator wycieczki
- `name`: nazwa wycieczki
- `description`: opis wycieczki
- `date`: data wycieczki
- `place`: miejsce, które odwiedza wycieczka
- `price`: cena wycieczki
- `ratings`: lista ocen wystawionych przez osoby
  - `user_id`: unikalny identyfikator osoby co wystawiła recenzje
  - `rating`: ocena
  - `comment`: komentarz

#### Kolekcja Persons

- `_id`: unikalny identyfikator osoby
- `name`: imię osoby
- `surname`: nazwisko osoby
- `adress`: adres osoby **obiekt**
  - `country`: kraj
  - `postalCode`: adres pocztowy
  - `city`: miasto
  - `street`: ulica z adresem

#### Kolekcja Reservations

- `_id`: unikalny identyfikator rezerwacji
- `person_id`: odwołanie do osoby, która dokonała rezerwacji
- `trip_id`: odwołanie do wycieczki, na którą została dokonana rezerwacja
- `seats_no`: liczba miejsc zarezerwowanych przez osobę
- `date`: data dokonania rezerwacji

### Wariant II: #TYTUL TODO

#### Kolekcja: #TODO

#### Wady zalety #TODO

### Decydując się na I wariant:

> Inicjalizacja:

```js
use travelAgency_db
// Stworzenie kolekcji 'Companies'
db.createCollection("Companies")

// Stworzenie kolekcji 'Trips'
db.createCollection("Trips")

// Stworzenie kolekcji 'Persons'
db.createCollection("Persons")

// Stworzenie kolekcji 'Reservations'
db.createCollection("Reservations")
```

> Wstawienie przykładowych dokumentów do kolekcji 'Companies':

```js
db.Companies.insertMany([
  {
    name: "Adventure Travel Agency",
    address: {
      country: "United States",
      postalCode: "90210",
      city: "Beverly Hills",
      street: "Rodeo Drive",
    },
    trips: [],
  },
  {
    name: "European Excursions Ltd.",
    address: {
      country: "United Kingdom",
      postalCode: "SW1A 1AA",
      city: "London",
      street: "Buckingham Palace Road",
    },
    trips: [],
  },
  {
    name: "Exotic Destinations Inc.",
    address: {
      country: "Australia",
      postalCode: "2000",
      city: "Sydney",
      street: "George Street",
    },
    trips: [],
  },
  {
    name: "Tropical Tours LLC",
    address: {
      country: "Costa Rica",
      postalCode: "10101",
      city: "San José",
      street: "Avenida Central",
    },
    trips: [],
  },
]);
```

> Wstawienie przykładowych dokumentów do kolekcji 'Trips'

```js
db.Trips.insertMany([
  {
    name: "Wakacje nad morzem",
    description: "Relaksująca wycieczka nad Morzem Bałtyckim",
    date: new Date("2024-07-01"),
    place: "Morze Bałtyckie",
    price: 500,
    ratings: [],
  },
  {
    name: "Wycieczka po Europie",
    description: "Niezapomniana podróż po najpiękniejszych miastach Europy",
    date: new Date("2024-09-15"),
    place: "Europa",
    price: 2000,
    ratings: [],
  },
  {
    name: "Wyprawa w góry",
    description: "Ekscytująca wspinaczka w Alpach",
    date: new Date("2024-08-10"),
    place: "Alpy",
    price: 800,
    ratings: [],
  },
  {
    name: "Safari w Afryce",
    description: "Safari po Parku Narodowym Serengeti",
    date: new Date("2024-10-20"),
    place: "Tanzania",
    price: 1500,
    ratings: [],
  },
]);
```

> Wstawienie przykładowych dokumentów do kolekcji 'Persons'

```js
db.Persons.insertMany([
  {
    name: "Jan",
    surname: "Kowalski",
    address: {
      country: "Poland",
      postalCode: "01-001",
      city: "Kraków",
      street: "ul. Floriańska 10",
    },
  },
  {
    name: "Anna",
    surname: "Nowak",
    address: {
      country: "France",
      postalCode: "75001",
      city: "Paris",
      street: "Avenue des Champs-Élysées",
    },
  },
  {
    name: "Mark",
    surname: "Smith",
    address: {
      country: "United States",
      postalCode: "10001",
      city: "New York",
      street: "Broadway",
    },
  },
  {
    name: "Maria",
    surname: "Garcia",
    address: {
      country: "Spain",
      postalCode: "28001",
      city: "Madrid",
      street: "Calle de Alcalá 1",
    },
  },
]);
```

> Dodanie 'referencji' do wycieczek w kolekcji 'Companies'

```js
db.Companies.updateOne(
  { name: "Adventure Travel Agency" },
  { $push: { trips: db.Trips.findOne({ name: "Wakacje nad morzem" })._id } }
);

db.Companies.updateOne(
  { name: "European Excursions Ltd." },
  { $push: { trips: db.Trips.findOne({ name: "Wycieczka po Europie" })._id } }
);

db.Companies.updateOne(
  { name: "Exotic Destinations Inc." },
  { $push: { trips: db.Trips.findOne({ name: "Wyprawa w góry" })._id } }
);

db.Companies.updateOne(
  { name: "Tropical Tours LLC" },
  { $push: { trips: db.Trips.findOne({ name: "Safari w Afryce" })._id } }
);
```

> Dodanie przykładowych rezerwacji do kolekcji 'Reservations':

```js
db.Reservations.insertMany([
  {
    person_id: db.Persons.findOne({ name: "Anna", surname: "Nowak" })._id,
    trip_id: db.Trips.findOne({ name: "Wyprawa w góry" })._id,
    seats_no: 1,
    date: new Date("2023-08-15"),
  },
  {
    person_id: db.Persons.findOne({ name: "Mark", surname: "Smith" })._id,
    trip_id: db.Trips.findOne({ name: "Safari w Afryce" })._id,
    seats_no: 3,
    date: new Date("2023-09-20"),
  },
  {
    person_id: db.Persons.findOne({ name: "Maria", surname: "Garcia" })._id,
    trip_id: db.Trips.findOne({ name: "Wakacje nad morzem" })._id,
    seats_no: 4,
    date: new Date("2023-10-25"),
  },
]);
```

### Zabawa z mongoDB TODO

> 1. Są to skrypty js tak więc można korzystać z jego funkcjonalności:

```js
// dodawanie rezerwacji i otrzymanie wstawionego dokumentu i wyciagiecie identyfikatora
const insertedDocument = db.Reservations.insertOne({
  person_id: db.Persons.findOne({ name: "Jan", surname: "Kowalski" })._id,
  trip_id: db.Trips.findOne({ name: "Wyprawa w góry" })._id,
  seats_no: 2,
  date: new Date("2023-07-05"),
});
const lastInsertedId = insertedDocument.insertedId;
print("Ostatnio wstawiony identyfikator: " + lastInsertedId);
```

> 2. Baza danych jest elastyczna więc: #TODO

```js
// Niech jedna wycieczka bedzie realizowana przez dwie firmy
db.Companies.updateOne(
  { name: "Adventure Travel Agency" },
  { $push: { trips: db.Trips.findOne({ name: "Wycieczka po Europie" })._id } }
);
```

---

Punktacja:

|         |     |
| ------- | --- |
| zadanie | pkt |
| 1       | 0,6 |
| 2       | 1,4 |
| razem   | 2   |
