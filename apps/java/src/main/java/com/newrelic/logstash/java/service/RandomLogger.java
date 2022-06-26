package com.newrelic.logstash.java.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.boot.CommandLineRunner;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

public class RandomLogger implements CommandLineRunner {

    private static final int INTERVAL = 5000;

    private final Logger logger = LoggerFactory.getLogger(RandomLogger.class);

    private final Random random = new Random(System.currentTimeMillis());

    @Override
    public void run(String... args) throws Exception {

        var envs = createEnvironments();
        var teams = createTeams();
        var leads = createLeads();

        while (true) {

            var environmentCounter = random.nextInt(envs.size());
            MDC.put("my.custom.field.env", envs.get(environmentCounter));

            var teamCounter = random.nextInt(teams.size());
            MDC.put("my.custom.field.team", teams.get(teamCounter));

            var leadCounter = random.nextInt(leads.size());
            MDC.put("my.custom.field.lead", leads.get(leadCounter));

            logger.info(UUID.randomUUID().toString());
            MDC.clear();

            Thread.sleep(INTERVAL);
        }
    }

    private List<String> createEnvironments() {
        var environments = new ArrayList<String>();
        environments.add("dev");
        environments.add("stage");
        environments.add("prod");

        return environments;
    }

    private List<String> createTeams() {
        var teams = new ArrayList<String>();
        teams.add("liverpool");
        teams.add("chelsea");
        teams.add("city");
        teams.add("juve");
        teams.add("psg");
        teams.add("barca");
        teams.add("madrid");

        return teams;
    }

    private List<String> createLeads() {
        var leads = new ArrayList<String>();
        leads.add("elon");
        leads.add("bezos");
        leads.add("buffet");
        leads.add("trump");
        leads.add("biden");

        return leads;
    }
}
