# E-Commerce App

A multi-platform Flutter-based e-commerce application that allows users to browse products, add them to a cart, and place orders. The app supports Android, iOS, macOS, Linux, Windows, and web platforms.

---

## Features

- **Product Listing**: Browse a list of products with details such as name, price, and description.
- **Cart Management**: Add/remove items to/from the cart, update item quantities, and view the total price.
- **Order History**: View past orders with details of purchased items.
- **User Authentication**: Secure login and registration using email and password.
- **Backend Integration**: Real-time data synchronization with a backend server.
- **Multi-Platform Support**: Runs seamlessly on Android, iOS, macOS, Linux, Windows, and web.

---

## Installation

Follow these steps to set up and run the project locally:

1. **Clone the Repository**:
   Clone the repository to your local machine using the following command:
   ```bash
   git clone <https://github.com/MohamedOsmanX/Ecommerce-mobile-App>
   ```

2. **Navigate to the Project Directory**:
   Change to the project directory:
   ```bash
   cd ecommerce_app
   ```

3. **Install Dependencies**:
   Install the required Flutter dependencies:
   ```bash
   flutter pub get
   ```

4. **Set Up Environment Variables**:
   Create a `.env` file in the root directory and add the following variables:
   ```plaintext
   API_KEY=your_api_key
   DATABASE_URL=your_database_url
   ```

5. **Run the App**:
   Use the following command to run the app on your desired platform:
   ```bash
   flutter run
   ```

---

## Environment Variables

The app uses environment variables to store sensitive information. Create a `.env` file in the root directory and add the following variables:

```plaintext
API_KEY=your_api_key
DATABASE_URL=your_database_url
```

Make sure to replace `your_api_key` and `your_database_url` with your actual API key and database URL.

---

## Folder Structure

Here’s a brief overview of the project structure:

```
ecommerce_app/
├── android/          # Android-specific files
├── ios/              # iOS-specific files
├── lib/              # Main Flutter application code
│   ├── products/     # Product-related screens and logic
│   ├── cart/         # Cart-related screens and logic
│   ├ 
│   └── main.dart     # Entry point of the application
├── test/             # Unit and widget tests
├── pubspec.yaml      # Project dependencies and configurations
└── README.md         # Project documentation
```

---
