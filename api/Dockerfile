FROM python:3.9
 
WORKDIR /code

COPY ./requirements.txt /code/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

COPY ./app /code/app

# Additional Commands for monitoring like Datadog / NewRelic goes here

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
