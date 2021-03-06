package org.mindtree.customer.entity;

import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Entity(name = "customers")
@Data
@NoArgsConstructor
public class Customer {

    @Id
    @GeneratedValue
    int id;

    String name;

    String address;

    public Customer(String name, String address) {
        this.name = name;
        this.address = address;
    }
}
