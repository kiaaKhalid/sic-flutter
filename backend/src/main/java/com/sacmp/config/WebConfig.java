package com.sacmp.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuration Web MVC
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    // CORS configuration is now handled in SecurityConfig.java
    // to avoid duplicate bean definition conflicts
}