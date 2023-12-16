from app.db.psql import PsqlDb
from sqlalchemy import text
from app.models.dto import Pilot


class PilotsService:
    def __init__(self):
        self.__db = PsqlDb()

    def get_all_pilots(self) -> list[Pilot]:
        query: text = text("""select first_name, second_name,n.nickname, c.name as country_name, pilots_number
from pilots p
left join country c on c.id=p.country_id
left join nicknames n on n.pilot_id=p.id;""")
        params: dict = {}

        response = self.__db.execute_query(query=query, params=params)

        pilots: list[Pilot] = [Pilot(*row) for row in response]

        return pilots
