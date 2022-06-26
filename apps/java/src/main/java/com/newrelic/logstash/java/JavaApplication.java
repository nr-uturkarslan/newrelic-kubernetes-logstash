package com.newrelic.logstash.java;

import com.newrelic.logstash.java.service.RandomLogger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class JavaApplication {

	public static void main(String[] args) {
		SpringApplication.run(JavaApplication.class, args);
	}

	@Bean
	public RandomLogger randomLogger() {
		return new RandomLogger();
	}
}
