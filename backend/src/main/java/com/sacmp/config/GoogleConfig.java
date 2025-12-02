package com.sacmp.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration Google OAuth2
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "google")
public class GoogleConfig {
    
    private String clientId;
}