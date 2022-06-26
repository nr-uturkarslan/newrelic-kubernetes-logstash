package com.newrelic.logstash.java.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("health")
public class HealthController {

    private final Logger logger = LoggerFactory.getLogger(HealthController.class);

    @PostMapping
    public ResponseEntity<String> checkHealth() {
        MDC.put("test.id", "test");

        logger.info("Health check: OK!");

        MDC.clear();

        return new ResponseEntity<String>("OK!", HttpStatus.OK);
    }
}
