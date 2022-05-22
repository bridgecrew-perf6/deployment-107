from typing import Optional
import pymysql
import os

from fastapi import FastAPI

app = FastAPI()

@app.get("/rds")
def read_db():
    host = os.getenv('MYSQL_HOST')
    user = os.getenv('MYSQL_USER')
    passwd = os.getenv('MYSQL_PASS')
    database = os.getenv('MYSQL_DB')
    print("host, user, database {} {} {}".format(host, user, database))


    connection = pymysql.connect(host=host,
                                user=user,
                                password=passwd,
                                database=database,
                                cursorclass=pymysql.cursors.DictCursor)

    with connection:
        with connection.cursor() as cursor:
            sql = "SELECT VERSION()"
            cursor.execute(sql)
            result = cursor.fetchone()
            print(result)
            return {"version": result[0]}

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}
