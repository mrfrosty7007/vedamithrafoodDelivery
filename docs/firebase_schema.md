# Firebase Database Schema

## Collections

### `users`
| Field | Type | Description |
|---|---|---|
| `uid` | string | Firebase Auth UID (document ID) |
| `phone` | string | Phone number |
| `name` | string | Display name |
| `role` | string | `customer` or `owner` |
| `createdAt` | timestamp | Account creation time |

### `restaurant` (single document: `main_restaurant`)
| Field | Type | Description |
|---|---|---|
| `name` | string | Restaurant name |
| `isOpen` | boolean | Open/close toggle |
| `ownerId` | string | Owner's UID |
| `address` | string | Restaurant address |
| `createdAt` | timestamp | Creation time |

### `menu_items`
| Field | Type | Description |
|---|---|---|
| `id` | string | Auto-generated UUID (document ID) |
| `name` | string | Item name |
| `description` | string | Item description |
| `price` | number | Price in INR |
| `category` | string | Category name |
| `imageUrl` | string | Image URL (optional) |
| `isAvailable` | boolean | Availability flag |
| `createdAt` | timestamp | Creation time |

### `orders`
| Field | Type | Description |
|---|---|---|
| `id` | string | UUID (document ID) |
| `customerId` | string | Customer UID |
| `customerName` | string | Customer display name |
| `customerPhone` | string | Customer phone |
| `items` | array | `[{ menuItemId, name, price, quantity, totalPrice }]` |
| `totalAmount` | number | Order total in INR |
| `paymentMethod` | string | `upi` or `cash` |
| `status` | string | `placed` → `accepted` → `preparing` → `out_for_delivery` → `delivered` |
| `createdAt` | timestamp | Order placement time |
| `updatedAt` | timestamp | Last status update |

### `categories`
| Field | Type | Description |
|---|---|---|
| `id` | string | Document ID |
| `name` | string | Category name |
| `sortOrder` | number | Display order |

## Firestore Security Rules (Recommended)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /restaurant/{docId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'owner';
    }
    match /menu_items/{itemId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'owner';
    }
    match /orders/{orderId} {
      allow create: if request.auth != null;
      allow read: if request.auth != null;
      allow update: if request.auth != null;
    }
    match /categories/{catId} {
      allow read: if true;
      allow write: if request.auth != null && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'owner';
    }
  }
}
```
