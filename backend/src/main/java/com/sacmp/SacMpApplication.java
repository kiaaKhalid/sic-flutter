package com.sacmp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.cache.annotation.EnableCaching;

/**
 * Application principale SAC-MP
 * Surveillance Active et Continue - Médecine Personnalisée
 */
@SpringBootApplication
@EnableCaching
@EnableConfigurationProperties
public class SacMpApplication {

    public static void main(String[] args) {
        SpringApplication.run(SacMpApplication.class, args);
    }
}
