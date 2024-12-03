package org.acumen.training.codes.model;

import java.time.LocalDate;

public class Project {

	private Integer projid;
	private String projname;
	private LocalDate projdate;

	public Integer getProjid() {
		return projid;
	}

	public void setProjid(Integer projid) {
		this.projid = projid;
	}

	public String getProjname() {
		return projname;
	}

	public void setProjname(String projname) {
		this.projname = projname;
	}

	public LocalDate getProjdate() {
		return projdate;
	}

	public void setProjdate(LocalDate projdate) {
		this.projdate = projdate;
	}

	@Override
	public String toString() {
		return "%d %s %s".formatted(projid, projname, projdate);
	}
}
