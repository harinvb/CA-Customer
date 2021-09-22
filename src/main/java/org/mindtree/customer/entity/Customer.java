package org.mindtree.customer.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;


@Entity(name = "customers")
@Data
@NoArgsConstructor
public class Customer {
	
	@Id
	@GeneratedValue
	int id;

	@NotNull
	@Length(min = 2,max=20,message = "Length has to be in between 2 and 20")
	String name;
	
	@NotNull
	@Length(min = 2,max=50,message = "Length has to be in between 2 and 50")
	String address;
}
