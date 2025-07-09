import { Controller } from "@hotwired/stimulus";

import { CryptoUtils } from "crypto/utils";

export default class extends Controller {
    static targets = [
        "encryptedData",
        "errorAlert",
        "errorMessage",
        "messageContainer",
        "decryptedMessage",
        "noKeyAlert",
        "loadingContainer",
        "challengeForm",
        "challengeAnswer"
    ];

    static values = {
        minLoadingTime: { type: Number, default: 600 },
        autoDecryptDelay: { type: Number, default: 100 },
        fetchUrl: String,
        // Localized error messages (passed from Rails view)
        decryptionFailedMessage: String,
        challengeMissingAnswerMessage: String,
        challengeMissingKeyMessage: String,
        challengeVerificationFailedMessage: String,
        challengeNetworkErrorMessage: String
    };

    connect() {
        console.log("MessageDecryptionController connected");
        this.showChallengeForm();
    }

    // Lifecycle Management
    showChallengeForm() {
        this.hideLoadingState();
        if (this.hasChallengeFormTarget) {
            this.challengeFormTarget.classList.remove("hidden");
        }
        // Clear any previous answer
        if (this.hasChallengeAnswerTarget) {
            this.challengeAnswerTarget.value = "";
            this.challengeAnswerTarget.focus();
        }
    }

    // UI State Management
    hideLoadingState() {
        if (this.hasLoadingContainerTarget) {
            this.loadingContainerTarget.classList.add("hidden");
        }
    }

    showError(message) {
        this.errorMessageTarget.textContent = message;
        this.errorAlertTarget.classList.remove("hidden");
    }

    hideError() {
        this.errorAlertTarget.classList.add("hidden");
        this.errorMessageTarget.textContent = "";
    }

    showDecryptedMessage(decryptedText) {
        this.decryptedMessageTarget.value = decryptedText;
        this.messageContainerTarget.classList.remove("hidden");
    }

    showNoKeyAlert() {
        this.noKeyAlertTarget.classList.remove("hidden");
    }

    // Key Management
    retrieveEncryptionKey() {
        return sessionStorage.getItem("encryptionKey") || this.extractKeyFromUrlFragment();
    }

    extractKeyFromUrlFragment() {
        const fragment = window.location.hash.substring(1);
        return fragment || null;
    }

    cleanupEncryptionKey() {
        sessionStorage.removeItem("encryptionKey");
    }

    // Timing Utilities
    calculateRemainingLoadingTime(startTime) {
        const elapsed = Date.now() - startTime;
        return Math.max(0, this.minLoadingTimeValue - elapsed);
    }

    scheduleCallback(callback, startTime) {
        const delay = this.calculateRemainingLoadingTime(startTime);
        setTimeout(callback, delay);
    }

    handleEnterKey(event) {
        if (event.key === "Enter") {
            event.preventDefault();
            this.verifyChallengeAndDecrypt();
        }
    }

    // Challenge Verification Flow
    async verifyChallengeAndDecrypt() {
        const answer = this.challengeAnswerTarget.value;
        const encryptionKey = this.retrieveEncryptionKey();

        if (!answer) {
            this.showError(this.challengeMissingAnswerMessageValue);
            return;
        }

        if (!encryptionKey) {
            this.showError(this.challengeMissingKeyMessageValue);
            return;
        }

        // Hide any previous errors and the challenge form
        this.hideError();
        this.hideChallengeForm();
        this.showLoadingState();

        const startTime = Date.now();

        try {
            const response = await fetch(this.fetchUrlValue, {
                headers: {
                    "X-Challenge-Answer": answer,
                    Accept: "application/json"
                }
            });

            const data = await response.json();

            if (data.success) {
                // Challenge verified successfully, now attempt decryption
                await this.handleSuccessfulChallenge(encryptionKey, data.body, startTime);
            } else {
                // Use server error message if available, fallback to local message
                const errorMessage = data.error || this.challengeVerificationFailedMessageValue;
                this.handleChallengeError(errorMessage, startTime);
            }
        } catch {
            this.handleChallengeError(this.challengeNetworkErrorMessageValue, startTime);
        }
    }

    async handleSuccessfulChallenge(encryptionKey, encryptedData, startTime) {
        try {
            const decryptedMessage = await this.decryptMessage(encryptedData, encryptionKey);

            this.scheduleCallback(() => {
                this.hideLoadingState();
                this.showDecryptedMessage(decryptedMessage);
                this.cleanupEncryptionKey();
            }, startTime);
        } catch (error) {
            console.error("Decryption failed:", error);

            this.scheduleCallback(() => {
                this.hideLoadingState();
                this.showError(this.decryptionFailedMessageValue);
            }, startTime);
        }
    }

    hideChallengeForm() {
        if (this.hasChallengeFormTarget) {
            this.challengeFormTarget.classList.add("hidden");
        }
    }

    showLoadingState() {
        if (this.hasLoadingContainerTarget) {
            this.loadingContainerTarget.classList.remove("hidden");
        }
    }

    handleChallengeError(message, startTime) {
        this.scheduleCallback(() => {
            this.hideLoadingState();
            this.showChallengeForm();
            this.showError(message);
        }, startTime);
    }

    // Legacy methods for backward compatibility
    handleMissingKey(startTime) {
        this.scheduleCallback(() => {
            this.hideLoadingState();
            this.showNoKeyAlert();
        }, startTime);
    }

    async attemptDecryption() {
        const startTime = Date.now();

        try {
            const encryptionKey = this.retrieveEncryptionKey();

            if (!encryptionKey) {
                this.handleMissingKey(startTime);
                return;
            }

            const encryptedData = this.encryptedDataTarget.value;
            const decryptedMessage = await this.decryptMessage(encryptedData, encryptionKey);

            this.scheduleCallback(() => {
                this.hideLoadingState();
                this.showDecryptedMessage(decryptedMessage);
                this.cleanupEncryptionKey();
            }, startTime);
        } catch (error) {
            console.error("Decryption failed:", error);

            this.scheduleCallback(() => {
                this.hideLoadingState();
                this.showError(this.decryptionFailedMessageValue);
            }, startTime);
        }
    }

    // Cryptographic Operations
    async decryptMessage(encryptedData, userKey) {
        const { salt, iv, encrypted } = CryptoUtils.parseEncryptedData(encryptedData);
        const cryptoKey = await CryptoUtils.deriveKey(userKey, salt);
        const decrypted = await CryptoUtils.performCryptoOperation("decrypt", cryptoKey, iv, encrypted);

        return new TextDecoder().decode(decrypted);
    }
}
