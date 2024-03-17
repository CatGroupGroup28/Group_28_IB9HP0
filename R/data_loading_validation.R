# loading of data

Customer <- readr::read_csv("Dataset/fake_customer_data.csv")
Category <- readr::read_csv("Dataset/fake_category_data.csv")
Sellers <- readr::read_csv("Dataset/fake_seller_data.csv")
Product <- readr::read_csv("Dataset/fake_product_data.csv")
Discount <- readr::read_csv("Dataset/fake_discount_data.csv")
Shipment <- readr::read_csv("Dataset/fake_shipment_data.csv")
Order <- readr::read_csv("Dataset/fake_order_data.csv")

# Validation

## Validation for customer data

missing_values <- apply(is.na(Customer), 2, sum)

# Check unique customer IDs
if (length(unique(Customer$customer_id)) != nrow(Customer)) {
  print("Customer ID is not unique.")
}

# Check data types for first_name and last_name
if (!all(sapply(Customer$first_name, is.character)) || !all(sapply(Customer$last_name, is.character))) {
  print("First name and last name should be character.")
}

# Check valid gender values
valid_genders <- c("Male", "Female", "Other")
if (any(!Customer$gender %in% valid_genders)) {
  print("Gender should be Male, Female, or Other.")
}

# Check email format
if (any(!grepl("^\\S+@\\S+\\.\\S+$", Customer$email))) {
  print("Invalid email format")
}

# Regular expressions for phone number formats of Belgium, China, France, United Kingdom, United States
phone_regex <- "^\\(\\+\\d+\\)\\d{10}$"

# Check phone number format for specific countries
invalid_phone_indices <- which(!grepl(phone_regex, Customer$phone))
if (length(invalid_phone_indices) > 0) {
  print("Invalid phone numbers:")
  print(Customer[invalid_phone_indices, ])
}

# Regular expressions for zip code formats of Belgium, China, France, United Kingdom, United States
zip_regex <- c(
  "^[0-9]{4}$",  # Belgium
  "^[0-9]{6}$",  # China
  "^[0-9]{5}$",  # France
  "^[A-Z]{2}[0-9]{1,2}[A-Z]? [0-9][A-Z]{2}$",  # United Kingdom
  "^[0-9]{5}-[0-9]{4}$"    # United States
)

# Check zip code format for specific countries
invalid_zip_indices <- which(!grepl(paste(zip_regex, collapse = "|"), Customer$customer_zip_code))
if (length(invalid_zip_indices) > 0) {
  print("Invalid zip codes:")
  print(Customer[invalid_zip_indices, ])
}

# Check platform values
valid_platforms <- c("Referral", "Instagram", "Facebook", "Others")
if (any(!Customer$platform %in% valid_platforms)) {
  print("Invalid platform values.")
}

# If no errors are found, print a message indicating that the data is valid
if (!any(is.na(missing_values)) && 
    length(unique(Customer$customer_id)) == nrow(Customer) &&
    all(sapply(Customer$first_name, is.character)) &&
    all(sapply(Customer$last_name, is.character)) &&
    all(Customer$gender %in% valid_genders) &&
    all(grepl("^\\S+@\\S+\\.\\S+$", Customer$email)) &&
    length(invalid_phone_indices) == 0 &&
    length(invalid_zip_indices) == 0 &&
    all(Customer$platform %in% valid_platforms)) {
  print("Data is valid.")
  # Load the data into the database
} else {
  print("Data is not valid. Please correct the errors.")
}

## Validation for discount data

na_disc <- apply(is.na(Discount), 2, sum)

# Check discount percentage range (assuming it's between 0 and 100)
if (any(Discount$discount_percentage < 0 | Discount$discount_percentage > 100)) {
  print("Invalid discount percentage.")
}

# Check discount dates
if (any(Discount$discount_start_date >= Discount$discount_end_date)) {
  print("Discount start date should be before the end date.")
}

if (any(!Discount$product_id %in% Product$product_id)) {
  print("Invalid product IDs. Some product IDs do not exist in the Product table.")
}

# If no errors are found, print a message indicating that the data is valid
if (!any(is.na(na_disc)) && 
    all(Discount$discount_percentage >= 0 & Discount$discount_percentage <= 100) &&
    all(Discount$discount_start_date < Discount$discount_end_date) &&
    all(Discount$product_id %in% Product$product_id)) {
  print("Discount data is valid.")
  # Load the data into the database
} else {
  print("Discount data is not valid. Please correct the errors.")
}

## Validation for order data

na_order <- apply(is.na(Order), 2, sum)

# Check quantity (assuming it should be a positive integer)
if (any(Order$quantity <= 0)) {
  print("Invalid quantity.")
}

# Check customer rating (assuming it should be between 1 and 5)
if (any(Order$customer_rating < 1 | Order$customer_rating > 5)) {
  print("Invalid customer rating.")
}

if (any(!Order$product_id %in% Product$product_id)) {
  print("Invalid product IDs. Some product IDs do not exist in the Product table.")
}
if (any(!Order$customer_id %in% Customer$customer_id)) {
  print("Invalid customer IDs. Some customer IDs do not exist in the Customer table.")
}
if (any(!Order$shipment_id %in% Shipment$shipment_id)) {
  print("Invalid shipment IDs. Some shipment IDs do not exist in the Shipment table.")
}

# If no errors are found, print a message indicating that the data is valid
if (!any(is.na(na_order)) && 
    all(Order$quantity > 0) &&
    all(Order$customer_rating >= 1 & Order$customer_rating <= 5)&&
    all(Order$product_id %in% Product$product_id) &&
    all(Order$customer_id %in% Customer$customer_id) &&
    all(Order$shipment_id %in% Shipment$shipment_id)) {
  print("Order data is valid.")
  # Load the data into the database
} else {
  print("Order data is not valid. Please correct the errors.")
}

## Validation for product category data

na_prod_cat <- apply(is.na(Category), 2, sum)

# Ensure "category_id" values are unique
if (length(unique(Category$category_id)) != nrow(Category)) {
  print("category_id values are not unique.")
}

# Check length of "cat_name"
if (any(nchar(Category$cat_name) > 255)) {
  print("cat_name exceeds 255 characters.")
}

# Check data type of each column
if (!all(sapply(Category$category_id, is.character)) ||
    !all(sapply(Category$cat_name, is.character)) ||
    !all(sapply(Category$cat_description, is.character))) {
  print("Invalid data type for one or more columns.")
}

# If no errors are found, print a message indicating that the data is valid
if (!any(is.na(na_prod_cat)) &&
    length(unique(Category$category_id)) == nrow(Category) &&
    !any(nchar(Category$cat_name) > 255) &&
    all(sapply(Category$category_id, is.character)) &&
    all(sapply(Category$cat_name, is.character)) &&
    all(sapply(Category$cat_description, is.character))) {
  print("product_category data is valid.")
  # Load the data into the database
} else {
  print("product_category data is not valid. Please correct the errors.")
}

## Validation of products data

na_Product <- apply(is.na(Product), 2, sum)

# Ensure "product_id" values are unique
if (length(unique(Product$product_id)) != nrow(Product)) {
  print("product_id values are not unique.")
}

# Check length of "product_name"
if (any(nchar(Product$product_name) > 255)) {
  print("product_name exceeds 255 characters.")
}

if (any(!Product$category_id %in% Category$category_id)) {
  print("Invalid category IDs. Some category IDs do not exist in the product_category table.")
}
if (any(!Product$seller_id %in% Sellers$seller_id)) {
  print("Invalid seller IDs. Some seller IDs do not exist in the Sellers table.")
}

# If no errors are found, print a message indicating that the data is valid
if (!any(is.na(na_Product)) &&
    length(unique(Product$product_id)) == nrow(Product) &&
    !any(nchar(Product$product_name) > 255) &&
    all(Product$category_id %in% Category$category_id) &&
    all(Product$seller_id %in% Sellers$seller_id)) {
  print("Product data is valid.")
  # Load the data into the database
} else {
  print("Product data is not valid. Please correct the errors.")
}

## Validation of Seller Data
library(stringr)
na_sellers <- apply(is.na(Sellers), 2, sum)

# Ensure "seller_Id" values are unique
if (length(unique(Sellers$seller_id)) != nrow(Sellers)) {
  print("seller_Id values are not unique.")
}

# Check length of "company_name"
if (any(nchar(Sellers$company_name) > 100)) {
  print("company_name exceeds 100 characters.")
}

# Check email format
invalid_emails <- which(!str_detect(Sellers$supplier_email, "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b"))
if (length(invalid_emails) > 0) {
  print("Invalid email addresses:")
  print(Sellers[invalid_emails, ])
}

# If no errors are found, print a message indicating that the data is valid
if (!any(is.na(na_sellers)) &&
    length(unique(Sellers$seller_id)) == nrow(Sellers) &&
    !any(nchar(Sellers$company_name) > 100) &&
    length(invalid_emails) == 0) {
  print("Sellers data is valid.")
  # Load the data into the database
} else {
  print("Sellers data is not valid. Please correct the errors.")
}

# Validation for Shipment Data

na_shipment <- sapply(Shipment, function(x) sum(is.na(x)))

# Ensure "shipment_id" values are unique
if (length(unique(Shipment$shipment_id)) != nrow(Shipment)) {
  print("shipment_id values are not unique.")
}

# Validate "refund" column
valid_refunds <- c("Yes", "No")
if (!all(Shipment$refund %in% valid_refunds)) {
  print("Invalid values in the 'refund' column.")
}

# Validate "shipment_delay_days" and "shipment_cost" columns
if (any(Shipment$shipment_delay_days <= 0) || any(Shipment$shipment_cost <= 0)) {
  print("shipment_delay_days and shipment_cost should be positive numbers.")
}

# Ensure that all "order_number" values exist in the "Order" table
order_numbers <- unique(Shipment$order_number)
if (!all(order_numbers %in% Order$order_number)) {
  print("Some order numbers do not exist in the 'Order' table.")
}

# If no errors are found, print a message indicating that the data is valid
if (all(na_shipment == 0) &&
    length(unique(Shipment$shipment_id)) == nrow(Shipment) &&
    all(Shipment$refund %in% valid_refunds) &&
    all(Shipment$shipment_delay_days > 0) &&
    all(Shipment$shipment_cost > 0) &&
    all(order_numbers %in% Order$order_number)) {
  print("Shipment data is valid.")
  # Load the data into the database
} else {
  print("Shipment data is not valid. Please correct the errors.")
}


DBI::dbWriteTable(database,"Customer",Customer,append=TRUE)
DBI::dbWriteTable(database,"Product",Product,append=TRUE)
DBI::dbWriteTable(database,"Discount",Discount,append=TRUE)
DBI::dbWriteTable(database,"Shipment",Shipment,append=TRUE)
DBI::dbWriteTable(database,"Category",Category,append=TRUE)
DBI::dbWriteTable(database,"Order",Order,append=TRUE)