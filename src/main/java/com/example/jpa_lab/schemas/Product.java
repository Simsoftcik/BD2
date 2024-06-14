package com.example.jpa_lab.schemas;

import jakarta.persistence.*;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int productId;
    private String productName;
    private int unitsInStock;

    @ManyToOne
    private Supplier supplier;

    public Product(){

    }

    public Product(String productName, int unitsInStock, Supplier supplier) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }
}
