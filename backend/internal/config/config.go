package config

import "os"

type Config struct {
    Addr        string
    DatabaseURL string
}

func FromEnv() Config {
    return Config{
        Addr:        env("APP_ADDR", ":8080"),
        DatabaseURL: env("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/jumper?sslmode=disable"),
    }
}

func env(k, d string) string {
    if v := os.Getenv(k); v != "" {
        return v
    }
    return d
}
