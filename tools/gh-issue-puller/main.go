package main

import (
	"fmt"
	"log"
	"os"

	"github.com/Excoriate/terragrunt-labs/tools/gh-issue-puller/pkg/gh"
	"github.com/spf13/cobra"
)

var (
	org      string
	repo     string
	issueNum int
	output   string
)

func main() {
	var rootCmd = &cobra.Command{
		Use:   "gh-issue-puller",
		Short: "A CLI tool to pull GitHub issues and convert them to markdown",
	}

	var pullCmd = &cobra.Command{
		Use:   "pull",
		Short: "Pull a GitHub issue and save it as markdown",
		Run: func(cmd *cobra.Command, args []string) {
			if issueNum == 0 {
				log.Fatal("Issue number is required")
			}

			config := gh.DefaultIssueConfig()
			config.Org = org
			config.Repo = repo
			config.IssueNum = issueNum

			// If output is not specified, use current directory
			if output != "" {
				config.OutputPath = output
			}

			client := gh.NewGitHubClient(os.Getenv("GITHUB_TOKEN"))

			issueDetails, err := gh.FetchIssueDetails(client, config)
			if err != nil {
				log.Fatalf("Error fetching issue: %v", err)
			}

			err = gh.ConvertIssueToMarkdown(issueDetails, config)
			if err != nil {
				log.Fatalf("Error converting issue to markdown: %v", err)
			}

			fmt.Printf("Issue #%d successfully saved to %s\n", issueNum, config.OutputPath)
		},
	}

	pullCmd.Flags().StringVarP(&org, "org", "o", "gruntwork-io", "GitHub organization")
	pullCmd.Flags().StringVarP(&repo, "repo", "r", "terragrunt", "GitHub repository")
	pullCmd.Flags().IntVarP(&issueNum, "issue", "i", 0, "GitHub issue number")
	pullCmd.Flags().StringVarP(&output, "output", "p", "", "Output path for markdown file (defaults to current directory)")

	rootCmd.AddCommand(pullCmd)

	if err := rootCmd.Execute(); err != nil {
		log.Fatal(err)
	}
}
