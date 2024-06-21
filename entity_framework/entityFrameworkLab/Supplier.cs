public class Supplier : Company
{
    public int SupplierID { get; set; }
    public String? bankAccountNumber {get; set;}
    public ICollection<Product> Products { get; set; } = new List<Product>();
}