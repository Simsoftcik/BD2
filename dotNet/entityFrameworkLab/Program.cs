using System;
using System.Linq;

DataBaseContext prodContext = new DataBaseContext();

Supplier supplier1 = new Supplier { CompanyName = "supplierCompany1", Street = "Street1", City = "City1", ZipCode="12-345", bankAccountNumber="bankAccountNumber1"};
Supplier supplier2 = new Supplier { CompanyName = "supplierCompany2", Street = "Street2", City = "City1", ZipCode="12-345", bankAccountNumber="bankAccountNumber2"};
Customer customer1 = new Customer { CompanyName = "customerCompany3", Street = "Street3", City = "City1", ZipCode="12-345", discount=5.0};
Customer customer2 = new Customer { CompanyName = "customerCompany4", Street = "Street3", City = "City1", ZipCode="12-345", discount=5.0};

Product product1 = new Product { ProductName = "flamaster turkusowy", Supplier = supplier1};
Product product2 = new Product { ProductName = "flamaster akwamarynowy", Supplier = supplier1};
Product product3 = new Product { ProductName = "flamaster chabrowy", Supplier = supplier1};
Product product4 = new Product { ProductName = "flamaster seledynowy", Supplier = supplier1};
Invoice invoice1 = new Invoice { Inv oiceNumber = 1};
Invoice invoice2 = new Invoice { InvoiceNumber = 2};

invoice1.Products.Add(product1);
invoice1.Products.Add(product2);
invoice2.Products.Add(product3);
invoice2.Products.Add(product4);

product1.Invoices.Add(invoice1);
product2.Invoices.Add(invoice1);
product3.Invoices.Add(invoice2);
product4.Invoices.Add(invoice2);

prodContext.Suppliers.AddRange(supplier1, supplier2);
prodContext.Customers.AddRange(customer1, customer2);
prodContext.Products.AddRange(product1, product2, product3, product4);
prodContext.Invoices.AddRange(invoice1, invoice2);
prodContext.SaveChanges();
