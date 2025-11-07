
<img width="1920" height="370" alt="capa 1" src="https://github.com/user-attachments/assets/fc12384d-620c-48d8-a594-80e3d930b2b4" />
 
# Altroo
**Altroo** is an application designed for **professional caregivers**, aimed at efficiently organizing and sharing care activities performed with patients.  
It enhances communication between **caregivers, family members, and healthcare professionals**, offering centralized records and personalized reports.

---

## Table of Contents
- [Technologies Used](#technologies-used)
- [Features](#features)
- [Application Architecture](#application-architecture)
- [Folder Structure](#folder-structure)
- [Installation & Execution](#installation--execution)
- [Top Contributors](#top-contributors)
- [License](#license)

---

## Technologies Used

[![Swift](https://img.shields.io/badge/Swift-F05138?style=flat&logo=swift&logoColor=white)](#)
[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20iPadOS-white?style=flat&logo=apple&logoColor=white&labelColor=%23545454&color=%2311B8AD)](#)
[![Release](https://img.shields.io/badge/-v1.0.0-orange?style=flat&logo=version)](#)
[![iOS](https://img.shields.io/badge/-16.0%2B-white?style=flat&logo=ios&logoColor=white&labelColor=%23545454&color=%234D9AEC)](#)
[![License](https://img.shields.io/github/license/izamontenegro/Altroo)](#)
[![CI](https://img.shields.io/github/actions/workflow/status/izamontenegro/Altroo/pullRequest.yml?label=CI&logo=githubactions&logoColor=white)](#)
[![App Store](https://img.shields.io/badge/AppStore-Coming%20Soon-white?style=flat&logo=AppStore&logoColor=white&labelColor=%23545454&color=%2311B8AD)](#)

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

## Features

Altroo offers a range of functionalities designed to streamline caregiving:

<div align="center">

<table>
<tr>
<td align="center" valign="top" width="170" style="padding: 10px;">
  <img src="https://github.com/user-attachments/assets/b4169275-b7f4-4239-bed1-85c1908ae799" width="120"/><br><br>
  <b>Patient Management</b><br>
  Organize patient records efficiently and access history easily.
</td>

<td align="center" valign="top" width="170" style="padding: 10px;">
  <img src="https://github.com/user-attachments/assets/6d72930e-9492-4793-a5af-736c6cf54587" width="120"/><br><br>
  <b>Care Scheduling</b><br>
  Plan and track daily care activities with notifications.
</td>

<td align="center" valign="top" width="170" style="padding: 10px;">
  <img src="https://github.com/user-attachments/assets/d721300a-3dea-4ee9-bc09-580b5f1d5643" width="120"/><br><br>
  <b>Reports & Analytics</b><br>
  Generate personalized reports for patients and families.
</td>

<td align="center" valign="top" width="170" style="padding: 10px;">
  <img src="https://github.com/user-attachments/assets/b289ecf7-5bb6-4117-ac38-6488ce563820" width="120"/><br><br>
  <b>Cloud Sync</b><br>
  Securely synchronize data across multiple devices via CloudKit.
</td>

<td align="center" valign="top" width="170" style="padding: 10px;">
  <img src="https://github.com/user-attachments/assets/34575a7b-2fcc-4c37-82a5-ae6654a84be1" width="120"/><br><br>
  <b>Settings & Customization</b><br>
  Personalize the app to match your workflow and preferences.
</td>
</tr>
</table>

</div>

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
├── Resources
│   ├── Assets.xcassets
│   ├── Fonts
│   ├── Info.plist
│   └── Localizable.strings
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

## Top Contributors:

<a href="https://github.com/izamontenegro/Altroo/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=izamontenegro/Altroo&max=5&columns=5&bg=11B8AD&color=11B8AD" alt="Top Contributors" />
</a>


---

## License

This project is licensed under the **GPL-3.0 License**.
See the [LICENSE](LICENSE) file for more details.

<p align="center">
(<a href="#readme-top">back to top</a>)
</p>
