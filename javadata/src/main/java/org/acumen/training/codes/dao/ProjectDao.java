package org.acumen.training.codes.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import org.acumen.training.codes.model.Project;

public class ProjectDao {

	private Connection conn;
	private static final Logger LOGGER = Logger.getLogger(ProjectDao.class.getName());

	public ProjectDao(Connection conn) {
		this.conn = conn;
	}

	public boolean insert(Project proj) {
		String sql = "insert into project values (%d, '%s', '%s');".formatted(proj.getProjid(), proj.getProjname(),
				proj.getProjdate());
		try (Statement stmt = conn.createStatement();) {
			int row = stmt.executeUpdate(sql);
			conn.commit();
			LOGGER.info("Number row added: %d".formatted(row));
			return true;
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return false;
	}

	public boolean insertPrepared(Project proj) {
		String sql = "insert into project values (?, ?, ?);"; // placeholder markers
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) { // pre-compiled
			// set the values (order sa (?,?,?), getters)
			pstmt.setShort(1, proj.getProjid().shortValue());
			pstmt.setString(2, proj.getProjname());
			pstmt.setDate(3, Date.valueOf(proj.getProjdate()));
			int row = pstmt.executeUpdate();
			conn.commit();
			LOGGER.info("Number row added: %d".formatted(row));
			return true;
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return false;
	}

	public boolean updateProjname(String newProjname, Integer id) {
		String sql = "update project set projname = '%s' where id = %d".formatted(newProjname, id);
		try (Statement stmt = conn.createStatement();) {
			int row = stmt.executeUpdate(sql);
			conn.commit();
			LOGGER.info("Number row updated: %d".formatted(row));
			return true;
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return false;
	}

	public boolean deleteById(Integer id) {
		String sql = "delete from project where id = %d".formatted(id);
		try (Statement stmt = conn.createStatement();) {
			int row = stmt.executeUpdate(sql);
			conn.commit();
			LOGGER.info("Number row deleted: %d".formatted(row));
			return true;
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return false;
	}

	// Query transactions
	public List<Project> selectAllProjects() {
		List<Project> recs = new ArrayList<>();
		String sql = "select * from project";
		try (Statement stmt = conn.createStatement();) {
			ResultSet res = stmt.executeQuery(sql);
			while (res.next()) {
				Project proj = new Project();
				proj.setProjid(Integer.valueOf(res.getShort("projid")));
				proj.setProjname(res.getString("projname"));
				proj.setProjdate(res.getDate("projdate").toLocalDate());
				recs.add(proj);
			}

			LOGGER.info("Number of rows: %d".formatted(recs.size()));
			return recs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return recs;
	}

	public Project selectProject(Integer id) {
		Project project = new Project();
		String sql = "select * from project where id=?";
		try (Statement stmt = conn.prepareStatement(sql);) {
			try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
				pstmt.setShort(1, id.shortValue());
				ResultSet res = pstmt.executeQuery();
				while (res.next()) {
					project.setProjid(Integer.valueOf(res.getShort("id")));
					project.setProjname(res.getString("projname"));
					project.setProjdate(res.getDate("projdate").toLocalDate());
				}
				LOGGER.info("Number of rows: %d".formatted(1));
				return project;
			}
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		return project;

	}

	// projected list kaya ganyan ang type
	public List<Object[]> selectProjectByDate(LocalDate date) {
		List<Object[]> recs = new ArrayList<Object[]>();
		String sql = "select projname, projdate from project where date_part('year', projdate) = ?";
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, date.getYear());
			ResultSet res = pstmt.executeQuery();
			while (res.next()) {
				Object[] rec = new Object[2];
				rec[0] = res.getString("projname");
				rec[1] = res.getDate("projdate").toLocalDate();
				recs.add(rec);
			}
			LOGGER.info("Number of rows: %d".formatted(recs.size()));
			return recs;
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
		return recs;

	}

}
//	creating a table with auto-increment
//	String sql = "create sequence animal_id_seq;" +
//			" create table animal (" +
//            " id integer not null primary key default nextval('animal_id_seq'), " +
//            " name varchar(40), " + 
//            " category varchar(40) " + 
//            " )"; 
//    stm.executeUpdate(sql);
