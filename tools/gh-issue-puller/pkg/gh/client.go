package gh

import (
	"context"

	"github.com/google/go-github/v67/github"
	"golang.org/x/oauth2"
)

// NewGitHubClient creates a new GitHub client
// If no token is provided, it creates an unauthenticated client
func NewGitHubClient(token string) *github.Client {
	var client *github.Client

	if token != "" {
		ctx := context.Background()
		ts := oauth2.StaticTokenSource(
			&oauth2.Token{AccessToken: token},
		)
		tc := oauth2.NewClient(ctx, ts)
		client = github.NewClient(tc)
	} else {
		client = github.NewClient(nil)
	}

	return client
}

// ValidateClient checks if the GitHub client is properly initialized
func ValidateClient(client *github.Client) error {
	if client == nil {
		return ErrNilGitHubClient
	}
	return nil
}
