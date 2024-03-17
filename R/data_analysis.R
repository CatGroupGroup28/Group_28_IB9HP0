# data analysis

## Top Locations by Purchasing Power

# Query Order and Customer tables, joining them on customer_id
order_customer <- RSQLite::dbGetQuery(database, "
  SELECT O.order_number, O.customer_id, O.product_id, O.quantity, C.customer_country
  FROM `Order` AS O
  JOIN Customer AS C ON O.customer_id = C.customer_id
")

# Join Product table to get product_price
order_customer_product <- dbGetQuery(database, "
  SELECT OC.*, P.price
  FROM (SELECT O.order_number, O.customer_id, O.product_id, O.quantity, C.customer_country
        FROM `Order` AS O
        JOIN Customer AS C ON O.customer_id = C.customer_id) AS OC
  JOIN Product AS P ON OC.product_id = P.product_id
")

# Calculate total sales amount by multiplying quantity and price for each order
order_customer_product <- mutate(order_customer_product, total_sales = quantity * price)

# Group by country and sum the total sales amount
country_sales <- order_customer_product %>%
  group_by(customer_country) %>%
  summarize(total_sales = sum(total_sales))

# Sort the countries by total sales amount in descending order
country_sales <- arrange(country_sales, desc(total_sales))

# Visualize top locations by purchasing power (total sales amount)
ggplot(country_sales[1:5, ], aes(x = reorder(customer_country, -total_sales), y = total_sales, fill = customer_country)) +
  geom_bar(stat = "identity") +
  labs(x = "Location", y = "Total Sales Amount", title = "Top Locations by Purchasing Power") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Paired")  # Set color palette for bars

## Top 5 Products by Number of Purchases

## Top 5 Products by Conversion Rate

