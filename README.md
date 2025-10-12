
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

Altroo was developed in **Swift**, using:

- **UIKit** – for building the user interface  
- **SwiftUI** – for modern screens and components  
- **Combine** – for reactive communication between layers  
- **Core Data** – for local persistence and offline functionality  
- **CloudKit** – for secure data synchronization and sharing  

---

## Application Architecture

Altroo follows the **MVVM-C (Model–View–ViewModel–Coordinator)** architecture, complemented by **Repository** and **Service** layers, ensuring separation of concerns, scalability, and maintainability.

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
ProjectName
├── Features
│   ├── Home
│   │   ├── Views
│   │   ├── ViewModels
│   │   ├── Models
│   │   ├── Coordinators
│   │   └── Factories
│   └── Login
│       ├── Views
│       ├── ViewModels
│       ├── Models
│       ├── Coordinators
│       └── Factories
│
├── Core
│   ├── Services
│   ├── Repository
│   └── Models
│
├── Shared
│   ├── Components
│   ├── Extensions
│   └── Utilities
│
└── Resources
    ├── Assets.xcassets
    ├── Colors.swift
    ├── Fonts
    └── Localizable.strings
````

---

## Installation & Execution

Clone the repository:

```bash
git clone https://github.com/your-username/altroo.git
cd altroo
```

Open the project in **Xcode**, install the required dependencies, and run it in the simulator or on a real device.

---

## License

This project is licensed under the **MIT License**.
See the [LICENSE](LICENSE) file for more details.
