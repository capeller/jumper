package repository

import "database/sql"

type Score struct {
    ID     int    `json:"id"`
    Player string `json:"player"`
    Points int    `json:"points"`
}

type ScoreRepository struct {
    db *sql.DB
}

func NewScoreRepository(db *sql.DB) *ScoreRepository {
    return &ScoreRepository{db: db}
}

func (r *ScoreRepository) Insert(player string, points int) error {
    _, err := r.db.Exec(
        "INSERT INTO scores (player, points) VALUES ($1, $2)",
        player, points,
    )
    return err
}

func (r *ScoreRepository) List() ([]Score, error) {
    rows, err := r.db.Query("SELECT id, player, points FROM scores ORDER BY id")
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var scores []Score
    for rows.Next() {
        var s Score
        if err := rows.Scan(&s.ID, &s.Player, &s.Points); err != nil {
            return nil, err
        }
        scores = append(scores, s)
    }
    return scores, nil
}
