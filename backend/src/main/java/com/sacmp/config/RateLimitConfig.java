package com.sacmp.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration Rate Limiting
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "rate-limit")
public class RateLimitConfig {
    
    private Login login = new Login();
    private VerificationCode verificationCode = new VerificationCode();
    private Api api = new Api();
    
    @Data
    public static class Login {
        private int maxAttempts;
        private int blockDurationMinutes;
    }
    
    @Data
    public static class VerificationCode {
        private int maxPerMinute;
        private int maxPerHour;
    }
    
    @Data
    public static class Api {
        private Patient patient = new Patient();
        private HealthcareWorker healthcareWorker = new HealthcareWorker();
        private ReportGeneration reportGeneration = new ReportGeneration();
        
        @Data
        public static class Patient {
            private int requestsPerMinute;
        }
        
        @Data
        public static class HealthcareWorker {
            private int requestsPerHour;
        }
        
        @Data
        public static class ReportGeneration {
            private int requestsPerHour;
        }
    }
}