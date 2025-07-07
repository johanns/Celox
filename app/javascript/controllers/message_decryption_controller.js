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
        "loadingContainer"
    ];

    static values = {
        minLoadingTime: { type: Number, default: 600 },
        autoDecryptDelay: { type: Number, default: 100 },
        // Localized error messages
        decryptionFailedMessage: {
            type: String,
            default: "Failed to decrypt the message. The decryption key may be invalid or corrupted."
        }
    };

    connect() {
        console.log("MessageDecryptionController connected");
        this.scheduleAutoDecryption();
    }

    // Lifecycle Management
    scheduleAutoDecryption() {
        if (this.hasEncryptedDataTarget) {
            setTimeout(() => this.attemptDecryption(), this.autoDecryptDelayValue);
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

    // Main Decryption Flow
    async attemptDecryption() {
        const startTime = Date.now();

        try {
            const encryptionKey = this.retrieveEncryptionKey();

            if (!encryptionKey) {
                this.handleMissingKey(startTime);
                return;
            }

            await this.performDecryption(encryptionKey, startTime);
        } catch (error) {
            this.handleDecryptionError(error, startTime);
        }
    }

    handleMissingKey(startTime) {
        this.scheduleCallback(() => {
            this.hideLoadingState();
            this.showNoKeyAlert();
        }, startTime);
    }

    async performDecryption(encryptionKey, startTime) {
        const encryptedData = this.encryptedDataTarget.value;
        const decryptedMessage = await this.decryptMessage(encryptedData, encryptionKey);

        this.scheduleCallback(() => {
            this.hideLoadingState();
            this.showDecryptedMessage(decryptedMessage);
            this.cleanupEncryptionKey();
        }, startTime);
    }

    handleDecryptionError(error, startTime) {
        console.error("Decryption failed:", error);

        this.scheduleCallback(() => {
            this.hideLoadingState();
            this.showError(this.decryptionFailedMessageValue);
        }, startTime);
    }

    // Cryptographic Operations
    async decryptMessage(encryptedData, userKey) {
        const { salt, iv, encrypted } = CryptoUtils.parseEncryptedData(encryptedData);
        const cryptoKey = await CryptoUtils.deriveKey(userKey, salt);
        const decrypted = await CryptoUtils.performCryptoOperation("decrypt", cryptoKey, iv, encrypted);

        return new TextDecoder().decode(decrypted);
    }
}
