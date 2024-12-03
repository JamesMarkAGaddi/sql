package org.acumen.training.codes.test;

import java.sql.Connection;
import java.time.LocalDate;
import java.util.List;

import org.acumen.training.codes.MyConfiguration;
import org.acumen.training.codes.dao.ProjectDao2;
import org.acumen.training.codes.model.Project;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

public class TestProjectDao2 {

	private MyConfiguration config;

	@BeforeEach
	public void setup() {
		config = new MyConfiguration();
	}

	@AfterEach
	public void teardown() {
		config = null;
	}

	@Test
	public void testInsert() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao2 dao = new ProjectDao2(conn);
		Project proj = new Project();
		proj.setProjid(8);
		proj.setProjname("Library system");
		proj.setProjdate(LocalDate.of(2027, 7, 2));
		dao.insert(proj);
		config.closeDb();

	}

	@Test
	public void testSelectAllProjects() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao2 dao = new ProjectDao2(conn);
		List<Project> records = dao.selectAllProjects();
		System.out.println(records);
		config.closeDb();
	}

	@Test
	public void testUpdateProjname() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao2 dao = new ProjectDao2(conn);
		boolean update = dao.updateProjname("Home Credit", 6);
		System.out.println(update);
		config.closeDb();
	}

	@Test
	public void testDelete() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao2 dao = new ProjectDao2(conn);
		dao.deleteProjname(8);
		config.closeDb();
	}

}
