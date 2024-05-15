# Entity framework - raport

W zespole:

- Bartłomiej Szubiak,
- Szymon Kubiczek,
- Konrad Armatys

## _Część I_

![](./images/czesc-1.jpg)

## _Część II_

Udało Nam się zrobić do punktu a.ii.

![](./images/czesc-2.jpg)

```c#
//dodanie tylko dla ostatniego produktu
var lastProduct = products.Last();
lastProduct.SupplierID = supplierID;

prodContext.SaveChanges();
```
