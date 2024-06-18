package com.example.jpa_lab.schemas;

import jakarta.persistence.*;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int productId;
    private String productName;
    private int unitsInStock;


    @ManyToOne(fetch = FetchType.LAZY)
    private Supplier supplier;

    @ManyToOne(fetch = FetchType.LAZY)
    private Category category;
    public Product(){

    }

    public Product(String productName, int unitsInStock, Supplier supplier, Category category) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
        this.supplier = supplier;
        this.category = category;
    }

}
