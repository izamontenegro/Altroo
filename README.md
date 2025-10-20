
<img width="1920" height="370" alt="capa 1" src="https://github.com/user-attachments/assets/fc12384d-620c-48d8-a594-80e3d930b2b4" />

# Altroo
**Altroo** is an application designed for **professional caregivers**, aimed at efficiently organizing and sharing care activities performed with patients.  
It enhances communication between **caregivers, family members, and healthcare professionals**, offering centralized records and personalized reports.

---

## Table of Contents
- [Technologies Used](#technologies-used)
- [Application Architecture](#application-architecture)
- [Folder Structure](#folder-structure)
- [Installation & Execution](#installation--execution)
- [License](#license)

---

## Technologies Used

![Swift](https://img.shields.io/badge/Swift-F05138?style=flat&logo=swift&logoColor=white)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?logo=github-actions&logoColor=white)](#)
[![iCloud](https://img.shields.io/badge/iCloud-3693F3?logo=icloud&logoColor=fff)](#)
![License](https://img.shields.io/github/license/izamontenegro/Altroo)

Altroo was developed in **Swift**, using:

- **UIKit** – for building the user interface  
- **SwiftUI** – for modern screens and components  
- **Combine** – for reactive communication between layers  
- **Core Data** – for local persistence and offline functionality  
- **CloudKit** – for secure data synchronization and sharing
- **XCTest** – for unit, integration, and UI testing to ensure stability and prevent regressions
- **Fastlane** – automates build, testing, and deployment pipelines
- **GitHub Actions** – onfigured for Continuous Integration (CI), running automated tests on pull requests targeting the develop branch to maintain code stability.

---

## Application Architecture

Altroo follows the **MVVM-C (Model–View–ViewModel–Coordinator)** architecture, complemented by **Repository**, **Facades** and **Service** layers, ensuring separation of concerns, scalability, and maintainability.

### Layers
- **Coordinator** – Manages navigation between screens.  
- **Factory** – Creates and configures instances of ViewModels and Views.  
- **View** – Interfaces built with UIKit and SwiftUI.  
- **ViewModel** – Acts as the intermediary between View and Service/Model.  
- **Service** – Contains business logic, handles persistence, and manages Core Data/CloudKit operations.  
- **Repository** – Provides predefined static data (symptoms, activities, diseases).  
- **Model** – Represents entities and business rules (patients, symptoms, medications).  

---

## Folder Structure

```bash
Altroo
├── App
│   ├── AppCoordinator
│   ├── AppDelegate
│   ├── DefaultAppFactory
│   └── SceneDelegate
│
├── Core
│   └── Models
│       ├── Enums
│       ├── Extensions
│       └── AltrooDataModel
│
├── Features
│   ├── AllPatient
│   │   ├── Coordinators
│   │   └── Views
│   │
│   ├── Main
│   │   ├── Coordinators
│   │   ├── Analysis
│   │   ├── History
│   │   ├── Settings
│   │   └── Today
│   │
│   └── Onboarding
│       ├── Coordinators
│       └── Views
│
├── Shared
│   ├── Components
│   ├── Services
│   ├── Protocols
│   ├── Utilities
│   └── Extensions
│
└── Resources
    ├── Assets.xcassets
    ├── Fonts
    ├── Info.plist
    └── Localizable.strings
│
AltrooTests
└── Tests
````

---

## Installation & Execution

Clone the repository:

```bash
git clone git@github.com:izamontenegro/Altroo.git
cd Altroo
```

Open the project in **Xcode**, install the required dependencies, and run it in the simulator or on a real device.

---

## License

This project is licensed under the **GPL-3.0 License**.
See the [LICENSE](LICENSE) file for more details.
