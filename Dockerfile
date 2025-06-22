# Используем официальный Python образ
FROM python:3.11-slim

# Аргументы для настройки пользователя
ARG USER_UID=1000
ARG USER_GID=1000

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

# Создаем пользователя для безопасности с указанными UID/GID
RUN groupadd -g ${USER_GID} ytuser && \
    useradd -r -u ${USER_UID} -g ${USER_GID} ytuser
RUN chown -R ytuser:ytuser /app
USER ytuser

# Переменные окружения
ENV PYTHONUNBUFFERED=1
ENV USER_UID=${USER_UID}
ENV USER_GID=${USER_GID}

# Открываем порт (если понадобится в будущем для API)
EXPOSE 8000

# Команда запуска
CMD ["python", "main.py"]
