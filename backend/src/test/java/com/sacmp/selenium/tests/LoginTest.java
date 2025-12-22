package com.sacmp.selenium.tests;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.*;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import com.sacmp.selenium.utils.FlutterWebHelper;
import io.github.bonigarcia.wdm.WebDriverManager;
import java.time.Duration;

/**
 * Simplified LoginTest using JavaScript-based interaction with Flutter Web
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class LoginTest {

    private static WebDriver driver;
    private static FlutterWebHelper flutterHelper;
    private static final String baseUrl = "http://localhost:5000";

    @BeforeAll
    public static void setUpClass() {
        WebDriverManager.chromedriver().setup();
    }

    @BeforeEach
    public void setUp() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--window-size=1920,1080");
        options.addArguments("--remote-allow-origins=*");
        options.addArguments("--disable-gpu");
        options.addArguments("--headless"); // Run headless for CI/CD

        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(15));
        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(60));

        flutterHelper = new FlutterWebHelper(driver);

        // Navigate to login page
        driver.get(baseUrl);

        // Wait for Flutter to load
        try {
            Thread.sleep(10000); // Give Flutter time to initialize
            flutterHelper.waitForFlutterLoad();
            System.out.println("Flutter app loaded successfully");
            System.out.println("Current URL: " + driver.getCurrentUrl());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    @Order(1)
    @DisplayName("Test 1: Vérification du chargement de la page de login")
    public void testPageLoad() {
        // Wait for "Welcome Back" text to appear
        try {
            flutterHelper.waitForText("Welcome Back");
            assertTrue(flutterHelper.isTextPresent("Welcome Back"),
                    "La page de connexion devrait afficher 'Welcome Back'");
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            assertTrue(false, "La page de login n'a pas chargé correctement");
        }
    }

    @Test
    @Order(2)
    @DisplayName("Test 2: Connexion avec champs vides")
    public void testLoginWithEmptyFields() {
        try {
            // Click the login button without filling fields
            flutterHelper.clickElementWithText("Login");

            Thread.sleep(2000); // Wait for validation

            // Check if we're still on login page (validation should prevent navigation)
            assertTrue(driver.getCurrentUrl().contains("localhost:5000"),
                    "Devrait rester sur la page de login avec des champs vides");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Connexion avec email invalide")
    public void testLoginWithInvalidEmail() {
        try {
            // Type invalid email
            flutterHelper.clearAndType("Email", "invalid-email");
            flutterHelper.clearAndType("Password", "password123");

            // Click login
            flutterHelper.clickElementWithText("Login");

            Thread.sleep(2000);

            // Should still be on login page
            assertTrue(driver.getCurrentUrl().contains("localhost:5000"),
                    "Devrait rester sur la page de login avec un email invalide");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Connexion réussie avec admin")
    public void testSuccessfulLoginAsAdmin() {
        try {
            // Type valid admin credentials
            flutterHelper.clearAndType("Email", "admin@gmail.com");
            flutterHelper.clearAndType("Password", "123456");

            // Click login
            flutterHelper.clickElementWithText("Login");

            // Wait for navigation
            Thread.sleep(5000);

            // Check if navigated to dashboard
            boolean isDashboard = driver.getCurrentUrl().contains("dashboard") ||
                    flutterHelper.isTextPresent("Dashboard") ||
                    flutterHelper.isTextPresent("Bonjour");

            assertTrue(isDashboard,
                    "Devrait naviguer vers le dashboard après une connexion réussie");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    @Test
    @Order(5)
    @DisplayName("Test 5: Navigation vers la page d'inscription")
    public void testNavigationToRegister() {
        try {
            // Click on "Sign up" link
            flutterHelper.clickElementContainingText("Sign up");

            // Wait for navigation
            Thread.sleep(3000);

            // Check if on register page
            boolean isRegisterPage = driver.getCurrentUrl().contains("register") ||
                    flutterHelper.isTextPresent("Create Your Account");

            assertTrue(isRegisterPage,
                    "Devrait naviguer vers la page d'inscription");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}