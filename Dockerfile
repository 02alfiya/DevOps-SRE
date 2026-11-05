FROM python:3.12-slim 

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1


RUN groupadd --system --gid 10001 app \
    && useradd --system --uid 10001 --gid app \
       --no-create-home --shell /usr/sbin/nologin app

WORKDIR /app

COPY app/app.py .

USER 10001:10001

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8080/healthcheck', timeout=2)"]
    
CMD ["python","app.py"]

