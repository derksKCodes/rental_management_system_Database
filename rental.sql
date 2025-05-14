-- Rental Management System Database Schema
-- This SQL script creates a database schema for a Rental Management System.
-- The schema includes tables for properties, tenants, leases, payments, maintenance requests, and users.
-- The schema is designed to manage rental properties, tenants, lease agreements, payments, and maintenance requests.

-- 1. Properties Table: Stores information about the rental properties.
CREATE TABLE
    Properties (
        PropertyID INT AUTO_INCREMENT PRIMARY KEY,
        PropertyName VARCHAR(255) NOT NULL,
        PropertyType VARCHAR(50) NOT NULL, -- e.g., 'Apartment', 'House', 'Commercial'
        Address VARCHAR(255) NOT NULL,
        City VARCHAR(100) NOT NULL,
        State VARCHAR(50) NOT NULL,
        ZipCode VARCHAR(20) NOT NULL,
        NumberOfBedrooms INT NOT NULL,
        NumberOfBathrooms DECIMAL(3, 1) NOT NULL,
        SquareFootage INT,
        Rent DECIMAL(10, 2) NOT NULL,
        Deposit DECIMAL(10, 2) NOT NULL,
        AvailabilityStatus ENUM ('Available', 'Occupied', 'Under Maintenance') NOT NULL DEFAULT 'Available',
        Description TEXT,
        DateAvailable DATE,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- 2. Tenants Table: Stores information about the tenants.
CREATE TABLE
    Tenants (
        TenantID INT AUTO_INCREMENT PRIMARY KEY,
        FirstName VARCHAR(100) NOT NULL,
        LastName VARCHAR(100) NOT NULL,
        DateOfBirth DATE NOT NULL,
        Gender ENUM ('Male', 'Female', 'Other') NOT NULL,
        Email VARCHAR(255) NOT NULL UNIQUE,
        Phone VARCHAR(20) NOT NULL UNIQUE,
        Address VARCHAR(255) NOT NULL,
        City VARCHAR(100) NOT NULL,
        State VARCHAR(50) NOT NULL,
        ZipCode VARCHAR(20) NOT NULL,
        Occupation VARCHAR(100),
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- 3. Leases Table: Stores information about lease agreements between tenants and properties.
CREATE TABLE
    Leases (
        LeaseID INT AUTO_INCREMENT PRIMARY KEY,
        PropertyID INT NOT NULL,
        TenantID INT NOT NULL,
        StartDate DATE NOT NULL,
        EndDate DATE NOT NULL,
        RentAmount DECIMAL(10, 2) NOT NULL,
        DepositAmount DECIMAL(10, 2) NOT NULL,
        PaymentFrequency ENUM ('Monthly', 'Quarterly', 'Annually') NOT NULL,
        LeaseStatus ENUM ('Active', 'Expired', 'Terminated') NOT NULL DEFAULT 'Active',
        SignedDate DATE,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (PropertyID) REFERENCES Properties (PropertyID),
        FOREIGN KEY (TenantID) REFERENCES Tenants (TenantID),
        CONSTRAINT CHK_LeaseDates CHECK (StartDate <= EndDate) -- Ensure start date is before end date.
    );

-- 4. Payments Table: Stores information about rent payments made by tenants.
CREATE TABLE
    Payments (
        PaymentID INT AUTO_INCREMENT PRIMARY KEY,
        LeaseID INT NOT NULL,
        PaymentDate DATE NOT NULL,
        Amount DECIMAL(10, 2) NOT NULL,
        PaymentMethod ENUM (
            'Cash',
            'Credit Card',
            'Bank Transfer',
            'Check',
            'Other'
        ) NOT NULL,
        TransactionID VARCHAR(255), -- Add TransactionID
        Notes TEXT,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (LeaseID) REFERENCES Leases (LeaseID)
    );

-- 5. MaintenanceRequests Table:  Stores maintenance requests submitted by tenants
CREATE TABLE
    MaintenanceRequests (
        RequestID INT AUTO_INCREMENT PRIMARY KEY,
        PropertyID INT NOT NULL,
        TenantID INT NOT NULL,
        RequestDate DATE NOT NULL,
        RequestType VARCHAR(100) NOT NULL, -- e.g., 'Plumbing', 'Electrical', 'Appliances'
        Description TEXT NOT NULL,
        Status ENUM (
            'Pending',
            'In Progress',
            'Completed',
            'Cancelled'
        ) NOT NULL DEFAULT 'Pending',
        Priority ENUM ('High', 'Medium', 'Low') NOT NULL DEFAULT 'Medium',
        ScheduledDate DATE,
        CompletedDate DATE,
        Notes TEXT,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (PropertyID) REFERENCES Properties (PropertyID),
        FOREIGN KEY (TenantID) REFERENCES Tenants (TenantID),
        CONSTRAINT CHK_RequestDates CHECK (
            RequestDate <= COALESCE(ScheduledDate, CompletedDate, RequestDate)
        )
    );

-- 6. Users Table:  Stores user information for staff/employees managing the system.
CREATE TABLE
    Users (
        UserID INT AUTO_INCREMENT PRIMARY KEY,
        FirstName VARCHAR(100) NOT NULL,
        LastName VARCHAR(100) NOT NULL,
        Email VARCHAR(255) NOT NULL UNIQUE,
        Password VARCHAR(255) NOT NULL, -- Store hashed passwords
        Role ENUM ('Admin', 'Manager', 'Staff') NOT NULL,
        Phone VARCHAR(20),
        LastLogin DATETIME,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- 7. PropertyAmenities Table:  Stores the amenities available for each property.  This is a M-M relationship
CREATE TABLE
    PropertyAmenities (
        PropertyID INT NOT NULL,
        Amenity VARCHAR(255) NOT NULL, -- e.g., 'Parking', 'Gym', 'Pool', 'Laundry'
        PRIMARY KEY (PropertyID, Amenity), -- Composite Primary Key
        FOREIGN KEY (PropertyID) REFERENCES Properties (PropertyID),
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- 8. LeaseDocuments Table:  Stores documents related to a lease.
CREATE TABLE
    LeaseDocuments (
        DocumentID INT AUTO_INCREMENT PRIMARY KEY,
        LeaseID INT NOT NULL,
        DocumentType VARCHAR(100) NOT NULL, -- e.g., 'Lease Agreement', 'Security Deposit Receipt'
        DocumentURL VARCHAR(255) NOT NULL, -- Store the URL of the document
        Description TEXT,
        UploadedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (LeaseID) REFERENCES Leases (LeaseID)
    );

-- 9. PropertyImages Table: Stores images of properties.
CREATE TABLE
    PropertyImages (
        ImageID INT AUTO_INCREMENT PRIMARY KEY,
        PropertyID INT NOT NULL,
        ImageURL VARCHAR(255) NOT NULL, -- Store the URL of the image
        Caption VARCHAR(255),
        UploadedDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (PropertyID) REFERENCES Properties (PropertyID)
    );

-- 10. Notifications Table: Stores notifications for tenants and staff.
CREATE TABLE
    Notifications (
        NotificationID INT AUTO_INCREMENT PRIMARY KEY,
        UserID INT, --  Can be NULL for system-wide notifications
        TenantID INT, -- Can be NULL for system-wide notifications
        NotificationType VARCHAR(100) NOT NULL, -- e.g., 'Payment Reminder', 'Maintenance Update', 'Lease Expiry'
        Subject VARCHAR(255) NOT NULL,
        Message TEXT NOT NULL,
        SentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
        Status ENUM ('Sent', 'Read', 'Unread') NOT NULL DEFAULT 'Unread',
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        Updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (UserID) REFERENCES Users (UserID),
        FOREIGN KEY (TenantID) REFERENCES Tenants (TenantID)
    );
