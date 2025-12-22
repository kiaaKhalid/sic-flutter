package com.sacmp.selenium.tests;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.*;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.WebDriverWait;
import com.sacmp.selenium.pages.RegisterPage;
import io.github.bonigarcia.wdm.WebDriverManager;
import java.time.Duration;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class RegisterTest {
    private static WebDriver driver;
    private static RegisterPage registerPage;
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
        options.addArguments("--disable-software-rasterizer");
        options.addArguments("--headless"); // Run in headless mode for CI/CD

        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(15));
        driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(60));

        registerPage = new RegisterPage(driver, baseUrl);

        // Naviguer directement vers la page d'inscription
        driver.get(baseUrl + "/#/register");

        // Attendre que Flutter charge complètement
        try {
            Thread.sleep(10000); // Attendre 10 secondes pour que Flutter se charge

            // Vérifier que la page est chargée en cherchant n'importe quel contenu
            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(20));
            wait.until(driver1 -> {
                // Vérifier si le canvas Flutter est présent
                Object result = ((JavascriptExecutor) driver1).executeScript(
                        "return document.querySelector('flt-glass-pane') !== null || " +
                                "document.querySelector('canvas') !== null || " +
                                "document.body.textContent.length > 0;");
                return Boolean.TRUE.equals(result);
            });

            System.out.println("Flutter app loaded successfully");
            System.out.println("Current URL: " + driver.getCurrentUrl());
            System.out.println("Page title: " + driver.getTitle());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        } catch (Exception e) {
            System.err.println("Error during setUp: " + e.getMessage());
            // Prendre une capture d'écran pour le débogage
            try {
                ((org.openqa.selenium.TakesScreenshot) driver)
                        .getScreenshotAs(org.openqa.selenium.OutputType.FILE);
            } catch (Exception ignored) {
            }
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
    @DisplayName("Test 1: Chargement de la page d'inscription")
    public void testPageLoad() {
        assertTrue(registerPage.isPageLoaded(), "La page d'inscription devrait être chargée");
    }

    // ==================== Tests de validation du nom complet ====================

    @Test
    @Order(2)
    @DisplayName("Test 2: Nom complet requis")
    public void testFullNameRequired() {
        registerPage.enterFullName("");
        registerPage.enterEmail("test@gmail.com"); // Blur le champ nom

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Full Name*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour le nom vide");
        assertTrue(error.contains("requis") || error.contains("required"),
                "Le message d'erreur devrait indiquer que le nom est requis");
    }

    @Test
    @Order(3)
    @DisplayName("Test 3: Nom complet trop court")
    public void testFullNameTooShort() {
        registerPage.enterFullName("A");
        registerPage.enterEmail("test@gmail.com"); // Blur le champ nom

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Full Name*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un nom trop court");
        assertTrue(error.contains("2 caractères") || error.contains("2 characters"),
                "Le message d'erreur devrait indiquer le minimum de 2 caractères");
    }

    @Test
    @Order(4)
    @DisplayName("Test 4: Nom complet avec caractères invalides")
    public void testFullNameInvalidCharacters() {
        registerPage.enterFullName("John123");
        registerPage.enterEmail("test@gmail.com"); // Blur le champ nom

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Full Name*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un nom avec des chiffres");
        assertTrue(error.contains("lettres") || error.contains("letters"),
                "Le message d'erreur devrait indiquer que seules les lettres sont autorisées");
    }

    // ==================== Tests de validation de l'email ====================

    @Test
    @Order(5)
    @DisplayName("Test 5: Email requis")
    public void testEmailRequired() {
        registerPage.enterEmail("");
        registerPage.enterPassword("Test123!"); // Blur le champ email

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Email address*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour l'email vide");
        assertTrue(error.contains("requis") || error.contains("required"),
                "Le message d'erreur devrait indiquer que l'email est requis");
    }

    @Test
    @Order(6)
    @DisplayName("Test 6: Email format invalide")
    public void testEmailInvalidFormat() {
        registerPage.enterEmail("invalid");
        registerPage.enterPassword("Test123!"); // Blur le champ email

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Email address*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un format d'email invalide");
        assertTrue(error.contains("invalide") || error.contains("invalid"),
                "Le message d'erreur devrait indiquer que le format est invalide");
    }

    @Test
    @Order(7)
    @DisplayName("Test 7: Email domaine non autorisé")
    public void testEmailInvalidDomain() {
        registerPage.enterEmail("test@invalid.com");
        registerPage.enterPassword("Test123!"); // Blur le champ email

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Email address*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un domaine non autorisé");
        assertTrue(error.contains("domaine") || error.contains("domain") ||
                error.contains("gmail") || error.contains("yahoo"),
                "Le message d'erreur devrait indiquer les domaines autorisés");
    }

    // ==================== Tests de validation du mot de passe ====================

    @Test
    @Order(8)
    @DisplayName("Test 8: Mot de passe requis")
    public void testPasswordRequired() {
        registerPage.enterPassword("");
        registerPage.enterConfirmPassword("Test123!"); // Blur le champ password

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour le mot de passe vide");
        assertTrue(error.contains("requis") || error.contains("required"),
                "Le message d'erreur devrait indiquer que le mot de passe est requis");
    }

    @Test
    @Order(9)
    @DisplayName("Test 9: Mot de passe trop court")
    public void testPasswordTooShort() {
        registerPage.enterPassword("short");
        registerPage.enterConfirmPassword("short"); // Blur le champ password

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un mot de passe trop court");
        assertTrue(error.contains("8 caractères") || error.contains("8 characters"),
                "Le message d'erreur devrait indiquer le minimum de 8 caractères");
    }

    @Test
    @Order(10)
    @DisplayName("Test 10: Mot de passe sans majuscule")
    public void testPasswordNoUppercase() {
        registerPage.enterPassword("lowercase123!");
        registerPage.enterConfirmPassword("lowercase123!"); // Blur le champ password

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un mot de passe sans majuscule");
        assertTrue(error.contains("majuscule") || error.contains("uppercase"),
                "Le message d'erreur devrait indiquer qu'une majuscule est requise");
    }

    @Test
    @Order(11)
    @DisplayName("Test 11: Mot de passe sans minuscule")
    public void testPasswordNoLowercase() {
        registerPage.enterPassword("UPPERCASE123!");
        registerPage.enterConfirmPassword("UPPERCASE123!"); // Blur le champ password

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un mot de passe sans minuscule");
        assertTrue(error.contains("minuscule") || error.contains("lowercase"),
                "Le message d'erreur devrait indiquer qu'une minuscule est requise");
    }

    @Test
    @Order(12)
    @DisplayName("Test 12: Mot de passe sans chiffre")
    public void testPasswordNoDigit() {
        registerPage.enterPassword("NoDigits!");
        registerPage.enterConfirmPassword("NoDigits!"); // Blur le champ password

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un mot de passe sans chiffre");
        assertTrue(error.contains("chiffre") || error.contains("digit") || error.contains("number"),
                "Le message d'erreur devrait indiquer qu'un chiffre est requis");
    }

    @Test
    @Order(13)
    @DisplayName("Test 13: Mot de passe sans caractère spécial")
    public void testPasswordNoSpecialChar() {
        registerPage.enterPassword("NoSpecial123");
        registerPage.enterConfirmPassword("NoSpecial123"); // Blur le champ password

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour un mot de passe sans caractère spécial");
        assertTrue(error.contains("spécial") || error.contains("special"),
                "Le message d'erreur devrait indiquer qu'un caractère spécial est requis");
    }

    // ==================== Tests de confirmation du mot de passe
    // ====================

    @Test
    @Order(14)
    @DisplayName("Test 14: Mots de passe ne correspondent pas")
    public void testPasswordMismatch() {
        registerPage.enterFullName("John Doe");
        registerPage.enterEmail("john@gmail.com");
        registerPage.enterPassword("Valid123!");
        registerPage.enterConfirmPassword("Different123!");

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String error = registerPage.getValidationError("Confirm Password*");
        assertNotNull(error, "Un message d'erreur devrait être affiché pour des mots de passe différents");
        assertTrue(error.contains("correspondent") || error.contains("match"),
                "Le message d'erreur devrait indiquer que les mots de passe ne correspondent pas");
    }

    // ==================== Tests de la checkbox des conditions ====================

    @Test
    @Order(15)
    @DisplayName("Test 15: Conditions non acceptées")
    public void testTermsNotAccepted() {
        registerPage.register("John Doe", "john@gmail.com", "Valid123!", "Valid123!", false);

        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        String snackbarMessage = registerPage.getSnackbarMessage();
        assertNotNull(snackbarMessage, "Un message d'erreur devrait être affiché pour les conditions non acceptées");
        assertTrue(snackbarMessage.contains("conditions") || snackbarMessage.contains("accepter"),
                "Le message devrait indiquer que les conditions doivent être acceptées");
    }

    @Test
    @Order(16)
    @DisplayName("Test 16: Inscription réussie avec toutes les validations")
    public void testSuccessfulRegistrationWithTerms() {
        registerPage.register("John Doe", "john.doe@gmail.com", "Valid123!", "Valid123!", true);

        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Vérifier qu'on a navigué vers la page de login après une inscription réussie
        Boolean isOnLoginPage = (Boolean) ((JavascriptExecutor) driver).executeScript(
                "const elements = Array.from(document.querySelectorAll('*'));" +
                        "return elements.some(el => el.textContent && el.textContent.includes('Welcome Back!'));");

        assertTrue(isOnLoginPage,
                "L'utilisateur devrait être redirigé vers la page de login après une inscription réussie");
    }

    @Test
    @Order(17)
    @DisplayName("Test 17: Inscription avec champs vides ne navigue pas")
    public void testRegistrationWithEmptyFieldsStaysOnPage() {
        registerPage.clickRegister();

        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Vérifier qu'on est toujours sur la page d'inscription
        assertTrue(registerPage.isPageLoaded(),
                "L'utilisateur devrait rester sur la page d'inscription si les champs sont vides");
    }
}
