package org.acumen.training.codes.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.RowSetFactory;
import javax.sql.rowset.RowSetProvider;

import org.acumen.training.codes.model.Project;

public class ProjectDao2 {

	Connection conn;

	public ProjectDao2(Connection conn) {
		this.conn = conn;
	}

	public boolean insert(Project proj) {
		String sql = "select * from project"; // You could make this more efficient with a prepared statement
		try (Statement stmtStatement = conn.createStatement()) {
			ResultSet res = stmtStatement.executeQuery(sql);

			// RowSet
			RowSetFactory factory = RowSetProvider.newFactory();
			CachedRowSet cachedRowSet = factory.createCachedRowSet();

			// Populate CachedRowSet with ResultSet
			cachedRowSet.populate(res);

			cachedRowSet.setTableName("project");
			cachedRowSet.moveToInsertRow();
			cachedRowSet.updateShort("id", proj.getProjid().shortValue());
			cachedRowSet.updateString("projname", proj.getProjname());
			cachedRowSet.updateDate("projdate", Date.valueOf(proj.getProjdate()));

			cachedRowSet.insertRow();
			cachedRowSet.moveToCurrentRow();
			// Commit changes to the database
			cachedRowSet.acceptChanges(conn);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<Project> selectAllProjects() {
		List<Project> recs = new ArrayList<>();
		String sql = "select * from project";
		try (Statement stmtStatement = conn.createStatement()) {
			ResultSet res = stmtStatement.executeQuery(sql);

			// RowSet
			RowSetFactory factory = RowSetProvider.newFactory();
			CachedRowSet cachedRowSet = factory.createCachedRowSet();

			// Populate CachedRowSet with ResultSet
			cachedRowSet.populate(res);
			cachedRowSet.setTableName("project");

			while (cachedRowSet.next()) {
				Project proj = new Project();
				proj.setProjid(Integer.valueOf(cachedRowSet.getShort("id")));
				proj.setProjname(cachedRowSet.getString("projname"));
				proj.setProjdate(cachedRowSet.getDate("projdate").toLocalDate());
				recs.add(proj);
			}

			return recs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return recs;
	}

	public boolean updateProjname(String newname, Integer id) {
		boolean isUpdated = false;
		String sql = "select * from project";
		try (Statement stmtStatement = conn.createStatement()) {
			ResultSet res = stmtStatement.executeQuery(sql);

			// RowSet
			RowSetFactory factory = RowSetProvider.newFactory();
			CachedRowSet cachedRowSet = factory.createCachedRowSet();

			// Populate CachedRowSet with ResultSet
			cachedRowSet.populate(res);

			cachedRowSet.setTableName("project");
			while (cachedRowSet.next()) {
				short tempId = cachedRowSet.getShort("id");
				if (tempId == id.shortValue()) {
					cachedRowSet.updateString("projname", newname);
					cachedRowSet.updateRow();
					cachedRowSet.acceptChanges(conn);
					isUpdated = true;
				}
			}
			return isUpdated;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;

	}

	public boolean deleteProjname(Integer id) {
		boolean isDeleted = false;
		String sql = "select * from project";
		try (Statement stmtStatement = conn.createStatement()) {
			ResultSet res = stmtStatement.executeQuery(sql);

			// RowSet
			RowSetFactory factory = RowSetProvider.newFactory();
			CachedRowSet cachedRowSet = factory.createCachedRowSet();

			// Populate CachedRowSet with ResultSet
			cachedRowSet.populate(res);

			cachedRowSet.setTableName("project");
			while (cachedRowSet.next()) {
				short tempId = cachedRowSet.getShort("id");
				if (tempId == id.shortValue()) {
					cachedRowSet.deleteRow();
					cachedRowSet.acceptChanges(conn);
					isDeleted = true;
				}
			}
			return isDeleted;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;

	}

}
