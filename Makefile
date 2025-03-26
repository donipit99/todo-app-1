# Переменные
BINARY_NAME = todo-app
SWAGGER_DIR = ./cmd,./pkg/handler
DB_URL = postgres://admin:${DB_PASSWORD}@localhost:5432/todoapp?sslmode=disable

# Цель: скомпилировать приложение
build:
	go build -o $(BINARY_NAME) ./cmd/main.go

# Цель: запустить приложение локально
run: build
	./$(BINARY_NAME)

# Цель: сгенерировать Swagger-документацию
swagger:
	swag init --dir $(SWAGGER_DIR)

# Цель: проверить подключение к базе данных
db-check:
	psql -h localhost -p 5432 -U admin -d todoapp

# Цель: применить миграции
migrate-up:
	migrate -path schema -database "$(DB_URL)" up

# Цель: откатить миграции
migrate-down:
	migrate -path schema -database "$(DB_URL)" down

# Цель: запустить тесты
test:
	go test ./...

# Цель: очистить скомпилированные файлы
clean:
	rm -f $(BINARY_NAME)

# Цель: запустить приложение через docker-compose
docker-up:
	docker-compose up --build

# Цель: остановить docker-compose
docker-down:
	docker-compose down

# Цель: запустить только базу данных через docker-compose
db-up:
	docker-compose up -d db

# Цель: остановить и удалить все контейнеры, сети и тома
docker-clean:
	docker-compose down -v






	