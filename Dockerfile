# Invest AI — Render backend
FROM python:3.12-slim

WORKDIR /opt/investai

# El ZIP contiene el backend y el proyecto Android.
COPY InvestAI_SOURCE.zip /tmp/InvestAI_SOURCE.zip

# Extraer primero, para separar los errores de ZIP de los de pip.
RUN python -c "import zipfile; z=zipfile.ZipFile('/tmp/InvestAI_SOURCE.zip'); z.extractall('/opt/investai'); z.close()"

# Instalar únicamente las dependencias reales del backend.
WORKDIR /opt/investai/backend
RUN python -m pip install --no-cache-dir --upgrade pip && \
    python -m pip install --no-cache-dir -r requirements.txt

RUN rm -f /tmp/InvestAI_SOURCE.zip

ENV PYTHONUNBUFFERED=1

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
