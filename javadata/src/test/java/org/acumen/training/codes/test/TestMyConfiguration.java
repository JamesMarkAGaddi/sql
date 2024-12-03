package org.acumen.training.codes.test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import org.acumen.training.codes.MyConfiguration;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

public class TestMyConfiguration {

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
	public void testConnectivity() {
		assertEquals(true, config.loadDriver());
		assertNotNull(config.connectDb("jdbc:postgresql://localhost:5432/hrms2", "postgres", "admin2255"));
		assertEquals(true, config.closeDb());
	}

}
