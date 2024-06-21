public class Product
{
    public int ProductID { get; set;}
    public String? ProductName { get; set;}
    public int UnitsOnStock { get; set;}
    public int SupplierID { get; set;}

    public Supplier Supplier { get; set; } = null!;
    public ICollection<Invoice> Invoices { get; set; } = new List<Invoice>();
}