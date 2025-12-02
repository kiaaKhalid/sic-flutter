package com.sacmp.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration Storage pour les fichiers (rapports PDF/Excel)
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "storage")
public class StorageConfig {
    
    private Reports reports = new Reports();
    
    @Data
    public static class Reports {
        private String path;
        private int maxSizeMb;
    }
}