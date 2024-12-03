package org.acumen.training.codes.dao;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.acumen.training.codes.BestBuyConfiguration;
import org.acumen.training.codes.models.Salesman;

public class SalesmanDao {

	private BestBuyConfiguration config;

	public SalesmanDao(BestBuyConfiguration config) {
		this.config = config;
	}

	// i. Calls the insert_salesman_sp() to populate the table.
	public boolean insertSalesman(String name, String city, Double commission) throws SQLException {
	    String sql = "call insert_salesman_sp(?, ?, ?, ?)";
	    
	    try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres", "admin2255");
	         CallableStatement stmt = connection.prepareCall(sql)) {

	        connection.setAutoCommit(false);
	        
	        stmt.setString(1, name);
	        stmt.setString(2, city);
	        stmt.setBigDecimal(3, BigDecimal.valueOf(commission));
	        stmt.setBoolean(4, true);
	        
	        stmt.registerOutParameter(4, Types.BOOLEAN); // Register is_success as OUT parameter
	        
	        stmt.execute();
            connection.commit();
	        boolean isSuccess = stmt.getBoolean(4);
	        
	        if (isSuccess) {
	            System.out.println("Salesman inserted successfully");
	            return true;
	        } else {
	            connection.rollback();  
	            System.out.println("Failed to insert salesman");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	// ii. Update Salesman Commission using PreparedStatement
	public boolean updateSalesmanCommission(Double newComm, Integer id) {
		String query = "update salesman set commission = ? where salesman_id = ?";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); PreparedStatement ps = connection.prepareStatement(query)) {

			connection.setAutoCommit(false); 
			ps.setDouble(1, newComm);
			ps.setInt(2, id);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
				connection.commit(); 
				return true;
			} else {
				connection.rollback(); 
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Update Salesman Details
	public boolean updateSalesmanDetails(String newName, String newCity, Integer id) {
		String query = "update salesman set name = ?, city = ? where salesman_id = ?";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); PreparedStatement ps = connection.prepareStatement(query)) {

			connection.setAutoCommit(false); 
			ps.setString(1, newName);
			ps.setString(2, newCity);
			ps.setInt(3, id);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
				connection.commit(); 
				return true;
			} else {
				connection.rollback(); 
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// iii. Delete Salesman by ID
	public boolean deleteSalesmanById(Integer id) {
		String query = "delete from salesman where salesman_id = ?";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); PreparedStatement ps = connection.prepareStatement(query)) {

			connection.setAutoCommit(false); 
			ps.setInt(1, id);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
				connection.commit(); 
				return true;
			} else {
				connection.rollback(); 
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Delete Salesman by City
	public boolean deleteSalesmanByCity(String city) throws SQLException {
		String query = "delete from salesman where city = ?";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); PreparedStatement ps = connection.prepareStatement(query)) {

			connection.setAutoCommit(false); 
			ps.setString(1, city);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected > 0) {
				connection.commit(); 
				return true;
			} else {
				connection.rollback(); 
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// iv. Select all Salesmen
	public List<Salesman> selectAllSalesman() throws SQLException {
		List<Salesman> salesmanList = new ArrayList<>();
		String query = "select * from salesman";

		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); Statement stmt = connection.createStatement(); ResultSet rs = stmt.executeQuery(query)) {

			while (rs.next()) {
				Salesman salesman = new Salesman(rs.getInt("salesman_id"), rs.getString("name"), rs.getString("city"),
						rs.getDouble("commission"));
				salesmanList.add(salesman);
			}
		}
		return salesmanList;
	}

	// v. Select a Single Salesman by ID
	public Salesman selectSingleSalesman(Integer id) {
		Salesman salesman = null;
		String query = "select * from salesman where salesman_id = ?";

		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); PreparedStatement ps = connection.prepareStatement(query)) {

			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					salesman = new Salesman(rs.getInt("salesman_id"), rs.getString("name"), rs.getString("city"),
							rs.getDouble("commission"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return salesman;
	}

	// Select Salesmen by City
	public List<Salesman> selectSalesmanPerCity(String city) {
		List<Salesman> salesmanList = new ArrayList<>();
		String query = "select * from salesman where city = ?";

		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); PreparedStatement ps = connection.prepareStatement(query)) {

			ps.setString(1, city);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Salesman salesman = new Salesman(rs.getInt("salesman_id"), rs.getString("name"),
							rs.getString("city"), rs.getDouble("commission"));
					salesmanList.add(salesman);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return salesmanList;
	}
}
