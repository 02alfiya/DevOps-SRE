ARG PYTHON_VERSION=3.14

FROM python:${PYTHON_VERSION}-slim AS builder

WORKDIR /build

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

Run pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt


FROM python:${PYTHON_VERSION}-slim AS runtime

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"
    

WORKDIR /app

RUN useradd --system --no-create-home --shell /usr/sbin/nologin --uid 10001 appuser

COPY --from=builder --chown=appuser:appuser /opt/venv /opt/venv

COPY --chown=appuser:appuser app.py .

USER 10001

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthcheck')" || exit 1

CMD ["python","app.py"]

