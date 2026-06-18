FROM php:8.5-cli

# Update repository dan install dependencies yang diperlukan Laravel 13
# Ditambahkan: sqlite3 dan libsqlite3-dev untuk mendukung database SQLite
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    nodejs \
    npm \
    sqlite3 \
    libsqlite3-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure dan install PHP extensions
# Mengganti pdo_mysql dengan pdo_sqlite
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_sqlite \
    gd \
    zip \
    intl \
    bcmath \
    mbstring

# Install Composer versi terbaru
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Menyalin seluruh file project ke dalam container
COPY . /app

# Jalankan Composer Install (tanpa dev dependencies untuk tahap production)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Build assets menggunakan Vite
RUN npm install && npm run build

# Membuat file database SQLite (jika belum ada) dan memastikan izin akses aman
# Folder database wajib 777 agar SQLite bisa membuat file temporary (lock/wal) saat proses write
RUN mkdir -p /app/database \
    && touch /app/database/database.sqlite \
    && chmod -R 777 /app/storage /app/bootstrap/cache /app/database

# Menjalankan aplikasi (Mendukung port dinamis dari Railway)
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8080}
