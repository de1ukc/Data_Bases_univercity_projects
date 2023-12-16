from sqlalchemy import create_engine, text


class PostgreSQLConnection:
    def __init__(self, host, port, user, password, database, echo=True):
        self.database_url = f"postgresql://{user}:{password}@{host}:{port}/{database}"
        self.engine = create_engine(self.database_url, echo=echo)
        # self.connection = self.engine.connect()

    def execute_query(self, query: text, params: dict = None):
        with self.engine.connect() as connection:
            try:
                if params:
                    result = connection.execute(query, params)
                else:
                    result = connection.execute(query)

                return result.fetchall()

            except Exception as e:
                print(f"Error executing query {query}: {e}")
                return None
