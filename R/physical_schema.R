library(readr)
library(RSQLite)
library(dplyr)
library(DBI)
library(ggplot2)
library(stringr)

database <- dbConnect(RSQLite::SQLite(), dbname = 'Ecommerce.db') #Establish a connection to the SQLite database

# Customer

# If Customer table exist, drop it
if(dbExistsTable(database, "Customer")){
  dbExecute(database, "DROP TABLE Customer")
}

dbExecute(database, "CREATE TABLE 'Customer' (
    'customer_id' TEXT PRIMARY KEY,
    'first_name' VARCHAR(50) NOT NULL,
    'last_name' VARCHAR(50) NOT NULL,
    'gender' VARCHAR(50) NOT NULL,
    'date_of_birth' DATETIME NOT NULL,
    'email' VARCHAR(50) NOT NULL,
    'phone' VARCHAR(20) NOT NULL,
    'customer_street' VARCHAR(50) NOT NULL,
    'customer_country' VARCHAR(50) NOT NULL,
    'customer_zip_code' VARCHAR(10) NOT NULL,
    'platform'TEXT NOT NULL)")

# Product

# If Product table exist, drop it
if(dbExistsTable(database, "Product")){
  dbExecute(database, "DROP TABLE Product")
}

dbExecute(database,"CREATE TABLE  'Product' (
    'product_id' TEXT PRIMARY KEY,
    'product_name' VARCHAR(255) NOT NULL,
    'price' DECIMAL(10,2) NOT NULL,
    'product_description' TEXT NOT NULL,
    'inventory' INT NOT NULL,
    'weight' DECIMAL(10,2) NOT NULL,
    'category_id' TEXT NOT NULL,
    'seller_id' TEXT NOT NULL,
    'product_views' INT NOT NULL,
    FOREIGN KEY ('category_id') REFERENCES Category ('category_id'),
    FOREIGN KEY ('seller_id') REFERENCES Sellers ('seller_id'))")

# Category

# If Category table exist, drop it
if(dbExistsTable(database, "Category")){
  dbExecute(database, "DROP TABLE Category")
}
dbExecute(database,"CREATE TABLE 'Category' (
    'category_id' TEXT PRIMARY KEY,
    'p_category_id' TEXT,
    'cat_name' VARCHAR(255) NOT NULL,
    'cat_description' TEXT NOT NULL)")

# Discount

# If Discount table exist, drop it
if(dbExistsTable(database, "Discount")){
  dbExecute(database, "DROP TABLE Discount")
}
dbExecute(database,"CREATE TABLE  'Discount' (
    'discount_id' INT PRIMARY KEY,
    'discount_percentage' DECIMAL(10,2) NOT NULL,
    'discount_start_date' DATETIME NOT NULL,
    'discount_end_date' DATETIME NOT NULL,
    'product_id' INT NOT NULL,
    FOREIGN KEY ('product_id') REFERENCES Product ('product_id')
)")

# Order

# If Order table exists, drop it
if (dbExistsTable(database, "Order")) {
  dbExecute(database, "DROP TABLE 'Order'")
}
dbExecute(database,"CREATE TABLE 'Order' ( 
    'order_number' TEXT NOT NULL, 
    'payment_method' TEXT NOT NULL , 
    'order_date' DATETIME NOT NULL , 
    'quantity' INTEGER NOT NULL , 
    'review' TEXT, 
    'customer_id' TEXT NOT NULL , 
    'product_id' TEXT NOT NULL ,
    'shipment_id' TEXT NOT NULL ,
    'customer_rating' INT NOT NULL,
    PRIMARY KEY ('order_number', 'product_id'),
    FOREIGN KEY ('product_id') REFERENCES Product ('product_id'), 
    FOREIGN KEY ('customer_id') REFERENCES Customer ('customer_id'), 
    FOREIGN KEY ('shipment_id') REFERENCES Shipment ('shipment_id')
)")

# Shipment

# If shipment table exist, drop it
if(dbExistsTable(database, "Shipment")){
  dbExecute(database, "DROP TABLE 'Shipment'")
}

dbExecute(database,"CREATE TABLE 'Shipment' ( 
  'shipment_id' TEXT PRIMARY KEY,
  'shipment_delay_days' INT NOT NULL, 
  'shipment_cost' INT NOT NULL,  
  'order_number' TEXT NOT NULL,
  'refund' TEXT NOT NULL,
  FOREIGN KEY ('order_number') REFERENCES `Order` ('order_number')
)")

# Seller

# If Sellers table exist, drop it
if(dbExistsTable(database, "Sellers")){
  dbExecute(database, "DROP TABLE 'Sellers'")
}

dbExecute(database,"CREATE TABLE 'Sellers' (
    'seller_Id' TEXT PRIMARY KEY,
    'company_name' VARCHAR(100) NOT NULL ,
    'supplier_phone' VARCHAR(20) NOT NULL,
    'supplier_email' VARCHAR(100) NOT NULL UNIQUE,
    'seller_Street' VARCHAR(255) NOT NULL,
    'seller_country' VARCHAR(255) NOT NULL,
    'seller_zip_code' VARCHAR(10) NOT NULL)")


