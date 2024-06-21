# Hibernate - raport

W zespole:
- Bartłomiej Szubiak,
- Szymon Kubiczek,
- Konrad Armatys

## Część I

![](./images/1.png)

## Część II

### Podpunkt I

#### Klasy Product i Supplier

![](./images/2.png)
#### Kod dodający dane oraz mapping klas

![](./images/3.png)

#### Zawartość tabeli Product
![](./images/4.png)

#### Zawartość tabeli Supplier
![](./images/5.png)

### Podpunkt II (wersja z tabelą łącznikową)

#### Klasy Product i Supplier
![](./images/6.png)

#### Kod dodający dane
![](./images/7.png)

#### Zawartość tabeli Product
![](./images/8.png)

#### Zawartość tabeli Supplier
![](./images/9.png)

#### Zawartość tabeli łącznikowej Supplier_Product
![](./images/10.png)

### Podpunkt II (wersja bez tabeli łącznikowej)

(kod dodający dane pozostał ten sam)

#### Klasy Supplier i Product
![](./images/11.png)

#### Przykładowe zapytanie pokazujące produkty dla dostawcy z id=1
![](./images/12.png)

### Podpunkt III

#### Klasy Supplier i Product
![](./images/13.png)

#### Kod dodający dane
![](./images/14.png)

#### Logi z hibernate pokazujące obecność obustronnej relacji one to many
![](./images/15.png)