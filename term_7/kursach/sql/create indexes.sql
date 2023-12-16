CREATE INDEX idx_btree_pilots_second_name ON pilots(second_name);

CREATE INDEX idx_btree_teams_name ON teams(name);
CREATE INDEX idx_btree_tracks_name ON tracks(name);


CREATE INDEX idx_hash_pilots_statistic_wins ON pilots_statistic USING HASH(wins);

CREATE INDEX idx_hash_champions_wdc ON champions USING HASH(wdc);
CREATE INDEX idx_hash_seasons_season_year ON seasons USING HASH(season_year);

CREATE INDEX idx_brin_races_race_date ON races USING BRIN(race_date);