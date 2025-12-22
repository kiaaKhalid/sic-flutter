package com.sacmp.selenium.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public class RegisterPage {
    private final WebDriver driver;
    private final WebDriverWait wait;
    private final String baseUrl;

    // Sélecteurs
    private final By pageTitle = By.xpath("//span[text()='Create Your Account']");
    private final By fullNameField = By.xpath("//input[@aria-label='Full Name*' or @aria-label='Full Name']");
    private final By emailField = By.xpath("//input[@aria-label='Email address*' or @aria-label='Email']");
    private final By passwordField = By.xpath("//input[@aria-label='Password*'][1]");
    private final By confirmPasswordField = By
            .xpath("//input[@aria-label='Confirm Password*' or @aria-label='Confirm Password']");
    private final By registerButton = By.xpath("//flt-semantics[@role='button' and contains(text(), 'Register')]");
    private final By signInLink = By.xpath("//*[contains(text(), 'Sign in')]");
    private final By errorMessage = By.xpath("//*[contains(@class, 'error') or contains(text(), 'Error')]");
    private final By termsCheckbox = By
            .xpath("//input[@type='checkbox' and @aria-label='Accept Terms and Conditions']");
    private final By snackbar = By
            .xpath("//*[contains(@class, 'SnackBar') or contains(text(), 'accepter les conditions')]");

    public RegisterPage(WebDriver driver, String baseUrl) {
        this.driver = driver;
        this.baseUrl = baseUrl + "/register";
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(20));
    }

    public void navigateTo() {
        driver.get(baseUrl);
    }

    public boolean isPageLoaded() {
        try {
            wait.until(ExpectedConditions.presenceOfElementLocated(pageTitle));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public void enterFullName(String fullName) {
        WebElement nameElement = wait.until(ExpectedConditions.elementToBeClickable(fullNameField));
        nameElement.clear();
        nameElement.click();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        nameElement.sendKeys(fullName);
    }

    public void enterEmail(String email) {
        WebElement emailElement = wait.until(ExpectedConditions.elementToBeClickable(emailField));
        emailElement.clear();
        emailElement.click();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        emailElement.sendKeys(email);
    }

    public void enterPassword(String password) {
        WebElement passwordElement = wait.until(ExpectedConditions.elementToBeClickable(passwordField));
        passwordElement.clear();
        passwordElement.click();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        passwordElement.sendKeys(password);
    }

    public void enterConfirmPassword(String confirmPassword) {
        WebElement confirmElement = wait.until(ExpectedConditions.elementToBeClickable(confirmPasswordField));
        confirmElement.clear();
        confirmElement.click();
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        confirmElement.sendKeys(confirmPassword);
    }

    public void clickRegister() {
        WebElement registerBtn = wait.until(ExpectedConditions.elementToBeClickable(registerButton));
        registerBtn.click();
    }

    public void register(String fullName, String email, String password, String confirmPassword) {
        enterFullName(fullName);
        enterEmail(email);
        enterPassword(password);
        enterConfirmPassword(confirmPassword);
        clickRegister();
    }

    public void clickSignInLink() {
        WebElement signIn = wait.until(ExpectedConditions.elementToBeClickable(signInLink));
        signIn.click();
    }

    public String getErrorMessage() {
        try {
            WebElement error = wait.until(ExpectedConditions.presenceOfElementLocated(errorMessage));
            return error.getText();
        } catch (Exception e) {
            return "No error message found";
        }
    }

    public void clickTermsCheckbox() {
        try {
            WebElement checkbox = wait.until(ExpectedConditions.elementToBeClickable(termsCheckbox));
            checkbox.click();
            Thread.sleep(500);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }

    public boolean isTermsCheckboxChecked() {
        try {
            WebElement checkbox = wait.until(ExpectedConditions.presenceOfElementLocated(termsCheckbox));
            return checkbox.isSelected();
        } catch (Exception e) {
            return false;
        }
    }

    public String getValidationError(String fieldLabel) {
        try {
            // Chercher le message d'erreur sous le champ spécifié
            By errorLocator = By.xpath(
                    "//input[@aria-label='" + fieldLabel
                            + "']/following-sibling::*[contains(@class, 'error') or contains(text(), 'requis') or contains(text(), 'invalide') or contains(text(), 'caractères') or contains(text(), 'correspondent')]");
            WebElement error = wait.until(ExpectedConditions.presenceOfElementLocated(errorLocator));
            return error.getText();
        } catch (Exception e) {
            // Essayer une approche alternative avec les éléments sémantiques Flutter
            try {
                By alternativeLocator = By.xpath(
                        "//flt-semantics[contains(text(), '" + fieldLabel
                                + "')]/following-sibling::flt-semantics[contains(@class, 'error') or @role='alert']");
                WebElement error = driver.findElement(alternativeLocator);
                return error.getText();
            } catch (Exception ex) {
                return null;
            }
        }
    }

    public boolean hasValidationError(String fieldLabel) {
        return getValidationError(fieldLabel) != null;
    }

    public String getSnackbarMessage() {
        try {
            WebElement snackbarElement = wait.until(ExpectedConditions.presenceOfElementLocated(snackbar));
            return snackbarElement.getText();
        } catch (Exception e) {
            // Essayer de trouver n'importe quel élément contenant un message d'erreur de
            // conditions
            try {
                By alternativeSnackbar = By.xpath("//*[contains(text(), 'conditions')]");
                WebElement snackbarAlt = wait.until(ExpectedConditions.presenceOfElementLocated(alternativeSnackbar));
                return snackbarAlt.getText();
            } catch (Exception ex) {
                return null;
            }
        }
    }

    public void register(String fullName, String email, String password, String confirmPassword, boolean acceptTerms) {
        enterFullName(fullName);
        enterEmail(email);
        enterPassword(password);
        enterConfirmPassword(confirmPassword);
        if (acceptTerms) {
            clickTermsCheckbox();
        }
        clickRegister();
    }
}
