package com.example.jpa_lab;

import com.example.jpa_lab.schemas.Product;
import com.example.jpa_lab.schemas.Supplier;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.HashMap;
import java.util.HashSet;

public class Main {
    private static SessionFactory sessionFactory = null;
    public static void main(String[] args) {
        sessionFactory = getSessionFactory();
        Session session = sessionFactory.openSession();
        Transaction init = session.beginTransaction();
        session.createQuery("DELETE FROM Supplier").executeUpdate();
        session.createQuery("DELETE FROM Product").executeUpdate();
        init.commit();


        Product product1 = new Product("Kredki", 10);
        Product product2 = new Product("pastele", 15);
        Product product3 = new Product("ołówki", 10);
        HashSet<Product> products1 = new HashSet<>();
        HashSet<Product> products2 = new HashSet<>();
        products1.add(product1);
        products1.add(product2);
        products2.add(product3);

        Supplier supplier1 = new Supplier("SuperDostawcy", "Uliczna", "Warszawa", products1);
        Supplier supplier2 = new Supplier("JeszczeLepsiDostawcy", "Nieuliczna", "Warszawa", products2);


        Transaction tx = session.beginTransaction();
        session.save(supplier1);
        session.save(supplier2);
        session.save(product1);
        session.save(product2);
        session.save(product3);
        tx.commit();

        session.close();
    }

    private static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration configuration = new Configuration();
            sessionFactory = configuration.configure().buildSessionFactory();
        }
        return sessionFactory;
    }
}