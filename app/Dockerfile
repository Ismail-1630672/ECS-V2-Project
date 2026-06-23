FROM python@sha256:4d7dd74c5b2d3151fe58eb8ecc9c56be13471a240ce5423ba765b04f8f95ebe8 AS buildtime

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/downloads -r requirements.txt



FROM python@sha256:4d7dd74c5b2d3151fe58eb8ecc9c56be13471a240ce5423ba765b04f8f95ebe8 AS runtime 

WORKDIR /app 

COPY --from=buildtime /downloads /usr/local

COPY . .

EXPOSE 8080

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8080"]
