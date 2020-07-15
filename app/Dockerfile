FROM python:3-slim AS builder
ADD . /app
WORKDIR /app
RUN pip3 install --upgrade pip
RUN pip install -r ./requirements.txt

FROM gcr.io/distroless/python3
COPY --from=builder /app /app
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
WORKDIR /app
ENV PYTHONPATH=/usr/local/lib/python3.8/site-packages
CMD ["app.py"]