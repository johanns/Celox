// Shared cryptographic configuration and utilities
export const CRYPTO_CONFIG = {
    SALT_LENGTH: 16,
    IV_LENGTH: 12,
    PBKDF2_ITERATIONS: 1000,
    ALGORITHM: "AES-GCM",
    KEY_LENGTH: 256,
    HASH: "SHA-256"
};
