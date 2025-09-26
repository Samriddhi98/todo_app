#  Todo App

A **Flutter-based Todo application** built with **Clean Architecture** and **Bloc state management**.  
The app allows users to create, update, mark complete/incomplete, and organize tasks efficiently.  
Tasks can also be grouped by due dates (e.g., monthly) for better task management.

---

## Features
- Add new tasks with **title, description, priority, and due date**
- Mark tasks as **completed or incomplete**
- Update or delete existing tasks
- Group tasks by **due dates** (e.g., months)
- Local persistence using **Hive**
- Built with **Bloc** for predictable state management

---

## Project Structure (Clean Architecture)

```
lib/
├── core/                 # Shared utilities, constants, themes
├── features/
│   └── todo/
│       ├── data/         # Data layer (Hive, models, repositories)
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/       # Domain layer (Entities, UseCases, Repositories)
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       ├── presentation/ # Presentation layer (UI + Bloc)
│       │   ├── bloc/
│       │   ├── pages/
│       │   └── widgets/
├── main.dart             # Entry point
```

###  Layers Explained
- **Data Layer**
    - Responsible for Hive integration and mapping models.
    - Implements repository interfaces from the domain layer.

- **Domain Layer**
    - Contains pure business logic.
    - Defines `TodoEntity`, repository contracts, and use cases (e.g., `AddTodo`, `UpdateTodo`, `ToggleCompletion`).

- **Presentation Layer**
    - UI built with Flutter widgets.
    - Uses **Bloc** for state management.
    - Responds to domain changes and user input.

---

##  Tech Stack
- **Flutter** (Dart)
- **Bloc** (State Management)
- **Hive** (Local Storage)
- **Equatable** (Value Equality)
- **Intl** (Date formatting)

---

## Getting Started

### Prerequisites
- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Install [Dart](https://dart.dev/get-dart)
- Ensure you have an emulator or real device set up

### Steps to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/Samriddhi98/todo_app.git
   cd todo_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters :
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. Run the app:
   ```bash
   flutter run
   ```

---


## Future Enhancements
- Add calendar integration
- Add task categories/tags
- Sync tasks with cloud (Firebase)
- Notifications for due tasks

---

## License
This project is licensed under the MIT License.  
