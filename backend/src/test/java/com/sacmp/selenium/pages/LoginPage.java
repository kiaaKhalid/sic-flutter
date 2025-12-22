package com.sacmp.selenium.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public class LoginPage extends BasePage {

    // Sélecteurs spécifiques pour Flutter Web avec sémantique
    private final By emailField = By.xpath("//input[@aria-label='Email address*' or @type='email']");
    private final By passwordField = By.xpath("//input[@aria-label='Password*' or @type='password']");
    private final By signInButton = By.xpath("//flt-semantics[@role='button' and contains(text(), 'Sign In')]");
    private final By welcomeMessage = By.xpath("//span[contains(text(), 'Welcome Back!')]");
    private final By errorMessage = By.xpath(
            "//*[contains(@class, 'snackbar') or contains(@class, 'error') or contains(text(), 'Error') or contains(text(), 'error')]");

    public LoginPage(WebDriver driver, String baseUrl) {
        super(driver, baseUrl);
    }

    @Override
    public String getPageUrl() {
        return "/";
    }

    public boolean isPageLoaded() {
        try {
            return wait.until(ExpectedConditions.presenceOfElementLocated(welcomeMessage)) != null;
        } catch (Exception e) {
            System.out.println("Welcome message not found: " + e.getMessage());
            return false;
        }
    }

    public void enterEmail(String email) {
        WebElement emailElement = wait.until(ExpectedConditions.elementToBeClickable(emailField));
        emailElement.clear();
        emailElement.click();
        try {
            Thread.sleep(500); // Petit délai pour que Flutter soit prêt
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
            Thread.sleep(500); // Petit délai pour que Flutter soit prêt
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        passwordElement.sendKeys(password);
    }

    public void clickLogin() {
        WebElement loginBtn = wait.until(ExpectedConditions.elementToBeClickable(signInButton));
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", loginBtn);
    }

    public void login(String email, String password) {
        enterEmail(email);
        enterPassword(password);
        clickLogin();
    }

    public String getErrorMessage() {
        try {
            WebElement error = wait.until(ExpectedConditions.presenceOfElementLocated(errorMessage));
            return error.getText();
        } catch (Exception e) {
            return "No error message found";
        }
    }
}