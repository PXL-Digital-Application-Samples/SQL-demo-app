# 🐘 PostgreSQL User Management API

A REST API for managing users powered by PostgreSQL, PL/pgSQL stored procedures, and PostgREST. Features automatic OpenAPI documentation via Swagger UI.

## 📦 Features

- ✅ PostgreSQL database with PL/pgSQL functions
- 🔄 Full CRUD endpoints via PostgREST
- 🧪 Swagger UI for testing & docs at port 8080
- 🐳 Docker Compose for easy deployment
- 🚀 High performance with direct database-to-HTTP mapping

## 🏗️ Architecture

- **PostgreSQL**: Database with custom schema and PL/pgSQL functions
- **PostgREST**: Automatically generates REST API from database schema
- **Swagger UI**: Interactive API documentation

## 🚀 Getting Started

### Requirements

- Docker & Docker Compose
- Make (optional, for convenience commands)

### Quick Start

1. Clone the repository and navigate to the project directory

2. Copy environment variables:
```bash
cp .env.example .env
```

3. Start the services:
```bash
docker-compose up -d
# or using make
make up
```

4. Access the services:
   - API: http://localhost:3000
   - Swagger UI: http://localhost:8080

### API Endpoints

#### Get all users
```bash
curl http://localhost:3000/users
```

#### Get a specific user
```bash
curl http://localhost:3000/users?id=eq.1
```

#### Create a new user
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

#### Update a user
```bash
curl -X PATCH http://localhost:3000/users?id=eq.1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Jane Doe"}'
```

#### Delete a user
```bash
curl -X DELETE http://localhost:3000/users?id=eq.1
```

### Using PL/pgSQL Functions

You can also call stored procedures directly:

```bash
# Create user via function
curl -X POST http://localhost:3000/rpc/create_user \
  -H "Content-Type: application/json" \
  -d '{"p_name":"New User","p_email":"newuser@example.com"}'

# Update user via function
curl -X POST http://localhost:3000/rpc/update_user \
  -H "Content-Type: application/json" \
  -d '{"p_id":1,"p_name":"Updated Name"}'
```

## 📁 Project Structure

```
.
├── compose.yml          # Docker services configuration
├── schema.sql           # Database schema and PL/pgSQL functions
├── init-roles.sql       # PostgREST roles setup
├── .env.example         # Environment variables template
├── Makefile             # Convenience commands
└── README.md            # This file
```

## 🔧 Configuration

Edit the `.env` file to customize:

- PostgreSQL credentials and port
- API port (default: 3000)
- Swagger UI port (default: 8080)

## 🛠️ Development

### Database Access
```bash
make db-shell
# or
docker-compose exec postgres psql -U postgres -d userdb
```

### View Logs
```bash
make logs
# or
docker-compose logs -f
```

### Restart Services
```bash
make restart
# or
docker-compose restart
```

## 🧹 Cleanup

To stop and remove all containers and volumes:
```bash
make clean
# or
docker-compose down -v
```