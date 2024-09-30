# Tea Subscription Service API

This API provides a service for managing tea subscriptions. Customers can subscribe to a tea, view all their subscriptions, update their subscription status, and cancel a subscription.

## Base URL
http://localhost:3000/api/v1

---

## Endpoints Overview

1. **Create a Tea Subscription**
   - **POST /customers/:customer_id/subscriptions**
   - Subscribe a customer to a new tea subscription.

2. **Get All Subscriptions**
   - **GET /customers/:customer_id/subscriptions**
   - Retrieve all subscriptions (active and cancelled) for a customer.

3. **Get a Specific Subscription**
   - **GET /customers/:customer_id/subscriptions/:id**
   - Retrieve a specific subscription by ID.

4. **Update a Subscription**
   - **PATCH /customers/:customer_id/subscriptions/:id**
   - Update the status of a subscription (e.g., cancel the subscription).

5. **Delete a Subscription**
   - **DELETE /customers/:customer_id/subscriptions/:id**
   - Cancel (delete) a subscription.

---

## 1. Create a Tea Subscription

### **Endpoint**: 
POST /customers/
/subscriptions

### **Description**:
This endpoint creates a new tea subscription for a specific customer.

### **Request Parameters**:
- `customer_id` (path): The ID of the customer creating the subscription.
- `tea_id` (body): The ID of the tea being subscribed to.

### **Request Body Example** (JSON):
```
{
  "tea_id": 1,
  "subscription": {
    "title": "Monthly Green Tea Subscription",
    "price": 15.0,
    "frequency": "monthly",
    "status": "active"
  }
}
Response Example (201 Created):
{
  "data": {
    "id": "1",
    "type": "subscription",
    "attributes": {
      "title": "Monthly Green Tea Subscription",
      "price": 15.0,
      "status": "active",
      "frequency": "monthly",
      "customer_id": 1,
      "tea": {
        "title": "Green Tea",
        "description": "A refreshing and healthy green tea.",
        "temperature": 80,
        "brew_time": 3
      }
    }
  }
}
Error Responses:
404 Not Found: If the customer or tea is not found.
{
  "error": "Tea not found"
}
{
  "error": "Customer not found"
}
422 Unprocessable Entity: If the request contains invalid data (e.g., missing title or price).
{
  "errors": ["Title can't be blank", "Price can't be blank"]
}
```
## 2. Get All Subscriptions

### **Endpoint**: 
GET /customers/:customer_id/subscriptions

### **Description**:
This endpoint retrieves all subscriptions (both active and cancelled) for a specific customer.

### **Request Parameters**:
- `customer_id` (path): The ID of the customer
  
```
Response Example (200 OK):
{
  "data": [
    {
      "id": "1",
      "type": "subscription",
      "attributes": {
        "title": "Monthly Green Tea Subscription",
        "price": 15.0,
        "status": "active",
        "frequency": "monthly",
        "customer_id": 1,
        "tea": {
          "title": "Green Tea",
          "description": "A refreshing and healthy green tea.",
          "temperature": 80,
          "brew_time": 3
        }
      }
    },
    {
      "id": "2",
      "type": "subscription",
      "attributes": {
        "title": "Weekly Black Tea Subscription",
        "price": 10.0,
        "status": "cancelled",
        "frequency": "weekly",
        "customer_id": 1,
        "tea": {
          "title": "Black Tea",
          "description": "A strong and bold black tea.",
          "temperature": 95,
          "brew_time": 4
        }
      }
    }
  ]
}
Error Responses:
404 Not Found: If the customer is not found.
{
  "error": "Customer not found"
}
```
----
## 3. Get a Specific Subscription

### **Endpoint**: 
GET /customers/:customer_id/subscriptions/:id

### **Description**:
This endpoint retrieves a specific subscription by ID for a customer.

### **Request Parameters**:
- `customer_id` (path): The ID of the customer.
- `id` (path): The ID of the subscription.
```
Response Example (200 OK):
{
  "data": {
    "id": "1",
    "type": "subscription",
    "attributes": {
      "title": "Monthly Green Tea Subscription",
      "price": 15.0,
      "status": "active",
      "frequency": "monthly",
      "customer_id": 1,
      "tea": {
        "title": "Green Tea",
        "description": "A refreshing and healthy green tea.",
        "temperature": 80,
        "brew_time": 3
      }
    }
  }
}
Error Responses:
404 Not Found: If the customer or subscription is not found.
{
  "error": "Subscription not found"
}
```
## 4. Update a Subscription (Cancel)

### **Endpoint**: 
PATCH /customers/:customer_id/subscriptions/:id

### **Description**:
This endpoint updates a subscription’s status. For example, it can be used to cancel a subscription.

### **Request Parameters**:
- `customer_id` (path): The ID of the customer.
- `id` (path): The ID of the subscription.

Request Body Example (JSON):
```
{
  "subscription": {
    "status": "cancelled"
  }
}
Response Example (200 OK):
{
  "data": {
    "id": "1",
    "type": "subscription",
    "attributes": {
      "title": "Monthly Green Tea Subscription",
      "price": 15.0,
      "status": "cancelled",
      "frequency": "monthly",
      "customer_id": 1,
      "tea": {
        "title": "Green Tea",
        "description": "A refreshing and healthy green tea.",
        "temperature": 80,
        "brew_time": 3
      }
    }
  }
}
Error Responses:
404 Not Found: If the customer or subscription is not found.
{
  "error": "Subscription not found"
}
422 Unprocessable Entity: If an invalid status is passed.
{
  "errors": ["'invalid_status' is not a valid status"]
}
```
## 5. Delete a Subscription

### **Endpoint**: 
DELETE /customers/:customer_id/subscriptions/:id

### **Description**:
This endpoint cancels (deletes) a subscription for a customer.

### **Request Parameters**:
- `customer_id` (path): The ID of the customer.
- `id` (path): The ID of the subscription.
```
Response Example (200 OK):
{
  "message": "Subscription deleted successfully"
}
Error Responses:
404 Not Found: If the customer or subscription is not found.
{
  "error": "Subscription not found"
}
```
---
General Notes

Response Format: All responses use JSON
format, with attributes nested under data and related objects (like tea) included within the data structure.
Error Handling: All errors return a structured response with a relevant HTTP status code (404, 422).
Status Codes:
201 Created for successful creation.
200 OK for successful updates or fetches.
404 Not Found for missing resources.
422 Unprocessable Entity for validation errors.
---

## Database Schema

The Tea Subscription Service API uses a relational database with three primary tables: `customers`, `teas`, and `subscriptions`. Below is the schema definition and a brief explanation of each table and its relationships.

### **Customers**

The `customers` table stores information about the users who subscribe to tea services.
```
| Column Name   | Data Type | Description                   |
| ------------- | --------- | ----------------------------- |
| id            | bigint    | Primary key, auto-generated   |
| first_name    | string    | First name of the customer    |
| last_name     | string    | Last name of the customer     |
| email         | string    | Unique email address          |
| address       | string    | Postal address                |
| created_at    | datetime  | Timestamp when created        |
| updated_at    | datetime  | Timestamp when updated        |
```
- **Index**: There is a unique index on `email` to ensure each customer has a unique email address.

### **Teas**

The `teas` table stores information about the different types of teas that customers can subscribe to.
```
| Column Name   | Data Type | Description                      |
| ------------- | --------- | -------------------------------- |
| id            | bigint    | Primary key, auto-generated      |
| title         | string    | Name of the tea                  |
| description   | text      | Description of the tea           |
| temperature   | integer   | Optimal brewing temperature (°C) |
| brew_time     | integer   | Brewing time in minutes          |
| created_at    | datetime  | Timestamp when created           |
| updated_at    | datetime  | Timestamp when updated           |
```
### **Subscriptions**

The `subscriptions` table stores information about customers' tea subscriptions.
```
| Column Name   | Data Type   | Description                                        |
| ------------- | ----------- | -------------------------------------------------- |
| id            | bigint      | Primary key, auto-generated                        |
| title         | string      | Title of the subscription                          |
| price         | decimal     | Price of the subscription                          |
| status        | integer     | Status of the subscription (`active`, `cancelled`) |
| frequency     | string      | Subscription frequency (`weekly`, `monthly`, etc.) |
| customer_id   | bigint      | Foreign key, references the `customers` table      |
| tea_id        | bigint      | Foreign key, references the `teas` table           |
| created_at    | datetime    | Timestamp when created                             |
| updated_at    | datetime    | Timestamp when updated                             |
```
- **Foreign Keys**: `customer_id` references the `customers` table, and `tea_id` references the `teas` table.
- **Indexes**: There are indexes on `customer_id` and `tea_id` to optimize lookup.

- Customers have many Subscriptions: Each customer can have multiple subscriptions.

- Subscriptions belong to Customers: Each subscription is linked to a customer.

- Teas have many Subscriptions: A single tea can be associated with multiple subscriptions.

- Subscriptions belong to Teas: Each subscription is linked to a specific tea.
---
