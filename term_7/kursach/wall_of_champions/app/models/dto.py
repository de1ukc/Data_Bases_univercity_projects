from typing import List, Optional
from dataclasses import dataclass


# так как получаем мы не словарями, а кортежами порядок важен!

@dataclass
class Country:
    id: int
    name: str


@dataclass
class Season:
    id: int
    season_year: int


@dataclass
class Weather:
    id: int
    status: str


@dataclass
class Pilot:
    first_name: str
    second_name: str
    nickname: str
    country_name: str
    pilots_number: int


@dataclass
class Nickname:
    id: int
    nickname: str
    pilot_id: int


@dataclass
class PilotsRecord:
    id: int
    description: str
    pilot_id: int


@dataclass
class PilotsStatistic:
    id: int
    wins: int
    wdc: int
    points: int
    fastest_laps: int
    pilot_id: int


@dataclass
class Team:
    id: int
    country_id: int
    name: str


@dataclass
class TeamsStatistic:
    id: int
    wcc: int
    team_id: int


@dataclass
class TeamsPilots:
    id: int
    team_id: int
    pilot_id: int
    valid_from: str
    valid_to: str


@dataclass
class Sponsor:
    id: int
    name: str


@dataclass
class TeamSponsor:
    id: int
    team_id: int
    sponsor_id: int
    valid_from: str
    valid_to: str


@dataclass
class Principal:
    id: int
    first_name: str
    second_name: str
    country_id: int


@dataclass
class TeamPrincipal:
    id: int
    team_id: int
    principal_id: int
    valid_from: str
    valid_to: str


@dataclass
class CarEngineManufacturer:
    id: int
    related_team_id: Optional[int]
    name: str


@dataclass
class Car:
    id: int
    engine_supplier_id: int
    name: str


@dataclass
class TeamCar:
    id: int
    team_id: int
    car_id: int
    season_id: int


@dataclass
class RaceType:
    id: int
    type: str


@dataclass
class Track:
    id: int
    circle_length: float
    number_of_circles: int
    name: str
    country_id: int


@dataclass
class TrackRecord:
    id: int
    track_id: int
    description: str


@dataclass
class Race:
    id: int
    track_id: int
    race_date: str
    weather_id: int
    race_type_id: int
    name: str


@dataclass
class RaceStartingGrid:
    id: int
    race_id: int
    team_pilot_id: int
    place: int


@dataclass
class RaceParticipantsResult:
    id: int
    race_id: int
    team_pilot_id: int
    place: int
    lap_time: Optional[str]


@dataclass
class Document:
    id: int
    fact: str
    decision: str
    reason: str


@dataclass
class RaceParticipantsDocument:
    id: int
    race_id: int
    team_pilot_id: int
    document_id: int
    document_date: Optional[str]


@dataclass
class RaceWeek:
    id: int
    valid_from: Optional[str]
    valid_till: Optional[str]
    grand_prix_id: int
    quali_id: int
    sprint_id: Optional[int]
    season_id: int
