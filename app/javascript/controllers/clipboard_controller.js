import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
    static targets = ["source", "button", "icon", "checkmark"];
    static classes = ["success", "disabled"];

    copy() {
        if (this.buttonTarget.disabled) return;

        const textToCopy = this.hasSourceTarget
            ? this.sourceTarget.value || this.sourceTarget.textContent
            : this.data.get("text");

        navigator.clipboard
            .writeText(textToCopy)
            .then(() => {
                this.showSuccess();
            })
            .catch((error) => {
                console.error("Failed to copy to clipboard:", error);
                this.fallbackCopy(textToCopy);
            });
    }

    showSuccess() {
        // Disable button
        this.buttonTarget.disabled = true;

        // Add success classes
        if (this.hasSuccessClass) {
            this.buttonTarget.classList.add(this.successClass);
        }

        if (this.hasDisabledClass) {
            this.buttonTarget.classList.add(this.disabledClass);
        }

        // Hide copy icon, show checkmark
        if (this.hasIconTarget) {
            this.iconTarget.classList.add("hidden");
        }

        if (this.hasCheckmarkTarget) {
            this.checkmarkTarget.classList.remove("hidden");
        }

        // Reset after 2 seconds
        setTimeout(() => {
            this.resetButton();
        }, 800);
    }

    resetButton() {
        // Re-enable button
        this.buttonTarget.disabled = false;

        // Remove success classes
        if (this.hasSuccessClass) {
            this.buttonTarget.classList.remove(this.successClass);
        }

        if (this.hasDisabledClass) {
            this.buttonTarget.classList.remove(this.disabledClass);
        }

        // Show copy icon, hide checkmark
        if (this.hasIconTarget) {
            this.iconTarget.classList.remove("hidden");
        }

        if (this.hasCheckmarkTarget) {
            this.checkmarkTarget.classList.add("hidden");
        }
    }

    fallbackCopy(text) {
        const textArea = document.createElement("textarea");
        textArea.value = text;
        document.body.appendChild(textArea);
        textArea.select();

        try {
            document.execCommand("copy");
            this.showSuccess();
        } catch (error) {
            console.error("Fallback copy failed:", error);
        }

        document.body.removeChild(textArea);
    }
}
