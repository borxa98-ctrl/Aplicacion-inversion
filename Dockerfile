FROM python:3.12-slim

WORKDIR /app

COPY InvestAI_SOURCE.zip /tmp/InvestAI_SOURCE.zip

RUN python - <<'PY'
import zipfile
from pathlib import Path

zip_path = Path('/tmp/InvestAI_SOURCE.zip')
out = Path('/opt/source')
out.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(zip_path) as z:
    z.extractall(out)
roots = [p for p in out.iterdir() if p.is_dir()]
if len(roots) != 1:
    raise RuntimeError(f"No se pudo identificar la raíz del proyecto: {roots}")
root = roots[0]
backend = root / 'backend'
if not (backend / 'requirements.txt').is_file():
    raise RuntimeError(f"No existe backend/requirements.txt en {backend}")
if not (backend / 'server.py').is_file():
    raise RuntimeError(f"No existe backend/server.py en {backend}")
print(f"Proyecto detectado: {root}")
print(f"Backend detectado: {backend}")
PY

RUN ROOT="$(find /opt/source -mindepth 1 -maxdepth 1 -type d -print -quit)" \
    && pip install --no-cache-dir -r "$ROOT/backend/requirements.txt" \
    && cp "$ROOT/backend/server.py" /app/server.py

EXPOSE 8000

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
