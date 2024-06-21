using Microsoft.EntityFrameworkCore;

public class DataBaseContext : DbContext
{
    public DbSet<Product> Products { get; set; }
    public DbSet<Supplier> Suppliers { get; set; }
    public DbSet<Invoice> Invoices { get; set;}
    public DbSet<Customer> Customers { get; set;}
    public DbSet<Company> Companies { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        base.OnConfiguring(optionsBuilder);
        optionsBuilder.UseSqlite("Datasource=MyProductDatabase");
    
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // Konfiguracja one to many
        modelBuilder.Entity<Supplier>()
            .HasMany(s => s.Products)
            .WithOne(p => p.Supplier)
            .HasForeignKey(p => p.SupplierID);

        // modelBuilder.Entity<Company>()
        //     .HasDiscriminator<string>("CompanyType")
        //     .HasValue<Supplier>("Supplier")
        //     .HasValue<Customer>("Customer");

        modelBuilder.Entity<Company>()
            .ToTable("Companies");

        modelBuilder.Entity<Customer>()
            .ToTable("Customers");

        modelBuilder.Entity<Supplier>()
            .ToTable("Suppliers");

        modelBuilder.Entity<Supplier>().Property(s => s.bankAccountNumber);
        modelBuilder.Entity<Customer>().Property(c => c.discount);
    }
}