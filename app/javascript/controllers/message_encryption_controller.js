import { Controller } from "@hotwired/stimulus";

import { CRYPTO_CONFIG } from "crypto/config";
import { CryptoUtils } from "crypto/utils";

export default class extends Controller {
    static targets = [
        "body",
        "form",
        "expiration",
        "successView",
        "formView",
        "retrievalLink",
        "errorAlert",
        "errorList",
        "submitButton",
        "loadingButton",
        "charCount"
    ];

    static values = {
        minLoadingTime: { type: Number, default: 400 },
        keyLength: { type: Number, default: 12 },
        animationDuration: { type: Number, default: 800 }, // Fixed animation duration
        scrambleFrames: { type: Number, default: 12 }, // Fixed number of animation frames
        frameDelay: { type: Number, default: 50 }, // Delay between frames
        // Localized error messages
        encryptionFailedMessage: { type: String, default: "Encryption failed. Please try again." },
        connectionErrorMessage: {
            type: String,
            default: "Unable to connect to server. Please check your internet connection and try again."
        },
        serverErrorMessage: { type: String, default: "Server error occurred. Please try again later." },
        genericErrorMessage: {
            type: String,
            default: "Failed to submit message. Please check your connection and try again."
        },
        unexpectedErrorMessage: { type: String, default: "An unexpected error occurred. Please try again." }
    };

    connect() {
        console.log("MessageEncryptionController connected");
        this.updateCharacterCount();
    }

    // Target callbacks - automatically called when targets connect
    bodyTargetConnected() {
        this.bodyTarget.addEventListener("input", this.updateCharacterCount.bind(this));
        this.updateCharacterCount();
    }

    // Character count functionality
    updateCharacterCount() {
        if (this.hasCharCountTarget && this.hasBodyTarget) {
            const count = this.bodyTarget.value.length;
            this.charCountTarget.textContent = count.toLocaleString();

            // Optional: Add visual feedback for long messages
            this.applyCharacterCountStyling(count);
        }
    }

    applyCharacterCountStyling(count) {
        const charCountElement = this.charCountTarget;

        // Remove existing color classes
        charCountElement.classList.remove("text-warning", "text-error", "text-success");

        // Apply styling based on character count
        if (count === 0) {
            charCountElement.classList.add("text-base-content/50");
        } else if (count > 5000) {
            charCountElement.classList.add("text-error");
        } else if (count > 2000) {
            charCountElement.classList.add("text-warning");
        } else {
            charCountElement.classList.add("text-success");
        }
    }

    // UI State Management
    showLoadingState() {
        this.toggleFormControls(false);
        this.toggleButtons(true);
    }

    hideLoadingState() {
        this.toggleFormControls(true);
        this.toggleButtons(false);
    }

    toggleFormControls(enabled) {
        const opacity = enabled ? "1" : "0.5";
        const pointerEvents = enabled ? "auto" : "none";

        this.bodyTarget.disabled = !enabled;
        this.bodyTarget.style.opacity = opacity;
        this.expirationTarget.style.opacity = opacity;
        this.expirationTarget.style.pointerEvents = pointerEvents;
    }

    toggleButtons(showLoading) {
        this.submitButtonTarget.classList.toggle("hidden", showLoading);
        this.loadingButtonTarget.classList.toggle("hidden", !showLoading);
    }

    // Text Animation
    async animateTextReplacement(originalText, encryptedText) {
        if (originalText.length === 0) {
            this.bodyTarget.value = encryptedText;
            this.updateCharacterCount();
            return;
        }

        const totalFrames = this.scrambleFramesValue;
        const frameDelay = this.frameDelayValue;

        // Create animation frames with decreasing similarity to original text
        for (let frame = 0; frame < totalFrames; frame++) {
            const scrambledText = this.generateScrambledFrame(originalText, frame, totalFrames);
            this.bodyTarget.value = scrambledText;
            this.updateCharacterCount();

            await this.delay(frameDelay);
        }

        // Final frame shows encrypted text
        this.bodyTarget.value = encryptedText;
        this.updateCharacterCount();
    }

    generateScrambledFrame(originalText, currentFrame, totalFrames) {
        const progress = currentFrame / totalFrames;
        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

        return originalText
            .split("")
            .map((char) => {
                // Gradually replace more characters as animation progresses
                const shouldScramble = Math.random() < progress || char === " ";

                if (shouldScramble && char !== " ") {
                    return chars.charAt(Math.floor(Math.random() * chars.length));
                } else if (char === " ") {
                    // Preserve spaces for readability during animation
                    return " ";
                }

                return char;
            })
            .join("");
    }

    // Alternative: Simpler word-based scrambling with fixed timing
    async animateTextReplacementWordBased(originalText, encryptedText) {
        if (originalText.length === 0) {
            this.bodyTarget.value = encryptedText;
            this.updateCharacterCount();
            return;
        }

        const words = originalText.split(" ");
        const totalFrames = this.scrambleFramesValue;
        const frameDelay = this.frameDelayValue;

        for (let frame = 0; frame < totalFrames; frame++) {
            const progress = frame / totalFrames;

            const scrambledWords = words.map((word) => {
                // Gradually scramble more words as animation progresses
                const shouldScramble = Math.random() < progress;
                return shouldScramble ? this.generateRandomChars(word.length) : word;
            });

            this.bodyTarget.value = scrambledWords.join(" ");
            this.updateCharacterCount();

            await this.delay(frameDelay);
        }

        // Final scramble before showing encrypted text
        const finalScramble = words.map((word) => this.generateRandomChars(word.length));
        this.bodyTarget.value = finalScramble.join(" ");
        this.updateCharacterCount();

        await this.delay(frameDelay * 2); // Pause before final result

        this.bodyTarget.value = encryptedText;
        this.updateCharacterCount();
    }

    // Optimized version of existing methods
    generateRandomChars(length) {
        if (length === 0) return "";

        const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        return Array.from({ length }, () => chars[Math.floor(Math.random() * chars.length)]).join("");
    }

    delay(ms) {
        return new Promise((resolve) => setTimeout(resolve, ms));
    }

    // View Management
    showSuccessView(retrievalUrl, encryptionKey) {
        this.updateRetrievalLink(retrievalUrl, encryptionKey);
        this.switchToSuccessView();
    }

    updateRetrievalLink(retrievalUrl, encryptionKey) {
        if (this.hasRetrievalLinkTarget) {
            this.retrievalLinkTarget.value = `${retrievalUrl}#${encryptionKey}`;
        }
    }

    switchToSuccessView() {
        this.formViewTarget.classList.add("hidden");
        this.successViewTarget.classList.remove("hidden");
    }

    resetForm() {
        this.bodyTarget.value = "";
        if (this.hasExpirationTarget) {
            this.expirationTarget.selectedIndex = 0;
        }
        this.updateCharacterCount(); // Reset counter
        this.clearFieldErrors();
    }

    // Error Handling
    showErrors(errors) {
        this.clearErrors();
        this.populateErrorList(errors);
        this.errorAlertTarget.classList.remove("hidden");
    }

    populateErrorList(errors) {
        const errorList = this.errorListTarget;
        errors.forEach((error) => {
            const li = document.createElement("li");
            li.textContent = error;
            errorList.appendChild(li);
        });
    }

    clearErrors() {
        if (this.hasErrorListTarget) {
            this.errorListTarget.innerHTML = "";
        }
        if (this.hasErrorAlertTarget) {
            this.errorAlertTarget.classList.add("hidden");
        }
        this.clearFieldErrors();
    }

    clearFieldErrors() {
        this.bodyTarget.classList.remove("textarea-error");
        this.expirationTarget.classList.remove("select-error");
    }

    applyFieldErrors(errors) {
        if (typeof errors !== "object" || errors === null) return;

        if (errors.body) {
            this.bodyTarget.classList.add("textarea-error");
        }
        // Note: The model attribute is `expiration_duration`, which maps to the `expiration` target.
        if (errors.expiration_duration) {
            this.expirationTarget.classList.add("select-error");
        }
    }

    generateUserFriendlyErrorMessage(error) {
        if (error.message.includes("Failed to fetch")) {
            return this.connectionErrorMessageValue;
        }
        if (error.message.includes("HTTP")) {
            return this.serverErrorMessageValue;
        }
        return this.genericErrorMessageValue;
    }

    // Main form submission workflow
    async encryptAndSubmit() {
        const originalContent = this.bodyTarget.value.trim();

        this.clearErrors();

        try {
            this.showLoadingState();
            const startTime = Date.now();

            const { userKey, encrypted } = await this.encryptUserMessage(originalContent);
            const remainingTime = this.calculateRemainingLoadingTime(startTime);

            await this.submitEncryptedMessage(encrypted, userKey, originalContent, remainingTime);
        } catch (error) {
            this.handleEncryptionError(error, originalContent);
        }
    }

    async encryptUserMessage(plaintext) {
        const userKey = this.generateAlphanumericKey(this.keyLengthValue);

        // Use the new fixed-duration animation
        await this.animateTextReplacement(plaintext, "");
        const encrypted = await this.encryptMessage(plaintext, userKey);

        this.bodyTarget.value = encrypted;
        this.updateCharacterCount();

        return { userKey, encrypted };
    }

    calculateRemainingLoadingTime(startTime) {
        const elapsedTime = Date.now() - startTime;
        return Math.max(0, this.minLoadingTimeValue - elapsedTime);
    }

    async submitEncryptedMessage(encrypted, userKey, originalContent, delayTime) {
        const formData = this.prepareFormData(encrypted);

        setTimeout(async () => {
            try {
                const response = await this.makeApiRequest(formData);
                const data = await response.json();

                this.handleApiResponse(data, userKey, originalContent);
            } catch (error) {
                this.handleSubmissionError(error, originalContent);
            } finally {
                this.hideLoadingState();
            }
        }, delayTime);
    }

    prepareFormData(encrypted) {
        const formData = new FormData(this.formTarget);
        formData.set("message[body]", encrypted);
        return formData;
    }

    async makeApiRequest(formData) {
        const response = await fetch(this.formTarget.action, {
            method: "POST",
            body: formData,
            headers: {
                Accept: "application/json",
                "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
            }
        });

        if (!response.ok) {
            // Still throw for network or server errors, but let validation errors pass through
            if (response.status >= 500) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
        }

        return response;
    }

    handleApiResponse(data, userKey, originalContent) {
        if (data.success) {
            this.handleSuccessfulSubmission(data, userKey);
        } else {
            this.handleValidationErrors(data, originalContent);
        }
    }

    handleSuccessfulSubmission(data, userKey) {
        this.showSuccessView(data.message.retrieval_url, userKey);
        this.resetForm();
    }

    handleValidationErrors(data, originalContent) {
        this.bodyTarget.value = originalContent;
        this.updateCharacterCount(); // Update counter when restoring content

        const errorMessages = this.extractErrorMessages(data.errors);
        this.showErrors(errorMessages);
        this.applyFieldErrors(data.errors);
    }

    extractErrorMessages(errors) {
        if (Array.isArray(errors) && errors.length > 0) {
            return errors;
        }

        if (typeof errors === "object" && errors !== null) {
            const messages = Object.values(errors).flat();
            if (messages.length > 0) {
                return messages;
            }
        }

        return [this.unexpectedErrorMessageValue];
    }

    handleSubmissionError(error, originalContent) {
        this.bodyTarget.value = originalContent;
        this.updateCharacterCount(); // Update counter when restoring content

        const errorMessage = this.generateUserFriendlyErrorMessage(error);
        this.showErrors([errorMessage]);
    }

    handleEncryptionError(error, originalContent) {
        this.hideLoadingState();
        this.bodyTarget.value = originalContent;
        this.updateCharacterCount(); // Update counter when restoring content
        this.showErrors([this.encryptionFailedMessageValue]);
    }

    // Cryptography utilities
    generateAlphanumericKey(length) {
        return CryptoUtils.generateAlphanumericKey(length);
    }

    async encryptMessage(plaintext, userKey) {
        if (plaintext === "") {
            // Return empty string for empty plaintext to allow server-side validation
            return "";
        }

        const { IV_LENGTH, SALT_LENGTH } = CRYPTO_CONFIG;
        const iv = crypto.getRandomValues(new Uint8Array(IV_LENGTH));
        const salt = crypto.getRandomValues(new Uint8Array(SALT_LENGTH));
        const cryptoKey = await CryptoUtils.deriveKey(userKey, salt);

        const encrypted = await CryptoUtils.performCryptoOperation(
            "encrypt",
            cryptoKey,
            iv,
            new TextEncoder().encode(plaintext)
        );

        return CryptoUtils.combineEncryptionData(salt, iv, encrypted);
    }
}
