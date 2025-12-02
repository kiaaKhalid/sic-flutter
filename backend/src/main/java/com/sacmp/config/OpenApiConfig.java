package com.sacmp.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

/**
 * Configuration OpenAPI/Swagger pour la documentation de l'API
 */
@Configuration
public class OpenApiConfig {

    @Value("${server.port:8080}")
    private String serverPort;

    @Bean
    public OpenAPI sacmpOpenAPI() {
        final String securitySchemeName = "bearerAuth";
        
        return new OpenAPI()
                .info(new Info()
                        .title("SAC-MP API")
                        .description("API REST pour le système de Surveillance Active et Continue - Médecine Personnalisée.\n\n" +
                                "## Authentification\n" +
                                "L'API utilise JWT (JSON Web Tokens). Obtenez un token via `/v1/auth/login` puis utilisez-le dans le header `Authorization: Bearer <token>`.\n\n" +
                                "## Rôles\n" +
                                "- **PATIENT** : Accès aux données personnelles de santé\n" +
                                "- **HEALTHCARE_WORKER** : Gestion des patients et alertes\n" +
                                "- **ADMIN** : Accès complet au système")
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("SAC-MP Team")
                                .email("contact@sacmp.com")
                                .url("https://sacmp.com"))
                        .license(new License()
                                .name("Proprietary")
                                .url("https://sacmp.com/license")))
                .servers(List.of(
                        new Server().url("http://localhost:" + serverPort + "/api").description("Serveur local"),
                        new Server().url("https://api.sacmp.com").description("Serveur production")
                ))
                .addSecurityItem(new SecurityRequirement().addList(securitySchemeName))
                .components(new Components()
                        .addSecuritySchemes(securitySchemeName,
                                new SecurityScheme()
                                        .name(securitySchemeName)
                                        .type(SecurityScheme.Type.HTTP)
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                                        .description("Entrez votre token JWT obtenu via /v1/auth/login")));
    }
}