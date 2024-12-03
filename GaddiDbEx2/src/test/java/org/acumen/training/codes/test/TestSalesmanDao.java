package org.acumen.training.codes.test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.sql.SQLException;
import java.util.List;

import org.acumen.training.codes.BestBuyConfiguration;
import org.acumen.training.codes.dao.SalesmanDao;
import org.acumen.training.codes.models.Salesman;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.TestMethodOrder;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class TestSalesmanDao {

	private SalesmanDao salesmanDao;

	@BeforeAll
	public void setup() throws SQLException {
		BestBuyConfiguration config = new BestBuyConfiguration();
		salesmanDao = new SalesmanDao(config);
	}

	@Test
	@Order(1)
	public void testInsertSalesman() throws SQLException {
		boolean result = salesmanDao.insertSalesman("John Doe", "Los Angeles", 0.10);
		assertTrue(result);

		Salesman salesman = salesmanDao.selectSingleSalesman(5008);
		assertEquals("John Doe", salesman.getName());
		assertEquals("Los Angeles", salesman.getCity());
		assertEquals(0.10, salesman.getCommission());
	}

	@Test
	@Order(2)
	public void testSelectAllSalesman() throws SQLException {
		List<Salesman> salesmen = salesmanDao.selectAllSalesman();
		assertEquals(7, salesmen.size());

		Salesman s1 = salesmen.get(0);
		assertEquals(5001, s1.getId());
		assertEquals("James Hoog", s1.getName());
		assertEquals("New York", s1.getCity());
		assertEquals(0.15, s1.getCommission());
	}

	@Test
	@Order(3)
	public void testUpdateSalesmanCommission() throws SQLException {
		boolean result = salesmanDao.updateSalesmanCommission(0.18, 5001);
		assertTrue(result);

		Salesman salesman = salesmanDao.selectSingleSalesman(5001);
		assertEquals(0.18, salesman.getCommission());

		salesmanDao.updateSalesmanCommission(0.15, 5001); 
	}

	@Test
	@Order(4)
	public void testUpdateSalesmanDetails() throws SQLException {
		boolean result = salesmanDao.updateSalesmanDetails("James Bond", "London", 5001);
		assertTrue(result);

		Salesman salesman = salesmanDao.selectSingleSalesman(5001);
		assertEquals("James Bond", salesman.getName());
		assertEquals("London", salesman.getCity());

		salesmanDao.updateSalesmanDetails("James Hoog", "New York", 5001); 
	}

	@Test
	@Order(5)
	public void testDeleteSalesmanById() throws SQLException {
		boolean insertResult = salesmanDao.insertSalesman("Jane Smith", "Berlin", 0.12);
		assertTrue(insertResult);

		boolean deleteResult = salesmanDao.deleteSalesmanById(5009);
		assertTrue(deleteResult);

		Salesman deletedSalesman = salesmanDao.selectSingleSalesman(5009);
		assertNull(deletedSalesman);
	}

	@Test
	@Order(6)
	public void testDeleteSalesmanByCity() throws SQLException {
		boolean insertResultA = salesmanDao.insertSalesman("Salesman A", "TestCity", 0.15);
		boolean insertResultB = salesmanDao.insertSalesman("Salesman B", "TestCity", 0.14);
		assertTrue(insertResultA && insertResultB);

		boolean deleteResult = salesmanDao.deleteSalesmanByCity("TestCity");
		assertTrue(deleteResult);

		List<Salesman> salesmenInTestCity = salesmanDao.selectSalesmanPerCity("TestCity");
		assertTrue(salesmenInTestCity.isEmpty());
	}

	@Test
	@Order(7)
	public void testSelectSingleSalesman() throws SQLException {
		Salesman salesman = salesmanDao.selectSingleSalesman(5001);
		assertNotNull(salesman);
		assertEquals(5001, salesman.getId());
		assertEquals("James Hoog", salesman.getName());
		assertEquals("New York", salesman.getCity());
		assertEquals(0.15, salesman.getCommission());
	}

	@Test
	@Order(8)
	public void testSelectSalesmanPerCity() throws SQLException {
		List<Salesman> salesmenInParis = salesmanDao.selectSalesmanPerCity("Paris");
		assertEquals(2, salesmenInParis.size());

		Salesman s1 = salesmenInParis.get(0);
		assertEquals("Nail Knite", s1.getName());
		assertEquals(0.13, s1.getCommission());
	}

	@Test
	@Order(9)
	public void testSelectSingleSalesmanInvalidId() {
		assertThrows(SQLException.class, () -> {
			salesmanDao.selectSingleSalesman(-1);
		});
	}

	@Test
	@Order(10)
	public void testInsertSalesmanInvalidCommission() {
		assertThrows(SQLException.class, () -> {
			salesmanDao.insertSalesman("Invalid Salesman", "InvalidCity", -0.5);
		});
	}

	@Test
	@Order(11)
	public void testUpdateSalesmanCommissionInvalidId() {
		assertThrows(SQLException.class, () -> {
			salesmanDao.updateSalesmanCommission(0.20, -1); 
		});
	}

	@Test
	@Order(12)
	public void testUpdateSalesmanDetailsInvalidId() {
		assertThrows(SQLException.class, () -> {
			salesmanDao.updateSalesmanDetails("Invalid Name", "Invalid City", -1);
		});
	}

	@Test
	@Order(13)
	public void testDeleteSalesmanByIdInvalid() {
		assertThrows(SQLException.class, () -> {
			salesmanDao.deleteSalesmanById(-1);
		});
	}
}
