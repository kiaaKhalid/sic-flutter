package com.sacmp.selenium.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public abstract class BasePage {
    protected final WebDriver driver;
    protected final WebDriverWait wait;
    protected final String baseUrl;
    
    public BasePage(WebDriver driver, String baseUrl) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(20));
        this.baseUrl = baseUrl.endsWith("/") ? 
                      baseUrl.substring(0, baseUrl.length() - 1) : 
                      baseUrl;
    }
    
    public abstract String getPageUrl();
    
    public void navigateTo() {
        driver.get(baseUrl + getPageUrl());
    }
}