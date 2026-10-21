FROM python:3.14-alpine

ENV PYTHONUNBUFFERED=1 

WORKDIR /app

RUN adduser -S -D -H -s /sbin/nplogin -u 10001 appuser

COPY app/app.py .

USER 10001

EXPOSE 8000

CMD ["python","app.py"]