module.exports = {
    env: {
        browser: true,
        es6: true
    },
    extends: [
        "airbnb",
        "eslint:recommended",
        "plugin:react/recommended",
        "plugin:prettier/recommended",
        "plugin:@typescript-eslint/eslint-recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:@typescript-eslint/recommended-requiring-type-checking",
        "prettier/react",
        "prettier/@typescript-eslint"
    ],
    globals: {
        Atomics: "readonly",
        SharedArrayBuffer: "readonly"
    },
    parser: "@typescript-eslint/parser",
    parserOptions: {
        ecmaFeatures: {
            jsx: true
        },
        ecmaVersion: 2018,
        project: "./tsconfig.json",
        sourceType: "module"
    },
    plugins: ["@typescript-eslint", "prettier", "react", "react-hooks"],
    rules: {
        "import/default": "error",
        "import/export": "error",
        "import/extensions": "off",
        "import/no-unresolved": "warn",
        "import/named": "error",
        "import/namespace": "error",
        "prettier/prettier": "error",
        "react/forbid-prop-types": "warn",
        "react/jsx-filename-extension": ["warn", { extensions: [".jsx", ".tsx"] }],
        "react-hooks/rules-of-hooks": "error",
        "react-hooks/exhaustive-deps": "warn",
        "spaced-comment": "off",
    },
    settings: {
        "import/resolver": {
            "webpack": {
                config: {
                    resolve: {
                        extensions: [".js", ".jsx", ".scss", ".ts", ".tsx"]
                    }
                }
            }
        },
        indent: ["error", 4],
        "react/jsx-indent": ["error", 4],
        "react/jsx-indent-props": ["error", 4]
    }
};
