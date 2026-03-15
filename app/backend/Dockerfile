# Stage 1: Build
FROM python:3.11-slim as builder

WORKDIR /app

COPY requirements.txt .
# Instalam global in imaginea de build, fara flag-ul --user
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Run
FROM python:3.11-slim

WORKDIR /app

# Copiem bibliotecile instalate direct din site-packages-ul Python-ului
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . .

# Securitate: rula ca un user fara privilegii
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Acum uvicorn va fi gasit in /usr/local/bin, care este in PATH-ul implicit
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
