package org.acumen.training.codes.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.rowset.CachedRowSet;
import javax.sql.rowset.RowSetProvider;

import org.acumen.training.codes.BestBuyConfiguration;
import org.acumen.training.codes.models.Customer;

public class CustomerDao {

	private BestBuyConfiguration config;

	public CustomerDao(BestBuyConfiguration config) {
		this.config = config;
	}

	public boolean insertCustomer(String name, String city, Integer grade, Integer salesmanId) {
		String sql = "select * from customer";
		boolean isSuccess = false;

		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); CachedRowSet rowSet = RowSetProvider.newFactory().createCachedRowSet()) {

			rowSet.setCommand(sql);
			rowSet.execute(connection);

			rowSet.moveToInsertRow();
			rowSet.updateString("cust_name", name);
			rowSet.updateString("city", city);
			rowSet.updateInt("grade", grade);
			rowSet.updateInt("salesman_id", salesmanId);
			rowSet.insertRow();
			rowSet.moveToCurrentRow();

			rowSet.acceptChanges(connection);
			isSuccess = true;
			return isSuccess;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateCustomerGrade(Integer id, Integer newGrade) {
		String sql = "update customer SET grade = ? WHERE customer_id = ?";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); CachedRowSet rowSet = RowSetProvider.newFactory().createCachedRowSet()) {

			connection.setAutoCommit(false);
			rowSet.setCommand(sql);
			rowSet.setInt(1, newGrade);
			rowSet.setInt(2, id);
			rowSet.execute(connection);
			connection.commit();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean removeCustomerById(Integer id) {
		String sql = "delete from customer WHERE customer_id = ?";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); CachedRowSet rowSet = RowSetProvider.newFactory().createCachedRowSet()) {

			connection.setAutoCommit(false);
			rowSet.setCommand(sql);
			rowSet.setInt(1, id);
			rowSet.execute(connection);
			connection.commit();
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	public List<Customer> selectAllCustomers() {
		List<Customer> customers = new ArrayList<>();
		String sql = "select * from customer";
		try (Connection connection = config.connectDb("jdbc:postgresql://localhost:5432/bestbuy", "postgres",
				"admin2255"); CachedRowSet rowSet = RowSetProvider.newFactory().createCachedRowSet()) {

			rowSet.setCommand(sql);
			rowSet.execute(connection);

			while (rowSet.next()) {
				Customer customer = new Customer(rowSet.getInt("customer_id"), rowSet.getString("cust_name"),
						rowSet.getString("city"), rowSet.getInt("grade"), rowSet.getInt("salesman_id"));
				customers.add(customer);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return customers;
	}
}
