# Rental Management System Database

## Overview

This SQL script creates a database schema for a Rental Management System. The schema is designed to efficiently manage rental properties, tenants, lease agreements, payments, maintenance requests, users, property amenities, lease documents, property images, and notifications.

## Database Description

The database schema includes the following tables:

1.  **Properties**: Stores information about rental properties, including details like property name, type, address, rent, and availability.
2.  **Tenants**: Stores information about tenants, such as personal details, contact information, and occupation.
3.  **Leases**: Stores information about lease agreements between tenants and properties, including start and end dates, rent amount, and lease status.
4.  **Payments**: Stores information about rent payments made by tenants, including payment date, amount, and payment method.
5.  **MaintenanceRequests**: Stores maintenance requests submitted by tenants, including request details, status, and priority.
6.  **Users**: Stores user information for staff/employees managing the system, including login credentials and roles.
7.  **PropertyAmenities**: Stores the amenities available for each property (e.g., parking, gym, pool).  This table establishes a many-to-many relationship between properties and amenities.
8.  **LeaseDocuments**: Stores documents related to a lease, such as lease agreements and security deposit receipts.
9.  **PropertyImages**: Stores images of properties, allowing for multiple images per property.
10. **Notifications**: Stores notifications for tenants and staff, such as payment reminders and maintenance updates.

## Table Details

### 1. Properties

Stores information about the rental properties.

| Column             | Data Type                                                              | Description                                                                                             |
| ------------------ | ---------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| PropertyID         | INT AUTO_INCREMENT PRIMARY KEY                                         | Unique identifier for the property.                                                                     |
| PropertyName       | VARCHAR(255) NOT NULL                                                  | Name of the property.                                                                                   |
| PropertyType       | VARCHAR(50) NOT NULL (e.g., 'Apartment', 'House', 'Commercial')       | Type of the property.                                                                                   |
| Address            | VARCHAR(255) NOT NULL                                                  | Address of the property.                                                                                  |
| City               | VARCHAR(100) NOT NULL                                                  | City of the property.                                                                                     |
| State              | VARCHAR(50) NOT NULL                                                   | State of the property.                                                                                    |
| ZipCode            | VARCHAR(20) NOT NULL                                                   | Zip code of the property.                                                                                   |
| NumberOfBedrooms   | INT NOT NULL                                                           | Number of bedrooms in the property.                                                                     |
| NumberOfBathrooms  | DECIMAL(3, 1) NOT NULL                                                   | Number of bathrooms in the property.                                                                    |
| SquareFootage      | INT                                                                    | Square footage of the property.                                                                           |
| Rent               | DECIMAL(10, 2) NOT NULL                                                  | Rent amount for the property.                                                                             |
| Deposit            | DECIMAL(10, 2) NOT NULL                                                  | Deposit amount for the property.                                                                          |
| AvailabilityStatus | ENUM ('Available', 'Occupied', 'Under Maintenance') NOT NULL DEFAULT 'Available' | Availability status of the property.                                                                    |
| Description        | TEXT                                                                   | Description of the property.                                                                              |
| DateAvailable      | DATE                                                                   | Date when the property is available.                                                                      |
| Created_at         | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                    | Timestamp when the property record was created.                                                           |
| Updated_at         | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP                                    | Timestamp when the property record was last updated.                                                        |

### 2. Tenants

Stores information about the tenants.

| Column        | Data Type                               | Description                                                                         |
| ------------- | --------------------------------------- | ----------------------------------------------------------------------------------- |
| TenantID      | INT AUTO_INCREMENT PRIMARY KEY          | Unique identifier for the tenant.                                                       |
| FirstName     | VARCHAR(100) NOT NULL                    | First name of the tenant.                                                               |
| LastName      | VARCHAR(100) NOT NULL                     | Last name of the tenant.                                                                |
| DateOfBirth   | DATE NOT NULL                           | Date of birth of the tenant.                                                            |
| Gender        | ENUM ('Male', 'Female', 'Other') NOT NULL | Gender of the tenant.                                                                   |
| Email         | VARCHAR(255) NOT NULL UNIQUE             | Email address of the tenant (must be unique).                                           |
| Phone         | VARCHAR(20) NOT NULL UNIQUE              | Phone number of the tenant (must be unique).                                            |
| Address       | VARCHAR(255) NOT NULL                    | Address of the tenant.                                                                  |
| City          | VARCHAR(100) NOT NULL                    | City of the tenant.                                                                     |
| State         | VARCHAR(50) NOT NULL                     | State of the tenant.                                                                    |
| ZipCode       | VARCHAR(20) NOT NULL                     | Zip code of the tenant.                                                                   |
| Occupation    | VARCHAR(100)                            | Occupation of the tenant.                                                               |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP     | Timestamp when the tenant record was created.                                             |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP     | Timestamp when the tenant record was last updated.                                          |

### 3. Leases

Stores information about lease agreements between tenants and properties.

| Column          | Data Type                                                                 | Description                                                                                                                               |
| --------------- | ------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| LeaseID         | INT AUTO_INCREMENT PRIMARY KEY                                            | Unique identifier for the lease.                                                                                                        |
| PropertyID      | INT NOT NULL, FOREIGN KEY REFERENCES Properties(PropertyID)               | Foreign key referencing the PropertyID in the Properties table.                                                                         |
| TenantID        | INT NOT NULL, FOREIGN KEY REFERENCES Tenants(TenantID)                     | Foreign key referencing the TenantID in the Tenants table.                                                                            |
| StartDate       | DATE NOT NULL                                                             | Start date of the lease.                                                                                                                |
| EndDate         | DATE NOT NULL                                                             | End date of the lease.                                                                                                                  |
| RentAmount      | DECIMAL(10, 2) NOT NULL                                                       | Rent amount for the lease.                                                                                                                |
| DepositAmount   | DECIMAL(10, 2) NOT NULL                                                       | Deposit amount for the lease.                                                                                                             |
| PaymentFrequency | ENUM ('Monthly', 'Quarterly', 'Annually') NOT NULL                         | Frequency of rent payments.                                                                                                             |
| LeaseStatus     | ENUM ('Active', 'Expired', 'Terminated') NOT NULL DEFAULT 'Active'         | Status of the lease.                                                                                                                  |
| SignedDate      | DATE                                                                      | Date the lease was signed.                                                                                                                |
| Created_at      | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                         | Timestamp when the lease record was created.                                                                                                  |
| Updated_at      | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP                                         | Timestamp when the lease record was last updated.                                                                                                   |
| CHECK         | `StartDate <= EndDate`                                                      | Ensures that the start date is before the end date.                                                                                      |

### 4. Payments

Stores information about rent payments made by tenants.

| Column        | Data Type                                                                  | Description                                                                                             |
| ------------- | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| PaymentID     | INT AUTO_INCREMENT PRIMARY KEY                                             | Unique identifier for the payment.                                                                    |
| LeaseID       | INT NOT NULL, FOREIGN KEY REFERENCES Leases(LeaseID)                        | Foreign key referencing the LeaseID in the Leases table.                                                  |
| PaymentDate   | DATE NOT NULL                                                              | Date the payment was made.                                                                                |
| Amount        | DECIMAL(10, 2) NOT NULL                                                        | Amount of the payment.                                                                                    |
| PaymentMethod | ENUM ('Cash', 'Credit Card', 'Bank Transfer', 'Check', 'Other') NOT NULL    | Method of payment.                                                                                      |
| TransactionID | VARCHAR(255)                                                                 | Transaction ID for the payment.                                                                         |
| Notes         | TEXT                                                                       | Additional notes about the payment.                                                                       |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                         | Timestamp when the payment record was created.                                                                  |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP                                         | Timestamp when the payment record was last updated.                                                                   |

### 5. MaintenanceRequests

Stores maintenance requests submitted by tenants.

| Column          | Data Type                                                                                             | Description                                                                                                                                                           |
| --------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| RequestID       | INT AUTO_INCREMENT PRIMARY KEY                                                                        | Unique identifier for the maintenance request.                                                                                                                      |
| PropertyID      | INT NOT NULL, FOREIGN KEY REFERENCES Properties(PropertyID)                                           | Foreign key referencing the PropertyID in the Properties table.                                                                                                         |
| TenantID        | INT NOT NULL, FOREIGN KEY REFERENCES Tenants(TenantID)                                                 | Foreign key referencing the TenantID in the Tenants table.                                                                                                            |
| RequestDate     | DATE NOT NULL                                                                                         | Date the request was submitted.                                                                                                                                       |
| RequestType     | VARCHAR(100) NOT NULL (e.g., 'Plumbing', 'Electrical', 'Appliances')                                   | Type of maintenance request.                                                                                                                                        |
| Description     | TEXT NOT NULL                                                                                         | Description of the maintenance request.                                                                                                                               |
| Status          | ENUM ('Pending', 'In Progress', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Pending'                    | Status of the maintenance request.                                                                                                                                  |
| Priority        | ENUM ('High', 'Medium', 'Low') NOT NULL DEFAULT 'Medium'                                               | Priority of the maintenance request.                                                                                                                                  |
| ScheduledDate   | DATE                                                                                                  | Date the maintenance is scheduled.                                                                                                                                    |
| CompletedDate   | DATE                                                                                                  | Date the maintenance was completed.                                                                                                                                     |
| Notes           | TEXT                                                                                                  | Additional notes about the maintenance request.                                                                                                                       |
| Created_at      | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                                                     | Timestamp when the maintenance request record was created.                                                                                                              |
| Updated_at      | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP                                                                     | Timestamp when the maintenance request record was last updated.                                                                                                               |
| CHECK           | `RequestDate <= COALESCE(ScheduledDate, CompletedDate, RequestDate)`                                    | Ensures that the request date is not after the scheduled or completed date.                                                                                           |

### 6. Users

Stores user information for staff/employees managing the system.

| Column    | Data Type                               | Description                                                                         |
| --------- | --------------------------------------- | ----------------------------------------------------------------------------------- |
| UserID    | INT AUTO_INCREMENT PRIMARY KEY          | Unique identifier for the user.                                                         |
| FirstName | VARCHAR(100) NOT NULL                    | First name of the user.                                                               |
| LastName  | VARCHAR(100) NOT NULL                     | Last name of the user.                                                                |
| Email     | VARCHAR(255) NOT NULL UNIQUE             | Email address of the user (must be unique).                                           |
| Password  | VARCHAR(255) NOT NULL                     | Password of the user (should be stored hashed).                                        |
| Role      | ENUM ('Admin', 'Manager', 'Staff') NOT NULL | Role of the user in the system.                                                       |
| Phone     | VARCHAR(20)                            | Phone number of the user.                                                               |
| LastLogin | DATETIME                                  | Last login time of the user.                                                              |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP     | Timestamp when the user record was created.                                             |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP     | Timestamp when the user record was last updated.                                          |

### 7. PropertyAmenities

Stores the amenities available for each property. This table establishes a many-to-many relationship between properties and amenities.

| Column     | Data Type                               | Description                                                                                             |
| ---------- | --------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| PropertyID | INT NOT NULL, FOREIGN KEY REFERENCES Properties(PropertyID) | Foreign key referencing the PropertyID in the Properties table.                                                                         |
| Amenity    | VARCHAR(255) NOT NULL                    | Name of the amenity (e.g., 'Parking', 'Gym', 'Pool', 'Laundry').                                          |
| PRIMARY KEY| `(PropertyID, Amenity)`                 | Composite primary key for the table.                                                                    |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP     | Timestamp when the record was created.                                                                            |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP     | Timestamp when the record was last updated.                                                                         |

### 8. LeaseDocuments

Stores documents related to a lease.

| Column       | Data Type                                                                 | Description                                                                                             |
| ------------ | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| DocumentID   | INT AUTO_INCREMENT PRIMARY KEY                                            | Unique identifier for the document.                                                                     |
| LeaseID      | INT NOT NULL, FOREIGN KEY REFERENCES Leases(LeaseID)                        | Foreign key referencing the LeaseID in the Leases table.                                                  |
| DocumentType | VARCHAR(100) NOT NULL (e.g., 'Lease Agreement', 'Security Deposit Receipt') | Type of the document.                                                                                     |
| DocumentURL  | VARCHAR(255) NOT NULL                                                   | URL of the document.                                                                                      |
| Description  | TEXT                                                                       | Description of the document.                                                                              |
| UploadedDate | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                     | Timestamp when the document was uploaded.                                                                 |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                         | Timestamp when the document record was created.                                                                  |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP                                         | Timestamp when the document record was last updated.                                                                   |

### 9. PropertyImages

Stores images of properties.

| Column       | Data Type                               | Description                                                                                             |
| ------------ | --------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| ImageID      | INT AUTO_INCREMENT PRIMARY KEY          | Unique identifier for the image.                                                                         |
| PropertyID   | INT NOT NULL, FOREIGN KEY REFERENCES Properties(PropertyID) | Foreign key referencing the PropertyID in the Properties table.                                                                         |
| ImageURL     | VARCHAR(255) NOT NULL                    | URL of the image.                                                                                         |
| Caption      | VARCHAR(255)                            | Caption for the image.                                                                                      |
| UploadedDate | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                     | Timestamp when the image was uploaded.                                                                 |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP     | Timestamp when the image record was created.                                                                            |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP     | Timestamp when the image record was last updated.                                                                         |

### 10. Notifications

Stores notifications for tenants and staff.

| Column           | Data Type                                                                 | Description                                                                                             |
| ---------------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| NotificationID   | INT AUTO_INCREMENT PRIMARY KEY                                            | Unique identifier for the notification.                                                                 |
| UserID           | INT, FOREIGN KEY REFERENCES Users(UserID), NULLABLE                        | Foreign key referencing the UserID in the Users table.  Can be NULL for system-wide notifications.       |
| TenantID         | INT, FOREIGN KEY REFERENCES Tenants(TenantID), NULLABLE                      | Foreign key referencing the TenantID in the Tenants table. Can be NULL for system-wide notifications.      |
| NotificationType | VARCHAR(100) NOT NULL (e.g., 'Payment Reminder', 'Maintenance Update')    | Type of notification.                                                                                     |
| Subject          | VARCHAR(255) NOT NULL                                                   | Subject of the notification.                                                                                  |
| Message          | TEXT NOT NULL                                                             | Content of the notification.                                                                                  |
| SentDate         | DATETIME DEFAULT CURRENT_TIMESTAMP                                      | Date and time the notification was sent.                                                                    |
| Status           | ENUM ('Sent', 'Read', 'Unread') NOT NULL DEFAULT 'Unread'                  | Status of the notification.                                                                                   |
| Created_at    | TIMESTAMP DEFAULT CURRENT_TIMESTAMP                                         | Timestamp when the notification record was created.                                                                  |
| Updated_at    | TIMESTAMP ON UPDATE CURRENT_TIMESTAMP                                         | Timestamp when the notification record was last updated.                                                                   |

## How to Use

1.  **Install MySQL:** Ensure you have MySQL installed on your system.
2.  **Create Database:** Create a new database named `rental_house_management_db`.
3.  **Import Schema:** Import the provided SQL script (e.g., `rental_house_management.sql`) to create the tables and relationships.  You can use a MySQL client like MySQL Workbench or the command-line tool.
4.  **Populate Data:** Populate the tables with relevant data for your rental management system.
5.  **Use the Database:** Use the database to manage your rental properties, tenants, leases, payments, and maintenance requests.

## ERD (Entity-Relationship Diagram)

[Image of ERD for Rental House Management System]


