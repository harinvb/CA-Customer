package org.mindtree.customer.DTO;

import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;

public class CustomerDTO {

    private int id;

    @NotNull
    @Length(min = 2,max=20,message = "Length has to be in between 2 and 20")
    private String name;

    @NotNull
    @Length(min = 2,max=50,message = "Length has to be in between 2 and 50")
    private String address;
    

	public CustomerDTO(String name,String address) {
		super();
		this.name = name;
		this.address = address;
	}

	public CustomerDTO() {
		super();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
    
    
    
}
