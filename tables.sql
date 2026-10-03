PRAGMA foreign_keys = ON;

CREATE TABLE competitions (
    id INTEGER PRIMARY KEY,
    api_competition_id INTEGER NOT NULL UNIQUE,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL
);

CREATE TABLE seasons (
    id INTEGER PRIMARY KEY,
    api_season_id INTEGER UNIQUE,
    competition_id INTEGER NOT NULL,
    label TEXT NOT NULL,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,

    FOREIGN KEY (competition_id) REFERENCES competitions(id),
    UNIQUE (competition_id, start_date),
    CHECK (end_date >= start_date)
);

CREATE TABLE teams (
    id INTEGER PRIMARY KEY,
    api_team_id INTEGER NOT NULL UNIQUE,
    name TEXT NOT NULL
);

CREATE TABLE matches (
    id INTEGER PRIMARY KEY,
    api_match_id INTEGER NOT NULL UNIQUE,
    season_id INTEGER NOT NULL,
    utc_date TEXT NOT NULL,
    stage TEXT,
    status TEXT NOT NULL,
    home_team_id INTEGER NOT NULL,
    away_team_id INTEGER NOT NULL,
    home_score INTEGER,
    away_score INTEGER,

    FOREIGN KEY (season_id) REFERENCES seasons(id),
    FOREIGN KEY (home_team_id) REFERENCES teams(id),
    FOREIGN KEY (away_team_id) REFERENCES teams(id),

    CHECK (home_team_id <> away_team_id),
    CHECK (home_score IS NULL OR home_score >= 0),
    CHECK (away_score IS NULL OR away_score >= 0)
);

CREATE INDEX idx_matches_season_date
    ON matches (season_id, utc_date);

CREATE INDEX idx_matches_home_team
    ON matches (home_team_id);

CREATE INDEX idx_matches_away_team
    ON matches (away_team_id);