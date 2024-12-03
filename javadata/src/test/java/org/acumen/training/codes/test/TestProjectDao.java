package org.acumen.training.codes.test;

import java.sql.Connection;
import java.time.LocalDate;
import java.time.Year;
import java.util.Arrays;
import java.util.List;

import org.acumen.training.codes.MyConfiguration;
import org.acumen.training.codes.dao.ManagerDao;
import org.acumen.training.codes.dao.ProjectDao;
import org.acumen.training.codes.model.Project;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

public class TestProjectDao {

	private MyConfiguration config;

	@BeforeEach
	public void setup() {
		config = new MyConfiguration();
	}

	@AfterEach
	public void teardown() {
		config = null;
	}

	@Disabled
	@Test
	public void testInsertProject() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms2", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		Project proj = new Project();
		proj.setProjid(6);
		proj.setProjname("Catering system");
		proj.setProjdate(LocalDate.of(2026, 7, 2));
		dao.insert(proj);
		config.closeDb();
	}

	@Disabled
	@Test
	public void testUpdateProject() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms2", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		dao.updateProjname("Human Resource Mgt Sys", 1);
		config.closeDb();
	}

	@Disabled
	@Test
	public void testDeleteProjectById() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		dao.deleteById(6);
		config.closeDb();
	}

	@Disabled
	@Test
	public void testInsertPrepared() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		Project proj = new Project();
		proj.setProjid(6);
		proj.setProjname("Catering system");
		proj.setProjdate(LocalDate.of(2026, 7, 2));
		dao.insertPrepared(proj);
		config.closeDb();
	}

	@Disabled
	@Test
	public void testSelectAllProjects() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		List<Project> records = dao.selectAllProjects();
		System.out.println(records);
		config.closeDb();
	}

	@Disabled
	@Test
	public void testSelectAProjects() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		Project recProject = dao.selectProject(4);
		System.out.println(recProject);
		config.closeDb();
	}

	@Test
	public void testSelectAProjectsByYear() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ProjectDao dao = new ProjectDao(conn);
		List<Object[]> recProject = dao.selectProjectByDate(LocalDate.of(2025, 1, 1));
		recProject.stream().forEach((rec) -> {
			System.out.println(Arrays.toString(rec));
		});
		config.closeDb();
	}

	@Test
	public void testIncSalary() {
		config.loadDriver();
		Connection conn = config.connectDb("jdbc:postgresql://localhost:5432/hrms", "postgres", "admin2255");
		ManagerDao dao = new ManagerDao(conn);
		boolean res = dao.executeIncreaseSalary(5000.00, 102);
		System.out.println(res);
		config.closeDb();
	}

}
