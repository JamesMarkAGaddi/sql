package org.acumen.training.codes;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class BestBuyConfiguration {

	private Connection conn;

	public boolean loadDriver() {
		try {
			Class.forName("org.postgresql.Driver");
			return true;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		return false;
	}

	public Connection connectDb(String url, String username, String password) {
		try {
			conn = DriverManager.getConnection(url, username, password);
			conn.setAutoCommit(false);
			return conn;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public boolean closeDb() {
		try {
			conn.close();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;

	}
}
