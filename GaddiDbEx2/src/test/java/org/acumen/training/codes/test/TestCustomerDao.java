package org.acumen.training.codes.test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;

import org.acumen.training.codes.BestBuyConfiguration;
import org.acumen.training.codes.dao.CustomerDao;
import org.acumen.training.codes.models.Customer;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class TestCustomerDao {

    private CustomerDao customerDao;

    @BeforeEach
    void setUp() {
        BestBuyConfiguration config = new BestBuyConfiguration();
        customerDao = new CustomerDao(config);
    }

    @Test
    @Order(1)
    void testInsertCustomer() {
        String name = "Dough Toli";
        String city = "New York";
        Integer grade = 3;
        Integer salesmanId = 101;
        boolean isInserted = customerDao.insertCustomer(name, city, grade, salesmanId);
        assertTrue(isInserted, "Customer should be inserted successfully");
    }

    @Test
    @Order(2)
    void testUpdateCustomerGrade() {
        Integer customerId = 1; // Adjust as needed
        Integer newGrade = 4;
        boolean isUpdated = customerDao.updateCustomerGrade(customerId, newGrade);
        assertTrue(isUpdated, "Customer grade should be updated successfully");
    }

    @Test
    @Order(3)
    void testRemoveCustomerById() {
        Integer customerId = 1; // Adjust as needed
        boolean isRemoved = customerDao.removeCustomerById(customerId);
        assertTrue(isRemoved, "Customer should be removed successfully");
    }

    @Test
    @Order(4)
    void testSelectAllCustomers() {
        List<Customer> customers = customerDao.selectAllCustomers();
        assertNotNull(customers, "Customer list should not be null");
        assertFalse(customers.isEmpty(), "Customer list should not be empty");
    }
}
