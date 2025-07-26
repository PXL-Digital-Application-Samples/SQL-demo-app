.PHONY: help up down restart logs db-shell api-test clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

up: ## Start all services
	docker compose up -d
	@echo "Services started!"
	@echo "API available at: http://localhost:3000"
	@echo "Swagger UI available at: http://localhost:8080"

down: ## Stop all services
	docker compose down

restart: ## Restart all services
	docker compose restart

logs: ## View logs
	docker compose logs -f

db-shell: ## Connect to PostgreSQL shell
	docker compose exec postgres psql -U postgres -d userdb

api-test: ## Test API endpoints
	@echo "Testing GET /users..."
	@curl -s http://localhost:3000/users | jq .
	@echo "\nTesting POST /users..."
	@curl -s -X POST http://localhost:3000/users \
		-H "Content-Type: application/json" \
		-d '{"name":"Test User","email":"test@example.com"}' | jq .

clean: ## Clean up volumes and containers
	docker compose down -v