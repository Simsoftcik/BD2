package com.example.jpa_lab;

import com.example.jpa_lab.schemas.Product;
import com.example.jpa_lab.schemas.Supplier;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class Main {
    private static SessionFactory sessionFactory = null;
    public static void main(String[] args) {
        sessionFactory = getSessionFactory();
        Session session = sessionFactory.openSession();

        Supplier supplier = new Supplier("SuperDostawcy", "Uliczna", "Warszawa");
        Product product = new Product("Kredki", 10, supplier);

        Transaction tx = session.beginTransaction();
        session.save(supplier);
        session.save(product);
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