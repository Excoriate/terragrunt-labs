package gh

import (
	"context"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"time"

	"github.com/google/go-github/v67/github"
)

var (
	// ErrNilGitHubClient represents an error when the GitHub client is not initialized
	ErrNilGitHubClient = fmt.Errorf("github client is not initialized")
)

// IssueDetails encapsulates comprehensive information about a GitHub issue
type IssueDetails struct {
	Issue    *github.Issue
	Comments []*github.IssueComment
	Files    []*github.RepositoryContent
}

// IssueConfig defines the configuration parameters for fetching a GitHub issue
type IssueConfig struct {
	// Org represents the GitHub organization
	Org string
	// Repo represents the GitHub repository
	Repo string
	// IssueNum is the unique identifier of the issue
	IssueNum int
	// OutputPath specifies where generated files will be saved
	OutputPath string
}

// DefaultIssueConfig provides a default configuration for issue retrieval
func DefaultIssueConfig() IssueConfig {
	currentDir, err := os.Getwd()
	if err != nil {
		currentDir = "."
	}

	return IssueConfig{
		Org:        "gruntwork-io",
		Repo:       "terragrunt",
		OutputPath: currentDir,
	}
}

// fetchIssueMetadata retrieves the core issue information
func fetchIssueMetadata(ctx context.Context, client *github.Client, config IssueConfig) (*github.Issue, error) {
	issue, resp, err := client.Issues.Get(ctx, config.Org, config.Repo, config.IssueNum)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch issue %d: %w", config.IssueNum, err)
	}
	defer resp.Body.Close()

	return issue, nil
}

// fetchIssueComments retrieves all comments for a specific issue
func fetchIssueComments(ctx context.Context, client *github.Client, config IssueConfig) ([]*github.IssueComment, error) {
	comments, _, err := client.Issues.ListComments(ctx, config.Org, config.Repo, config.IssueNum, nil)
	if err != nil {
		log.Printf("Warning: Could not fetch comments: %v", err)
		return nil, err
	}
	return comments, nil
}

// fetchIssueFiles retrieves files associated with an issue
func fetchIssueFiles(ctx context.Context, client *github.Client, config IssueConfig) ([]*github.RepositoryContent, error) {
	opts := &github.RepositoryContentGetOptions{}
	_, directoryContent, _, err := client.Repositories.GetContents(
		ctx,
		config.Org,
		config.Repo,
		fmt.Sprintf("issues/%d", config.IssueNum),
		opts,
	)
	if err != nil {
		log.Printf("Warning: Could not fetch issue files: %v", err)
		return nil, err
	}
	return directoryContent, nil
}

// FetchIssueDetails comprehensively retrieves all issue-related information
func FetchIssueDetails(client *github.Client, config IssueConfig) (*IssueDetails, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := ValidateClient(client); err != nil {
		return nil, err
	}

	issue, err := fetchIssueMetadata(ctx, client, config)
	if err != nil {
		return nil, err
	}

	comments, _ := fetchIssueComments(ctx, client, config)
	files, _ := fetchIssueFiles(ctx, client, config)

	log.Printf("Issue Details:")
	log.Printf("   Issue Number:   #%d", issue.GetNumber())
	log.Printf("   Comments:       %d", len(comments))
	log.Printf("   Attached Files: %d", len(files))

	return &IssueDetails{
		Issue:    issue,
		Comments: comments,
		Files:    files,
	}, nil
}

// downloadFile handles the downloading of a single file
func downloadFile(file *github.RepositoryContent, attachedFilesDir string) error {
	filename := filepath.Join(attachedFilesDir, file.GetName())

	if _, err := os.Stat(filename); err == nil {
		log.Printf("Skipping existing file: %s", filename)
		return nil
	}

	content, err := file.GetContent()
	if err != nil {
		return fmt.Errorf("failed to get file content %s: %v", file.GetName(), err)
	}

	out, err := os.Create(filename)
	if err != nil {
		return fmt.Errorf("failed to create file %s: %v", filename, err)
	}
	defer out.Close()

	if _, err = out.WriteString(content); err != nil {
		return fmt.Errorf("failed to write file %s: %v", filename, err)
	}

	log.Printf("Downloaded file: %s", filename)
	return nil
}

// DownloadIssueFiles downloads all files associated with an issue
func DownloadIssueFiles(details *IssueDetails, outputPath string) error {
	if len(details.Files) == 0 {
		log.Printf("No files attached to this issue.")
		return nil
	}

	attachedFilesDir := filepath.Join(outputPath, "attached-files")
	if err := os.MkdirAll(attachedFilesDir, 0755); err != nil {
		return fmt.Errorf("failed to create attached files directory: %w", err)
	}

	for _, file := range details.Files {
		if err := downloadFile(file, attachedFilesDir); err != nil {
			log.Printf("Error downloading file: %v", err)
		}
	}

	return nil
}

// ConvertIssueToMarkdown generates a comprehensive markdown representation of the issue
func ConvertIssueToMarkdown(details *IssueDetails, config IssueConfig) error {
	if details == nil || details.Issue == nil {
		return fmt.Errorf("issue details cannot be nil")
	}

	filename := fmt.Sprintf("GH_ISSUE_%s_%s_%d.md", config.Org, config.Repo, details.Issue.GetNumber())
	markdownFilepath := filepath.Join(config.OutputPath, filename)

	content := generateMarkdownContent(details, config)

	if err := DownloadIssueFiles(details, config.OutputPath); err != nil {
		log.Printf("Error downloading issue files: %v", err)
	}

	if err := os.WriteFile(markdownFilepath, []byte(content), 0644); err != nil {
		log.Printf("Failed to write markdown file: %v", err)
		return err
	}

	log.Printf("Markdown file successfully created at %s", markdownFilepath)
	return nil
}

// generateMarkdownContent creates the markdown text for the issue
func generateMarkdownContent(details *IssueDetails, config IssueConfig) string {
	return fmt.Sprintf(`# Issue #%d: %s

## Metadata
- **Organization**: %s
- **Repository**: %s
- **Author**: %s
- **State**: %s
- **Created At**: %s
- **Updated At**: %s
- **URL**: %s

%s

%s
`,
		details.Issue.GetNumber(),
		details.Issue.GetTitle(),
		config.Org,
		config.Repo,
		details.Issue.GetUser().GetLogin(),
		details.Issue.GetState(),
		details.Issue.GetCreatedAt().Format(time.RFC3339),
		details.Issue.GetUpdatedAt().Format(time.RFC3339),
		details.Issue.GetHTMLURL(),
		generateConversationsSection(details),
		generateFilesSection(details),
	)
}

// generateConversationsSection creates the markdown section for issue conversations
func generateConversationsSection(details *IssueDetails) string {
	conversationsSection := "## Conversations\n\n"
	if len(details.Comments) == 0 {
		return conversationsSection + "No conversations on this issue.\n\n"
	}

	conversationsSection += fmt.Sprintf("### Original Issue Description\n\n**Author**: %s\n**Created At**: %s\n\n%s\n\n",
		details.Issue.GetUser().GetLogin(),
		details.Issue.GetCreatedAt().Format(time.RFC3339),
		details.Issue.GetBody(),
	)

	for i, comment := range details.Comments {
		conversationsSection += fmt.Sprintf("### Comment #%d\n\n**Author**: %s\n**Created At**: %s\n\n%s\n\n",
			i+1,
			comment.GetUser().GetLogin(),
			comment.GetCreatedAt().Format(time.RFC3339),
			comment.GetBody(),
		)
	}

	return conversationsSection
}

// generateFilesSection creates the markdown section for attached files
func generateFilesSection(details *IssueDetails) string {
	filesSection := "## Attached Files\n\n"
	if len(details.Files) == 0 {
		return filesSection + "No files attached to this issue.\n\n"
	}

	filesSection += "| Filename | Size | Download Path |\n"
	filesSection += "|----------|------|---------------|\n"

	for _, file := range details.Files {
		downloadPath := filepath.Join("attached-files", file.GetName())
		filesSection += fmt.Sprintf("| `%s` | %d bytes | `%s` |\n",
			file.GetName(),
			file.GetSize(),
			downloadPath,
		)
	}

	return filesSection + "\nFiles are downloaded in the `attached-files/` directory.\n"
}
