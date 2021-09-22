package org.mindtree.customer.DTO;

import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.validator.constraints.Length;

import javax.persistence.GeneratedValue;
import javax.validation.constraints.NotNull;
@Data
@NoArgsConstructor
public class CustomerDTO {

    int id;

    @NotNull
    @Length(min = 2,max=20,message = "Length has to be in between 2 and 20")
    String name;

    @NotNull
    @Length(min = 2,max=50,message = "Length has to be in between 2 and 50")
    String address;
}
