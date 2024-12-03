package org.acumen.training.codes.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.logging.Logger;

public class ManagerDao {

	private Connection conn;
	private static final Logger LOGGER = Logger.getLogger(ProjectDao.class.getName());

	public ManagerDao(Connection conn) {
		this.conn = conn;
	}

	public boolean executeIncreaseSalary(Double inc, Integer id) {
		String sql = "call insert_salary_sp(?, ?, ?)";
		try (CallableStatement cstmt = conn.prepareCall(sql)) {
			// setting of the in params muna
			cstmt.setDouble(1, inc);
			cstmt.setShort(2, id.shortValue());
			cstmt.setBoolean(3, false);
			// sabihin mo sa vm na inout param yung num3
			cstmt.registerOutParameter(3, Types.BOOLEAN);
			// execute the call ops
			cstmt.execute();
			conn.commit();
			// getting the out params
			boolean res = cstmt.getBoolean(3);
			return res;
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

}
