from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, UniqueConstraint, DateTime, DECIMAL, Text, \
    CheckConstraint
from sqlalchemy.orm import declarative_base, sessionmaker, relationship

Base = declarative_base()


class Country(Base):
    __tablename__ = 'country'
    id = Column(Integer, primary_key=True)
    name = Column(String(256), nullable=False, unique=True)


class Season(Base):
    __tablename__ = 'seasons'
    id = Column(Integer, primary_key=True)
    season_year = Column(Integer, nullable=False, unique=True)


class Weather(Base):
    __tablename__ = 'weather'
    id = Column(Integer, primary_key=True)
    status = Column(String(64), nullable=False, unique=True)


class Pilot(Base):
    __tablename__ = 'pilots'
    id = Column(Integer, primary_key=True)
    first_name = Column(String(30), nullable=False)
    second_name = Column(String(30), nullable=False)
    last_name = Column(String(30), nullable=False)
    country_id = Column(Integer, ForeignKey('country.id'), nullable=False)
    pilots_number = Column(Integer,
                           CheckConstraint('pilots_number > 0 AND pilots_number < 100'),
                           nullable=False,
                           unique=True,
                           )

    country = relationship('Country', back_populates='pilots')
    nicknames = relationship('Nickname', back_populates='pilot')
    records = relationship('PilotsRecord', back_populates='pilot')
    statistic = relationship('PilotsStatistic', back_populates='pilot')


class Nickname(Base):
    __tablename__ = 'nicknames'
    id = Column(Integer, primary_key=True)
    nickname = Column(String(256), nullable=False, unique=True)
    pilot_id = Column(Integer, ForeignKey('pilots.id'), nullable=False)

    pilot = relationship('Pilot', back_populates='nicknames')


class PilotsRecord(Base):
    __tablename__ = 'pilots_records'
    id = Column(Integer, primary_key=True)
    description = Column(String(2048), nullable=False)
    pilot_id = Column(Integer, ForeignKey('pilots.id'), nullable=False)

    pilot = relationship('Pilot', back_populates='records')


class PilotsStatistic(Base):
    __tablename__ = 'pilots_statistic'
    id = Column(Integer, primary_key=True)
    wins = Column(Integer, nullable=False)
    wdc = Column(Integer, nullable=False)
    points = Column(Integer, nullable=False)
    fastest_laps = Column(Integer, nullable=False)
    pilot_id = Column(Integer, ForeignKey('pilots.id'), nullable=False)

    pilot = relationship('Pilot', back_populates='statistic')


class Team(Base):
    __tablename__ = 'teams'
    id = Column(Integer, primary_key=True)
    country_id = Column(Integer, ForeignKey('country.id'), nullable=False)
    name = Column(String(512), nullable=False, unique=True)

    country = relationship('Country', back_populates='teams')


class TeamsStatistic(Base):
    __tablename__ = 'teams_statistic'
    id = Column(Integer, primary_key=True)
    wcc = Column(Integer, nullable=False)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)

    team = relationship('Team', back_populates='statistic')


class TeamsPilots(Base):
    __tablename__ = 'teams_pilots'
    id = Column(Integer, primary_key=True)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    pilot_id = Column(Integer, ForeignKey('pilots.id'), nullable=False)
    valid_from = Column(DateTime, nullable=False)
    valid_to = Column(DateTime, nullable=False)

    team = relationship('Team', back_populates='pilots')
    pilot = relationship('Pilot', back_populates='teams')


class Sponsor(Base):
    __tablename__ = 'sponsors'
    id = Column(Integer, primary_key=True)
    name = Column(String(512), nullable=False, unique=True)


class TeamSponsor(Base):
    __tablename__ = 'team_sponsor'
    id = Column(Integer, primary_key=True)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    sponsor_id = Column(Integer, ForeignKey('sponsors.id'), nullable=False)
    valid_from = Column(DateTime, nullable=False)
    valid_to = Column(DateTime, nullable=False)

    team = relationship('Team', back_populates='sponsors')
    sponsor = relationship('Sponsor', back_populates='teams')


class Principal(Base):
    __tablename__ = 'principals'
    id = Column(Integer, primary_key=True)
    first_name = Column(String(64), nullable=False)
    second_name = Column(String(64), nullable=False)
    country_id = Column(Integer, ForeignKey('country.id'), nullable=False)

    country = relationship('Country', back_populates='principals')


class TeamPrincipal(Base):
    __tablename__ = 'team_principal'
    id = Column(Integer, primary_key=True)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    principal_id = Column(Integer, ForeignKey('principals.id'), nullable=False)
    valid_from = Column(DateTime, nullable=False)
    valid_to = Column(DateTime, nullable=False)

    team = relationship('Team', back_populates='principal_teams')
    principal = relationship('Principal', back_populates='team_principals')


class CarEngineManufacturer(Base):
    __tablename__ = 'car_engine_manufacturer'
    id = Column(Integer, primary_key=True)
    related_team_id = Column(Integer, ForeignKey('teams.id'))
    name = Column(String(512), nullable=False, unique=True)

    team = relationship('Team', back_populates='engine_manufacturer')


class Car(Base):
    __tablename__ = 'car'
    id = Column(Integer, primary_key=True)
    engine_supplier_id = Column(Integer, ForeignKey('car_engine_manufacturer.id'), nullable=False)
    name = Column(String(128))

    engine_supplier = relationship('CarEngineManufacturer', back_populates='cars')


class TeamCar(Base):
    __tablename__ = 'team_car'
    id = Column(Integer, primary_key=True)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    car_id = Column(Integer, ForeignKey('car.id'), nullable=False)
    season_id = Column(Integer, ForeignKey('seasons.id'), nullable=False)

    team = relationship('Team', back_populates='team_cars')
    car = relationship('Car', back_populates='teams')
    season = relationship('Season', back_populates='teams')


class RaceType(Base):
    __tablename__ = 'race_types'
    id = Column(Integer, primary_key=True)
    type = Column(String(64), nullable=False, unique=True)


class Track(Base):
    __tablename__ = 'tracks'
    id = Column(Integer, primary_key=True)
    circle_length = Column(DECIMAL, nullable=False)
    number_of_circles = Column(Integer, nullable=False)
    name = Column(String(256), nullable=False, unique=True)
    country_id = Column(Integer, ForeignKey('country.id'), nullable=False)

    country = relationship('Country', back_populates='tracks')


class TrackRecord(Base):
    __tablename__ = 'track_records'
    id = Column(Integer, primary_key=True)
    track_id = Column(Integer, ForeignKey('tracks.id'), nullable=False)
    description = Column(Text, nullable=False)

    track = relationship('Track', back_populates='records')


class Race(Base):
    __tablename__ = 'races'
    id = Column(Integer, primary_key=True)
    track_id = Column(Integer, ForeignKey('tracks.id'), nullable=False)
    race_date = Column(DateTime, nullable=False)
    weather_id = Column(Integer, ForeignKey('weather.id'), nullable=False)
    race_type_id = Column(Integer, ForeignKey('race_types.id'), nullable=False)
    name = Column(String(256), nullable=False, unique=True)

    track = relationship('Track', back_populates='races')
    weather = relationship('Weather', back_populates='races')
    race_type = relationship('RaceType', back_populates='races')


class RaceStartingGrid(Base):
    __tablename__ = 'race_starting_grids'
    id = Column(Integer, primary_key=True)
    race_id = Column(Integer, ForeignKey('races.id'), nullable=False)
    team_pilot_id = Column(Integer, ForeignKey('teams_pilots.id'), nullable=False)
    place = Column(Integer, nullable=False)

    race = relationship('Race', back_populates='starting_grid')
    team_pilot = relationship('TeamsPilots', back_populates='starting_grid')


class RaceParticipantsResult(Base):
    __tablename__ = 'race_participants_results'
    id = Column(Integer, primary_key=True)
    race_id = Column(Integer, ForeignKey('races.id'), nullable=False)
    team_pilot_id = Column(Integer, ForeignKey('teams_pilots.id'), nullable=False)
    place = Column(Integer, nullable=False)
    lap_time = Column(String(32))

    race = relationship('Race', back_populates='results')
    team_pilot = relationship('TeamsPilots', back_populates='results')


class Document(Base):
    __tablename__ = 'documents'
    id = Column(Integer, primary_key=True)
    fact = Column(Text, nullable=False)
    decision = Column(Text, nullable=False)
    reason = Column(Text, nullable=False)


class RaceParticipantsDocument(Base):
    __tablename__ = 'race_participants_documents'
    id = Column(Integer, primary_key=True)
    race_id = Column(Integer, ForeignKey('races.id'), nullable=False)
    team_pilot_id = Column(Integer, ForeignKey('teams_pilots.id'), nullable=False)
    document_id = Column(Integer, ForeignKey('documents.id'), nullable=False)
    document_date = Column(DateTime)

    race = relationship('Race', back_populates='documents')
    team_pilot = relationship('TeamsPilots', back_populates='documents')
    document = relationship('Document', back_populates='races')


class RaceWeek(Base):
    __tablename__ = 'race_weeks'
    id = Column(Integer, primary_key=True)
    valid_from = Column(DateTime)
    valid_till = Column(DateTime)
    grand_prix_id = Column(Integer, ForeignKey('races.id'), nullable=False)
    quali_id = Column(Integer, ForeignKey('races.id'), nullable=False)
    sprint_id = Column(Integer, ForeignKey('races.id'))
    season_id = Column(Integer, ForeignKey('seasons.id'), nullable=False)

    grand_prix = relationship('Race', foreign_keys=[grand_prix_id])
    quali = relationship('Race', foreign_keys=[quali_id])
    sprint = relationship('Race', foreign_keys=[sprint_id])
    season = relationship('Season', back_populates='race_weeks')
