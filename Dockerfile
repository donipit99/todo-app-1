# Используем официальный образ Go как базовый
FROM golang:1.24-alpine AS builder

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем go.mod и go.sum для загрузки зависимостей
COPY go.mod go.sum ./
RUN go mod download

# Копируем весь код проекта
COPY . .

# Компилируем приложение
# Флаг -o todo-app указывает имя выходного бинарного файла
RUN go build -o todo-app ./cmd/main.go

# Используем минимальный образ для запуска
FROM alpine:latest

# Устанавливаем рабочую директорию
WORKDIR /root/

# Копируем скомпилированный бинарь из предыдущего этапа
COPY --from=builder /app/todo-app .

# Копируем конфигурационные файлы (если они нужны в контейнере)
COPY --from=builder /app/configs ./configs

# Указываем порт, который будет использовать приложение
EXPOSE 8000

# Команда для запуска приложения
CMD ["./todo-app"]

