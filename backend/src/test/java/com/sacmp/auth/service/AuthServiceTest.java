package com.sacmp.auth.service;

import com.sacmp.auth.dto.AuthResponse;
import com.sacmp.auth.dto.LoginRequest;
import com.sacmp.auth.dto.RegisterRequest;
import com.sacmp.auth.entity.User;
import com.sacmp.auth.repository.UserRepository;
import com.sacmp.common.enums.AccountStatus;
import com.sacmp.common.enums.UserRole;
import com.sacmp.patient.repository.PatientRepository;
import com.sacmp.security.JwtService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PatientRepository patientRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @Mock
    private AuthenticationManager authenticationManager;

    @InjectMocks
    private AuthService authService;

    private User user;
    private String token;
    private String refreshToken;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId(UUID.randomUUID());
        user.setEmail("test@example.com");
        user.setFullName("Test User");
        user.setPasswordHash("encodedPassword");
        user.setRole(UserRole.PATIENT);
        user.setStatus(AccountStatus.ACTIVE);
        user.setEmailVerified(true);

        token = "jwt.access.token";
        refreshToken = "jwt.refresh.token";
    }

    @Test
    void register_ShouldCreateNewUser_WhenValidRequest() {
        // Given
        RegisterRequest request = new RegisterRequest();
        request.setEmail("newuser@example.com");
        request.setPassword("password123");
        request.setConfirmPassword("password123");
        request.setFullName("New User");
        request.setPhoneNumber("1234567890");
        request.setRole(UserRole.PATIENT);

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(request.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(i -> {
            User savedUser = (User) i.getArguments()[0];
            savedUser.setId(UUID.randomUUID());
            return savedUser;
        });
        when(patientRepository.save(any())).thenAnswer(i -> i.getArguments()[0]);
        when(jwtService.generateToken(any(User.class))).thenReturn(token);
        when(jwtService.generateRefreshToken(any(User.class))).thenReturn(refreshToken);

        // When
        AuthResponse response = authService.register(request);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getAccessToken()).isEqualTo(token);
        assertThat(response.getRefreshToken()).isEqualTo(refreshToken);
        assertThat(response.getTokenType()).isEqualTo("Bearer");
        assertThat(response.getUser().getEmail()).isEqualTo(request.getEmail());

        verify(userRepository).existsByEmail(request.getEmail());
        verify(passwordEncoder).encode(request.getPassword());
        verify(userRepository).save(any(User.class));
        verify(patientRepository).save(any());
    }

    @Test
    void register_ShouldThrowException_WhenPasswordsDoNotMatch() {
        // Given
        RegisterRequest request = new RegisterRequest();
        request.setEmail("newuser@example.com");
        request.setPassword("password123");
        request.setConfirmPassword("differentPassword");
        request.setFullName("New User");

        // When & Then
        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Les mots de passe ne correspondent pas");

        verify(userRepository, never()).existsByEmail(anyString());
        verify(userRepository, never()).save(any());
    }

    @Test
    void register_ShouldThrowException_WhenEmailAlreadyExists() {
        // Given
        RegisterRequest request = new RegisterRequest();
        request.setEmail("existing@example.com");
        request.setPassword("password123");
        request.setConfirmPassword("password123");
        request.setFullName("Existing User");

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(true);

        // When & Then
        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Cet email est déjà utilisé");

        verify(userRepository).existsByEmail(request.getEmail());
        verify(passwordEncoder, never()).encode(anyString());
        verify(userRepository, never()).save(any());
    }

    @Test
    void login_ShouldReturnAuthResponse_WhenCredentialsValid() {
        // Given
        LoginRequest request = new LoginRequest();
        request.setEmail("test@example.com");
        request.setPassword("password123");

        Authentication authentication = mock(Authentication.class);
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenReturn(authentication);
        when(userRepository.findByEmail(request.getEmail())).thenReturn(Optional.of(user));
        when(userRepository.save(any(User.class))).thenReturn(user);
        when(jwtService.generateToken(any(User.class))).thenReturn(token);
        when(jwtService.generateRefreshToken(any(User.class))).thenReturn(refreshToken);

        // When
        AuthResponse response = authService.login(request);

        // Then
        assertThat(response).isNotNull();
        assertThat(response.getAccessToken()).isEqualTo(token);
        assertThat(response.getRefreshToken()).isEqualTo(refreshToken);
        assertThat(response.getUser().getEmail()).isEqualTo(user.getEmail());

        verify(authenticationManager).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verify(userRepository).findByEmail(request.getEmail());
        verify(userRepository).save(user);
    }

    @Test
    void login_ShouldThrowException_WhenCredentialsInvalid() {
        // Given
        LoginRequest request = new LoginRequest();
        request.setEmail("test@example.com");
        request.setPassword("wrongpassword");

        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenThrow(new BadCredentialsException("Invalid credentials"));

        // When & Then
        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(BadCredentialsException.class);

        verify(authenticationManager).authenticate(any(UsernamePasswordAuthenticationToken.class));
        verify(userRepository, never()).findByEmail(anyString());
    }

    @Test
    void login_ShouldThrowException_WhenUserNotFound() {
        // Given
        LoginRequest request = new LoginRequest();
        request.setEmail("test@example.com");
        request.setPassword("password123");

        Authentication authentication = mock(Authentication.class);
        when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                .thenReturn(authentication);
        when(userRepository.findByEmail(request.getEmail())).thenReturn(Optional.empty());

        // When & Then
        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(RuntimeException.class)
                .hasMessage("Utilisateur non trouvé");

        verify(userRepository).findByEmail(request.getEmail());
        verify(userRepository, never()).save(any());
    }

    @Test
    void register_ShouldNotCreatePatient_WhenRoleIsNotPatient() {
        // Given
        RegisterRequest request = new RegisterRequest();
        request.setEmail("doctor@example.com");
        request.setPassword("password123");
        request.setConfirmPassword("password123");
        request.setFullName("Dr. Smith");
        request.setRole(UserRole.HEALTHCARE_WORKER);

        when(userRepository.existsByEmail(request.getEmail())).thenReturn(false);
        when(passwordEncoder.encode(request.getPassword())).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenAnswer(i -> {
            User savedUser = (User) i.getArguments()[0];
            savedUser.setId(UUID.randomUUID());
            return savedUser;
        });
        when(jwtService.generateToken(any(User.class))).thenReturn(token);
        when(jwtService.generateRefreshToken(any(User.class))).thenReturn(refreshToken);

        // When
        AuthResponse response = authService.register(request);

        // Then
        assertThat(response).isNotNull();
        verify(patientRepository, never()).save(any());
    }
}
