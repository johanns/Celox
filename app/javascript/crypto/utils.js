import { CRYPTO_CONFIG } from "crypto/config";

export class CryptoUtils {
    static generateAlphanumericKey(length) {
        const charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        return Array.from({ length }, () => charset[Math.floor(Math.random() * charset.length)]).join("");
    }

    static decodeBase64ToUint8Array(base64String) {
        return new Uint8Array(
            atob(base64String)
                .split("")
                .map((char) => char.charCodeAt(0))
        );
    }

    static combineEncryptionData(salt, iv, encrypted) {
        const combined = new Uint8Array(salt.length + iv.length + encrypted.byteLength);
        combined.set(salt);
        combined.set(iv, salt.length);
        combined.set(new Uint8Array(encrypted), salt.length + iv.length);

        return btoa(String.fromCharCode(...combined));
    }

    static parseEncryptedData(encryptedData) {
        const combined = this.decodeBase64ToUint8Array(encryptedData);
        const { SALT_LENGTH, IV_LENGTH } = CRYPTO_CONFIG;

        return {
            salt: combined.slice(0, SALT_LENGTH),
            iv: combined.slice(SALT_LENGTH, SALT_LENGTH + IV_LENGTH),
            encrypted: combined.slice(SALT_LENGTH + IV_LENGTH)
        };
    }

    static async importKeyMaterial(userKey) {
        return crypto.subtle.importKey("raw", new TextEncoder().encode(userKey), { name: "PBKDF2" }, false, [
            "deriveBits",
            "deriveKey"
        ]);
    }

    static async deriveKeyFromMaterial(keyMaterial, salt) {
        const { PBKDF2_ITERATIONS, HASH, ALGORITHM, KEY_LENGTH } = CRYPTO_CONFIG;

        return crypto.subtle.deriveKey(
            {
                name: "PBKDF2",
                salt,
                iterations: PBKDF2_ITERATIONS,
                hash: HASH
            },
            keyMaterial,
            { name: ALGORITHM, length: KEY_LENGTH },
            false,
            ["encrypt", "decrypt"]
        );
    }

    static async deriveKey(userKey, salt) {
        const keyMaterial = await this.importKeyMaterial(userKey);
        return this.deriveKeyFromMaterial(keyMaterial, salt);
    }

    static async performCryptoOperation(operation, cryptoKey, iv, data) {
        const { ALGORITHM } = CRYPTO_CONFIG;

        return crypto.subtle[operation]({ name: ALGORITHM, iv }, cryptoKey, data);
    }
}
