package org.mindtree.customer.controller.advicecontroller;

import lombok.extern.slf4j.Slf4j;
import org.mindtree.customer.exception.Handler;
import org.mindtree.customer.exception.ResourceNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
@Slf4j
public class ExceptionAdvice {
	
	@ExceptionHandler(value = ResourceNotFoundException.class)
	@ResponseStatus(code = HttpStatus.NOT_FOUND)
	public Handler handleResourceNotFound(ResourceNotFoundException exception, HttpServletRequest req) {
		return new Handler(req.getRequestURI(), exception.getMessage(), exception.getClass().getName());
	}

}
