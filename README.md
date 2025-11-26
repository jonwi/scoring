# Fantasy Realms Scoring

This app can score a hand for fantasy realms. It includes both cards from the base game and the expansion.

## 🚀 Getting Started

This project is a starting point for a Flutter application.

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Android Studio or VS Code with Flutter extensions
* Java Development Kit (JDK) 17 (recommended for Android builds)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/yourusername/your-repo.git](https://github.com/yourusername/your-repo.git)
    cd your-repo
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```

---

## 📦 Building Releases (CI/CD)

This repository is configured with a GitHub Actions workflow located at `.github/workflows/release.yml`. This workflow automatically builds the Android APK and creates a GitHub Release.

### How to Trigger a Release

1.  **Commit your changes** to the main branch.
2.  **Create and push a version tag.** The workflow listens for tags starting with `v` (e.g., `v1.0.0`, `v1.0.1`).

    Run the following commands in your terminal:
    ```bash
    git tag v1.0.0
    git push origin v1.0.0
    ```

3.  **Monitor the Build:**
    * Go to the **Actions** tab in your GitHub repository.
    * Click on the running workflow to see progress.

4.  **Download the APK:**
    * Once the workflow finishes, go to the **Releases** section (usually on the right sidebar of the repo).
    * Download the `app-release.apk` from the latest release assets.

### Note on Signing
The automated build produces an APK. If you have not configured a keystore in `android/app/build.gradle`, the APK may be unsigned or signed with a debug key.

---

## ⚖️ Legal & Licensing

### Code License
The source code for this project is licensed under the **MIT License**.
You are free to use, modify, and distribute the code logic as long as the original copyright notice is included.

> **MIT License Summary:** Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.

### Assets & Media Disclaimer
**⚠️ Important:** The graphical assets, audio files, logos, and branding materials (collectively "Assets") contained within this repository are subject to the following terms:

1.  **Third-Party Assets:** Some assets (such as placeholder images, stock photos, or icons) may be the property of third parties and are included for demonstration purposes only. These assets retain the licensing terms of their respective owners.

2.  **Proprietary Rights:** Unless explicitly stated otherwise, all custom branding, logos, and original artwork associated with this application are the exclusive property of the project owners and **may not** be used for commercial purposes without prior written permission.

3.  **No Warranty:** All Assets are provided "AS IS", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement. In no event shall the authors or copyright holders be liable for any claim, damages, or other liability arising from the use of these Assets.
