FROM python:3.12-slim

WORKDIR /opt/investai

COPY InvestAI_SOURCE.zip /tmp/InvestAI_SOURCE.zip

RUN python -c "import zipfile; zipfile.ZipFile('/tmp/InvestAI_SOURCE.zip').extractall('/opt/investai')" \
    && pip install --no-cache-dir -r /opt/investai/backend/requirements.txt \
    && rm /tmp/InvestAI_SOURCE.zip

WORKDIR /opt/investai/backend

ENV PYTHONUNBUFFERED=1
ENV PORT=10000

CMD sh -c 'uvicorn server:app --host 0.0.0.0 --port ${PORT}'
