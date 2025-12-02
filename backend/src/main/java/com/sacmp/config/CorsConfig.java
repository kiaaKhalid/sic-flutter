package com.sacmp.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration CORS
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "cors")
public class CorsConfig {
    
    private String allowedOrigins;
    private String allowedMethods;
    private String allowedHeaders;
    private boolean allowCredentials;
}