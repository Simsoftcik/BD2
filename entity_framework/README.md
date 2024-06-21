# Entity framework - raport

W zespole:

- Bartłomiej Szubiak,
- Szymon Kubiczek,
- Konrad Armatys

## Część I

![](./images/czesc-1.jpg)

## Część II

### Podpunkt a

![](./images/czesc-2-ppkt-a.png)

### Podpunkt b

Program pokazujący działanie relacji klasy Supplier z klasą Product.

![](./images/czesc-2-ppkt-b-zdj-2.png)

Wynik tego programu.

![](./images/czesc-2-ppkt-b-zdj-3.png)

#### Wyżej wymienione klasy

![](./images/czesc-2-ppkt-b-zdj-4.png)

![](./images/czesc-2-ppkt-b-zdj-5.png)

### Podpunkt c

![](./images/czesc-2-ppkt-c-zdj-3.png)

![](./images/czesc-2-ppkt-c-zdj-4.png)

### Podpunkt d

Wyświetlanie produktów należących do poszczególnej faktury.

Dzieje się to za pośrednictwem tabeli pośredniej którą Entity Framework tworzy samo.

![](./images/czesc-2-ppkt-d-zdj-2.png)

Wyświetlenie faktur do których należy dany produkt.

![](./images/czesc-2-ppkt-d-zdj-3.png)

### Podpunkt e

![](./images/czesc-2-ppkt-e.png)

### Podpunkt f

#### Tabela po której dziedziczymy

![](./images/czesc-2-ppkt-f-zdj-1.png)

#### Tabele dziedziczące

![](./images/czesc-2-ppkt-f-zdj-2.png)

![](./images/czesc-2-ppkt-f-zdj-3.png)

### Podpunkt g

W podpunkcie e została użyta strategia Table=Per-Hierarchy (TPH)
, natomiast w podpunkcie f strategia Table-Per-Type (TPT).

Różnice między strategiami:
- Liczba tabel:
  - TPH: Wymaga jednej tabeli dla całej hierarchii klas.
  - TPT: Wymaga osobnej tabeli dla każdej klasy w hierarchii.
- Złożoność relacji:
  - TPH: Mniej relacji między tabelami, co upraszcza zapytania.
  - TPT: Więcej relacji między tabelami, co może skomplikować zapytania.
- Kolumny z wartościami null:
  - TPH: Posiada wiele kolumn z wartościami null, co prowadzi do marnowania przestrzeni.
  - TPT: Nie ma problemu z wartościami null, ponieważ każda tabela przechowuje tylko dane specyficzne dla swojej klasy.
- Tworzenie nowych tabel:
  - TPH: Rozbudowa hierarchii wymaga modyfikacji wszystkich danych w hierarchii.
  - TPT: Tworzenie nowej tabeli nie wpływa na dane w istniejących tabelach.
- Skalowalność:
  - TPH: Przy dużej liczbie dziedziczących tabel schemat może stać się bardzo skomplikowany.
  - TPT: Każda nowa klasa dodaje nową tabelę, co ułatwia rozbudowę i zarządzanie schematem.
