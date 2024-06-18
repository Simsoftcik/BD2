package com.example.jpa_lab.schemas;

import jakarta.persistence.*;

import java.util.List;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int CategoryId;
    private String Name;
    @OneToMany(cascade = CascadeType.ALL, orphanRemoval = true, mappedBy = "category")
    private List<Product> products;


    public Category(){

    }

    public Category(String name) {
        Name = name;
    }
}
