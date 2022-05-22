from typing import Optional
import pymysql
import os

from fastapi import FastAPI

app = FastAPI()

@app.get("/rds")
def read_db():
    host = os.getenv('MYSQL_HOST')
    user = os.getenv('MYSQL_USER')
    password = os.getenv('MYSQL_PASS')
    database = os.getenv('MYSQL_DB')
    print("host, user, database {} {} {}".format(host, user, database))
    connection = pymysql.connect(host, user, password, database)
    with connection:
        cur = connection.cursor()
        cur.execute("SELECT VERSION()")
        version = cur.fetchone()
        print("Database version: {} ".format(version[0]))
        return {"version": version[0]}

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}
