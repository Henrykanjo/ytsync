# Этап сборки зависимостей
FROM python:3.11-slim as builder

# Устанавливаем инструменты для сборки
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем requirements и устанавливаем зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Финальный образ
FROM python:3.11-slim

# Устанавливаем только runtime зависимости
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Копируем установленные пакеты из builder
COPY --from=builder /root/.local /root/.local

# Создаем рабочую директорию
WORKDIR /app

# Копируем исходный код
COPY main.py .

# Создаем директории для данных
RUN mkdir -p /app/downloads

# Создаем пользователя для безопасности
RUN groupadd -r ytuser && useradd -r -g ytuser ytuser
RUN chown -R ytuser:ytuser /app
USER ytuser

# Переменные окружения
ENV PYTHONUNBUFFERED=1
ENV PATH=/root/.local/bin:$PATH

# Открываем порт (если понадобится в будущем для API)
EXPOSE 8000

# Команда запуска
CMD ["python", "main.py"]
