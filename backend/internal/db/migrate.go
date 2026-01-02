package db

import "database/sql"

func RunMigrations(db *sql.DB) error {
    _, err := db.Exec(`
        CREATE TABLE IF NOT EXISTS scores (
            id SERIAL PRIMARY KEY,
            player TEXT NOT NULL,
            points INT NOT NULL,
            created_at TIMESTAMP DEFAULT NOW()
        )
    `)
    return err
}
