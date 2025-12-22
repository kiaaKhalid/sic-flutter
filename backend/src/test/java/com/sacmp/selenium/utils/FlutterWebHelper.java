package com.sacmp.selenium.utils;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

/**
 * Helper class for interacting with Flutter Web applications using JavaScript.
 * Flutter Web doesn't generate a standard DOM accessible via XPath/CSS
 * selectors,
 * so we use JavaScript to interact with elements.
 */
public class FlutterWebHelper {

    private final WebDriver driver;
    private final JavascriptExecutor js;
    private final WebDriverWait wait;

    public FlutterWebHelper(WebDriver driver) {
        this.driver = driver;
        this.js = (JavascriptExecutor) driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(20));
    }

    /**
     * Wait for Flutter to finish loading
     */
    public void waitForFlutterLoad() {
        wait.until(driver1 -> {
            Object result = js.executeScript(
                    "return document.querySelector('flt-glass-pane') !== null || " +
                            "document.querySelector('canvas') !== null || " +
                            "document.body.textContent.length > 0;");
            return Boolean.TRUE.equals(result);
        });
    }

    /**
     * Click on an element containing specific text
     */
    public void clickElementWithText(String text) {
        js.executeScript(
                "const elements = Array.from(document.querySelectorAll('*'));" +
                        "const element = elements.find(el => el.textContent && el.textContent.trim() === arguments[0]);"
                        +
                        "if (element) { element.click(); }",
                text);
    }

    /**
     * Click on an element containing partial text
     */
    public void clickElementContainingText(String partialText) {
        js.executeScript(
                "const elements = Array.from(document.querySelectorAll('*'));" +
                        "const element = elements.find(el => el.textContent && el.textContent.includes(arguments[0]));"
                        +
                        "if (element) { element.click(); }",
                partialText);
    }

    /**
     * Type text into an input field by placeholder or aria-label
     */
    public void typeIntoField(String fieldIdentifier, String text) {
        js.executeScript(
                "const input = document.querySelector('input[placeholder*=\"' + arguments[0] + '\"]') || " +
                        "document.querySelector('input[aria-label*=\"' + arguments[0] + '\"]');" +
                        "if (input) { " +
                        "  input.value = arguments[1];" +
                        "  input.dispatchEvent(new Event('input', { bubbles: true }));" +
                        "  input.dispatchEvent(new Event('change', { bubbles: true }));" +
                        "}",
                fieldIdentifier, text);
    }

    /**
     * Check if text exists on the page
     */
    public boolean isTextPresent(String text) {
        Object result = js.executeScript(
                "const elements = Array.from(document.querySelectorAll('*'));" +
                        "return elements.some(el => el.textContent && el.textContent.includes(arguments[0]));",
                text);
        return Boolean.TRUE.equals(result);
    }

    /**
     * Get text content from an element containing specific text
     */
    public String getTextFromElement(String containingText) {
        Object result = js.executeScript(
                "const elements = Array.from(document.querySelectorAll('*'));" +
                        "const element = elements.find(el => el.textContent && el.textContent.includes(arguments[0]));"
                        +
                        "return element ? element.textContent : null;",
                containingText);
        return result != null ? result.toString() : null;
    }

    /**
     * Click a checkbox by its label text
     */
    public void clickCheckbox(String labelText) {
        js.executeScript(
                "const labels = Array.from(document.querySelectorAll('*'));" +
                        "const label = labels.find(el => el.textContent && el.textContent.includes(arguments[0]));" +
                        "if (label) {" +
                        "  const checkbox = label.querySelector('input[type=\"checkbox\"]') || " +
                        "                   document.querySelector('input[type=\"checkbox\"]');" +
                        "  if (checkbox) { checkbox.click(); }" +
                        "}",
                labelText);
    }

    /**
     * Wait for navigation by checking URL change
     */
    public void waitForNavigation(String expectedUrlPart) {
        wait.until(driver1 -> driver.getCurrentUrl().contains(expectedUrlPart));
    }

    /**
     * Wait for text to appear on page
     */
    public void waitForText(String text) {
        wait.until(driver1 -> {
            Object result = js.executeScript(
                    "const elements = Array.from(document.querySelectorAll('*'));" +
                            "return elements.some(el => el.textContent && el.textContent.includes(arguments[0]));",
                    text);
            return Boolean.TRUE.equals(result);
        });
    }

    /**
     * Scroll to element containing text
     */
    public void scrollToText(String text) {
        js.executeScript(
                "const elements = Array.from(document.querySelectorAll('*'));" +
                        "const element = elements.find(el => el.textContent && el.textContent.includes(arguments[0]));"
                        +
                        "if (element) { element.scrollIntoView({ behavior: 'smooth', block: 'center' }); }",
                text);
    }

    /**
     * Get current page title from Flutter app
     */
    public String getPageTitle() {
        Object result = js.executeScript(
                "const headers = Array.from(document.querySelectorAll('*'));" +
                        "const header = headers.find(el => " +
                        "  el.textContent && " +
                        "  (el.textContent.includes('Welcome') || " +
                        "   el.textContent.includes('Create') || " +
                        "   el.textContent.includes('Dashboard')));" +
                        "return header ? header.textContent : document.title;");
        return result != null ? result.toString() : driver.getTitle();
    }

    /**
     * Clear and type into a field
     */
    public void clearAndType(String fieldIdentifier, String text) {
        js.executeScript(
                "const input = document.querySelector('input[placeholder*=\"' + arguments[0] + '\"]') || " +
                        "document.querySelector('input[aria-label*=\"' + arguments[0] + '\"]');" +
                        "if (input) { " +
                        "  input.value = '';" +
                        "  input.value = arguments[1];" +
                        "  input.dispatchEvent(new Event('input', { bubbles: true }));" +
                        "  input.dispatchEvent(new Event('change', { bubbles: true }));" +
                        "  input.dispatchEvent(new Event('blur', { bubbles: true }));" +
                        "}",
                fieldIdentifier, text);
    }
}
