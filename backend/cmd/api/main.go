package main

import (
	"log"
	"net/http"
	"time"

	"jumper-api/internal/config"
	"jumper-api/internal/db"
	internalhttp "jumper-api/internal/http"
	"jumper-api/internal/logging"
	"jumper-api/internal/repository"
)

func main() {
	logger := logging.New()
	cfg := config.FromEnv()

	pool, err := db.NewPostgres(cfg.DatabaseURL)
	if err != nil {
		logger.Error("db connection failed", "error", err)
		log.Fatal(err)
	}
	defer pool.Close()

	repo := repository.NewScoreRepository(pool)

	handler := internalhttp.NewServer(logger, repo)

	server := &http.Server{
		Addr:              cfg.Addr,
		Handler:           handler,
		ReadHeaderTimeout: 5 * time.Second,
	}

	logger.Info("backend listening", "addr", cfg.Addr)
	log.Fatal(server.ListenAndServe())
}
