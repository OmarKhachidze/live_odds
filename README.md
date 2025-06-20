# 📊 Live Odds – Real-time Sports Betting Odds Tracker

Live Odds is a Flutter application that tracks and displays real-time sports betting odds using a responsive data grid. It leverages modern Flutter development practices, clean architecture principles, and real-time updates through WebSocket streams with efficient pagination support.

---

## 🧠 Architecture

This project follows **Clean Architecture** principles, promoting a separation of concerns and scalable structure:

- **Presentation Layer:** Flutter UI components powered by `Provider` for state management.
- **Domain Layer:** Entities and business logic, decoupled from the data source.
- **Data Layer:** Local persistence via `Hive`, live updates via WebSocket streams, and paginated data loading.
- **Core Layer:** Shared constants, utilities, and extensions.

Pagination is integrated into the Syncfusion `DataGrid`, loading more rows on demand as the user scrolls, improving performance with large datasets.

---

## 🔧 Tech Stack & Libraries

- **Flutter** – UI framework
- **Provider** – Lightweight and efficient state management
- **Syncfusion Flutter DataGrid** – Rich, responsive tabular UI with built-in pagination
- **Hive** – Local data persistence for offline caching
- **Intl** – For date/time formatting and localization
- **WebSockets** – Stream-based real-time odds updates
- **Clean Architecture** – Separation of concerns into Presentation, Domain, Data layers

---

## 💡 Key Decisions & Optimizations

- **State Management with Provider**  
  Chosen for simplicity and ease of integration with `ChangeNotifier`, especially suitable for moderately complex UIs.

- **WebSocket Streams for Odds Updates**  
  Live match odds are streamed and diffed efficiently to reflect only changed values, which are visually highlighted in the DataGrid.

- **Paginated Data Loading**  
  Instead of loading all data at once, rows are loaded page-by-page as needed, using the `handleLoadMoreRows` feature in Syncfusion DataGrid. This significantly reduces memory usage and improves performance with large lists.

- **Optimized DataGrid Rendering**  
  Only rows with changed values are rebuilt, reducing unnecessary UI repaints.

- **Visual Feedback on Change**  
  Odds updates are highlighted (e.g., green for increase, red for decrease) to help users track changes instantly.

---

## ▶️ App Demo

> 📽️ [Watch the Demo](assets/demo.gif)
> A quick walkthrough showing real-time odds updates, pagination, sorting, and responsive UI.

---

## 🚀 Getting Started

### 1. Clone the Repo
```bash
git clone https://github.com/your-username/live-odds-app.git
cd live-odds-app
flutter run (Make sure you have a device/emulator connected)
