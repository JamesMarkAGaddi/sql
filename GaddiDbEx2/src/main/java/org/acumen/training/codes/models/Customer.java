package org.acumen.training.codes.models;

public class Customer {
	private Integer id;
	private String name;
	private String city;
	private Integer grade;
	private Integer salesmanId;

	public Customer(Integer id, String name, String city, Integer grade, Integer salesmanId) {
		this.id = id;
		this.name = name;
		this.city = city;
		this.grade = grade;
		this.salesmanId = salesmanId;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public Integer getGrade() {
		return grade;
	}

	public void setGrade(Integer grade) {
		this.grade = grade;
	}

	public Integer getSalesmanId() {
		return salesmanId;
	}

	public void setSalesmanId(Integer salesmanId) {
		this.salesmanId = salesmanId;
	}
}
