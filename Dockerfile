FROM python:3.10 AS build

WORKDIR /app

COPY flask_app/requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY flask_app/ /app/
COPY models/vectorizer.pkl /app/models/vectorizer.pkl

RUN python -m nltk.downloader stopwords wordnet

#Stage 2: Final stage

FROM python:3.10-slim As final

WORKDIR /app

COPY --from=build /app /app

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000","--timeout","120", "app:app"]
