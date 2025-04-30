# E-Commerce App

A Flutter e-commerce application with authentication, product management, and shopping cart functionality.

## Features

<<<<<<< HEAD
### Authentication
- User login and registration
- Role-based authorization (Customer, Seller, Admin)
- JWT token authentication
- Secure password handling
=======
- **Product Listing**: Browse a list of products with details such as name, price, and description.
- **Cart Management**: Add/remove items to/from the cart, update item quantities, and view the total price.
- **User Authentication**: Secure login and registration using email and password.
- **Backend Integration**: Real-time data synchronization with a backend server.
- **Multi-Platform Support**: Runs seamlessly on Android, iOS, macOS, Linux, Windows, and web.

### Product Management 
- Infinite scroll pagination for product listing
- Product details view with hero animations
- Product cards with stock status indicators
- Image handling with error fallbacks
- Category-based organization

### Shopping Cart
- Add/remove products
- Quantity management
- Real-time price calculations
- Cart persistence

### Profile Management
- User profile display
- Role-based access control
- Logout functionality

## Technical Implementation

### State Management
- BLoC pattern for state management
- Event-driven architecture
- Separation of concerns

### API Integration
- RESTful API consumption
- Paginated data fetching
- Token-based authentication
- Error handling

### UI/UX
- Material Design components
- Custom animations
- Responsive layouts
- Error states handling
- Loading indicators


## Setup Instructions

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Configure API endpoint in `lib/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  static const String baseUrl = 'your-api-url';
}
```

4. Set Up Environment Variables: Create a `.env` file in the root directory and add the following variables:
```bash
API_KEY=your_api_key
DATABASE_URL=your_database_url
```

5. Run the app:
```bash
flutter run
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.0
  http: ^1.1.0
  infinite_scroll_pagination: ^4.0.0
```

## Project Structure

```
lib/
├── auth/
│   ├── blocs/
│   ├── models/
│   ├── screens/
│   └── services/
├── products/
│   ├── blocs/
│   ├── models/
│   ├── screens/
│   └── services/
├── cart/
│   ├── blocs/
│   ├── models/
│   └── services/
├── profile/
│   └── screens/
└── core/
    ├── constants/
    ├── enums/
    └── services/
```

## Recent Updates

- Added infinite scroll pagination for products
- Implemented role-based authorization
- Added product image handling with error states
- Improved error handling and logging
- Added pull-to-refresh functionality
- Updated user role management
- Enhanced API integration with pagination support
- Added detailed logging for debugging
