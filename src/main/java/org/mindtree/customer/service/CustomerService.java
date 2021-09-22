package org.mindtree.customer.service;

import org.mindtree.customer.entity.Customer;
import org.mindtree.customer.exception.ResourceNotFoundException;
import java.util.List;


public interface CustomerService {
	
	Customer getCustomerById(int id) throws ResourceNotFoundException;

	Customer addCustomer(Customer customer);

	List<Customer> getAllCustomers();

}
