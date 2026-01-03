package http

import (
    "encoding/json"
    "log/slog"
    "net/http"

    "jumper-api/internal/repository"
)

type createScoreRequest struct {
    Player string `json:"player"`
    Points int    `json:"points"`
}

func NewServer(log *slog.Logger, repo *repository.ScoreRepository) http.Handler {
    mux := http.NewServeMux()

    mux.HandleFunc("/health", func(w http.ResponseWriter, _ *http.Request) {
        w.WriteHeader(http.StatusOK)
        w.Write([]byte("ok"))
    })

    mux.HandleFunc("/scores", func(w http.ResponseWriter, r *http.Request) {
        switch r.Method {
        case http.MethodGet:
            scores, err := repo.List()
            if err != nil {
                log.Error("list scores failed", "error", err)
                w.WriteHeader(http.StatusInternalServerError)
                return
            }
            json.NewEncoder(w).Encode(scores)

        case http.MethodPost:
            var req createScoreRequest
            if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
                log.Warn("invalid request body", "error", err)
                w.WriteHeader(http.StatusBadRequest)
                return
            }

            if err := repo.Insert(req.Player, req.Points); err != nil {
                log.Error("insert score failed", "error", err)
                w.WriteHeader(http.StatusInternalServerError)
                return
            }

            log.Info("score inserted", "player", req.Player, "points", req.Points)
            w.WriteHeader(http.StatusCreated)

        default:
            w.WriteHeader(http.StatusMethodNotAllowed)
        }
    })

    return mux
}
