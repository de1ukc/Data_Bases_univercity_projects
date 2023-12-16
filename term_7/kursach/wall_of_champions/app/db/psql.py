from dotenv import load_dotenv
import os

from app.db.connector import PostgreSQLConnection
from sqlalchemy.sql import text

load_dotenv()


class PsqlDb:

    def __init__(self):
        host = os.getenv("POSTGRES_HOST")
        port = os.getenv("POSTGRES_PORT")
        user = os.getenv("POSTGRES_USER")
        password = os.getenv("POSTGRES_PASSWORD")
        database = os.getenv("POSTGRES_DB")

        self.__db_connection = PostgreSQLConnection(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database
        )

    def execute_query(self, query: text, params: dict):
        return self.__db_connection.execute_query(query=query, params=params)
