package org.acumen.training.codes.models;

public class Salesman {
	private Integer id;
	private String name;
	private String city;
	private Double commission;

	public Salesman(Integer id, String name, String city, Double commission) {
		this.id = id;
		this.name = name;
		this.city = city;
		this.commission = commission;
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

	public Double getCommission() {
		return commission;
	}

	public void setCommission(Double commission) {
		this.commission = commission;
	}
}
