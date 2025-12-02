package com.sacmp.auth.controller;

import com.sacmp.auth.dto.*;
import com.sacmp.auth.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

/**
 * Contrôleur pour l'authentification
 * Base URL: /api/v1/auth
 */
@RestController
@RequestMapping("/v1/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    /**
     * Inscription d'un nouvel utilisateur
     * POST /api/v1/auth/register
     */
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Connexion d'un utilisateur
     * POST /api/v1/auth/login
     */
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    /**
     * Envoyer un code de connexion par email
     * POST /api/v1/auth/send-code
     */
    @PostMapping("/send-code")
    public ResponseEntity<String> sendLoginCode(@Valid @RequestBody SendCodeRequest request) {
        // TODO: Implémenter l'envoi de code par email
        return ResponseEntity.ok("Code envoyé à " + request.getEmail());
    }

    /**
     * Vérifier un code de connexion
     * POST /api/v1/auth/verify-code
     */
    @PostMapping("/verify-code")
    public ResponseEntity<AuthResponse> verifyCode(@Valid @RequestBody VerifyCodeRequest request) {
        // TODO: Implémenter la vérification du code
        return ResponseEntity.ok(new AuthResponse());
    }

    /**
     * Authentification via Google
     * POST /api/v1/auth/google
     */
    @PostMapping("/google")
    public ResponseEntity<AuthResponse> googleAuth(@Valid @RequestBody GoogleAuthRequest request) {
        // TODO: Implémenter l'authentification Google
        return ResponseEntity.ok(new AuthResponse());
    }

    /**
     * Rafraîchir le token
     * POST /api/v1/auth/refresh-token
     */
    @PostMapping("/refresh-token")
    public ResponseEntity<AuthResponse> refreshToken(@RequestHeader("Authorization") String token) {
        // TODO: Implémenter le rafraîchissement du token
        return ResponseEntity.ok(new AuthResponse());
    }

    /**
     * Déconnexion
     * POST /api/v1/auth/logout
     */
    @PostMapping("/logout")
    public ResponseEntity<String> logout() {
        return ResponseEntity.ok("Déconnexion réussie");
    }
}
