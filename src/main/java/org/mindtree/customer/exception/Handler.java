package org.mindtree.customer.exception;

import java.time.LocalDate;

public class Handler {
	private String url;
	private String message;
	private LocalDate raisedTime;
	private String exceptionName;

	public Handler(String url, String message, String en) {
		super();
		this.url = url;
		this.message = message;
		this.raisedTime=LocalDate.now();
		this.exceptionName = en;
	}

	public Handler() {
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public LocalDate getRaisedTime() {
		return raisedTime;
	}

	public void setRaisedTime(LocalDate raisedTime) {
		this.raisedTime = raisedTime;
	}

	public String getExceptionName() {
		return exceptionName;
	}

	public void setExceptionName(String exceptionName) {
		exceptionName = exceptionName;
	}
}
