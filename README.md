# Shopping Mall

A simple e-commerce web application built with Java Servlet/JSP and PostgreSQL.

## Tech Stack

- **Java 21** with Jakarta Servlet 6.1 / JSP 4.0
- **PostgreSQL 18**
- **Apache Tomcat 11** as the application server (JNDI DataSource)
- **Maven** for build and dependency management
- **BCrypt** for password hashing

## Features

### Customer

- User registration, login, and profile management
- Product browsing with category filtering
- Shopping cart (session-based for guests, DB-based for logged-in users)
- Order checkout with idempotency protection
- Order history and tracking
- Automatic cart merge on login (guest cart → DB)
- Login redirect to cart when accessing protected pages as a guest

### Admin

- Product and category management (add, edit, stock control)
- Order management and status updates

## Project Structure

```
src/main/java/com/shop/
├── controller/    # Servlet controllers (Home, User, Product, Cart, Order, Admin)
├── service/       # Business logic layer
├── dao/           # Data access objects
├── model/         # Entity classes (User, Product, Category, CartItem, Order, OrderItem)
├── filter/        # Encoding and authentication filters
└── util/          # Database utility and context listener

src/main/webapp/
├── WEB-INF/
│   ├── web.xml
│   └── views/     # JSP views organized by feature
└── index.jsp

sql/
└── schema.sql     # PostgreSQL database schema
```

## Prerequisites

- Java 21+
- Apache Tomcat 11+
- PostgreSQL 18+
- Maven 3.9+

## Getting Started

### 1. Set Up the Database

Create a PostgreSQL database and apply the schema:

```bash
psql -U postgres -c "CREATE DATABASE shoppingmall;"
psql -U postgres -d shoppingmall -f sql/schema.sql
```

### 2. Configure DataSource

Define a JNDI DataSource in Tomcat's `context.xml`:

```xml
<Resource name="jdbc/shoppingmall"
          auth="Container"
          type="javax.sql.DataSource"
          driverClassName="org.postgresql.Driver"
          url="jdbc:postgresql://localhost:5432/shoppingmall?currentSchema=shopping_mall"
          username="your_username"
          password="your_password"
          maxTotal="10"
          maxIdle="5"
          minIdle="2" />
```

### 3. Build

```bash
mvn clean package
```

This produces `target/shoppingmall.war`.

### 4. Deploy

Copy the WAR file to your Tomcat `webapps/` directory as `ROOT.war`:

```bash
cp target/shoppingmall.war $CATALINA_HOME/webapps/ROOT.war
```

The application will be available at `http://localhost:8080`.

## Database Schema

The application uses 6 tables:

| Table | Description |
|-------|-------------|
| `users` | User accounts with role-based access (CUSTOMER / ADMIN) |
| `categories` | Hierarchical product categories |
| `products` | Product catalog with price and stock |
| `cart_items` | Shopping cart items for logged-in users |
| `orders` | Purchase orders with status tracking and idempotency key |
| `order_items` | Individual items within each order |

## Session Clustering

The application supports Tomcat session clustering for WAS redundancy:

- `<distributable/>` is enabled in `web.xml`
- All session-stored objects (`User`, `CartItem`) implement `Serializable`
- Configure `StaticMembershipInterceptor` in Tomcat's `server.xml` for static peer discovery

## Security

- BCrypt password hashing for user credentials
- Session-based authentication
- Authentication filter protecting `/order/*` and `/admin/*` routes
- UTF-8 encoding filter on all requests
- Order idempotency key to prevent duplicate submissions
- Atomic stock decrement to prevent overselling
