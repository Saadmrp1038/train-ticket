package main

import (
	"fmt"
	"net/http"
)

type News struct {
	Title   string `bson:"Title"`
	Content string `bson:"Content"`
}

func hello(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprint(w, `[
                       {"Title": "News Service Complete", "Content": "Congratulations:Your News Service Complete"},
                       {"Title": "Total Ticket System Complete", "Content": "Just a total test"}
                    ]`)
}

func main() {
	http.HandleFunc("/", hello)
	fmt.Println("News service listening on 0.0.0.0:12862")
	http.ListenAndServe("0.0.0.0:12862", nil)
}
