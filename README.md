# 💍 Rishta Biodata Maker 

### **A Modern Solution for Professional Profile Creation**

In many cultures, a "Biodata" is the first step in the matrimonial process. Often, people struggle with formatting, design, and ensuring all relevant details are included. **Rishta Biodata Maker** is a mobile solution built with Flutter that automates this process, allowing users to generate a polished, professional biodata card simply by answering a series of intuitive questions.

---

## 🚀 Features

- **Intuitive Question-Based UI:** No complex forms; a step-by-step wizard guides users through personal, educational, and family details.
- **Instant PDF/Image Generation:** Automatically converts user input into a beautifully formatted, shareable card.
- **Niche Localization:** Specifically tailored with fields relevant to local cultural and community requirements.
- **Dynamic Themes:** Multiple templates to choose from to match personal preferences.
- **Offline First:** Built for privacy and speed—all data processing happens locally on the device.

---

## 🛠️ Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (Cross-platform Android/iOS/Web)
- **Language:** Dart
- **State Management:** Riverpod (Architected for scalability)
- **Local Persistence:** Shared Preferences for draft saving.
- **Export Engines:** Implementation for PDF generation and Image rendering.

---

## 🏗️ Architecture & Logic

This project follows a clean architectural pattern to ensure that the UI logic is separated from the PDF generation engine. 

- **The Flow:** `User Input` ➔ `Logic Validation` ➔ `Template Mapping` ➔ `PDF/Image Export`.
- **Modularity:** The template engine is designed to be "pluggable," allowing for easy addition of new biodata designs without rewriting the core logic.

---

## 📱 How it Works

1. **Information Gathering:** User enters details regarding Education, Profession, Family background, and expectations.
2. **Template Selection:** Choose from a variety of professional layouts.
3. **Preview & Export:** View a real-time preview of the biodata and export it as a high-quality PDF or Image ready for WhatsApp/Email sharing.

---

## 🛠️ Installation & Setup

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/MuhammadAwaisGill/Rishta-Biodata-Maker.git](https://github.com/MuhammadAwaisGill/Rishta-Biodata-Maker.git)
