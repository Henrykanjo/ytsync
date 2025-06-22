# Используем официальный Python образ
FROM python:3.11-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию
WORKDIR /app

# Копируем файлы зависимостей
COPY requirements.txt .

# Устанавливаем Python зависимости
RUN pip install --no-cache-dir -r requirements.txt

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

# Открываем порт (если понадобится в будущем для API)
EXPOSE 8000

# Команда запуска
CMD ["python", "main.py"]
