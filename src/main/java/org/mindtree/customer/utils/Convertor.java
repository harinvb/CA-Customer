package org.mindtree.customer.utils;

import org.mindtree.customer.DTO.CustomerDTO;
import org.mindtree.customer.entity.Customer;
import org.springframework.stereotype.Service;

@Service
public class Convertor {

    public Customer convert(CustomerDTO customerDTO){
        return new Customer(customerDTO.getName(), customerDTO.getAddress());
    }
}
