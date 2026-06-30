FROM python@sha256:4d7dd74c5b2d3151fe58eb8ecc9c56be13471a240ce5423ba765b04f8f95ebe8 AS buildtime

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY src ./src 



FROM python@sha256:4d7dd74c5b2d3151fe58eb8ecc9c56be13471a240ce5423ba765b04f8f95ebe8 AS runtime 

WORKDIR /app 

COPY --from=buildtime /install /usr/local

COPY --from=buildtime /app/src ./src 

EXPOSE 8080

RUN groupadd -g 10001 apigroup && \
useradd -u 10000 -g apigroup apiuser && \
chown -R apiuser:apigroup /app 

USER apiuser 

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
