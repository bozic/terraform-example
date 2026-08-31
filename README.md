# AI-Assisted Terraform Modules

This repository is a practical showcase for building and maintaining Terraform modules with AI coding assistants. It demonstrates how repository instructions, live Terraform Registry context, and GitHub pull requests can work together to produce changes that remain reviewable by people.

The examples currently use Azure modules, but the main subject of this repository is the AI-assisted workflow rather than Terraform implementation details.

## What This Repository Demonstrates

- Giving AI assistants persistent, repository-specific guidance
- Using the Terraform MCP Server to retrieve current provider and module information
- Asking GitHub Copilot to create or update modules within established conventions
- Reviewing AI-generated changes through normal GitHub branches, pull requests, and checks
- Keeping people responsible for architecture, security, cost, and approval decisions

## AI Instruction Files

The repository includes several "README files for AI":

| File | Audience | Purpose |
| --- | --- | --- |
| [`ai-instructions.md`](ai-instructions.md) | All supported assistants | Shared repository structure, conventions, testing expectations, and security rules |
| [`.github/copilot-instructions.md`](.github/copilot-instructions.md) | GitHub Copilot | Directs Copilot to the shared guidance and adds Copilot-specific Git and pull request behavior |
| [`.claude/CLAUDE.md`](.claude/CLAUDE.md) | Claude Code | Directs Claude to the same shared guidance and adds Claude-specific behavior |
| [`tf-docs/`](tf-docs/) | AI assistants and reviewers | Local provider reference material used when working offline or against the repository's pinned provider version |

This arrangement keeps the core rules in one place while allowing each AI client to discover them through its native instruction file. When conventions change, update the shared instructions first and keep client-specific files small.

## Connect the Terraform MCP Server

The [HashiCorp Terraform MCP Server](https://github.com/hashicorp/terraform-mcp-server) connects an MCP-compatible AI assistant to the Terraform Registry and, when configured, HCP Terraform or Terraform Enterprise. This lets the assistant look up current provider versions, resource arguments, modules, and policies instead of relying only on model training data.

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) with [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) and an MCP-capable chat experience
- [Docker](https://www.docker.com/) installed and running

### VS Code Setup

Create `.vscode/mcp.json` in your local workspace:

```json
{
  "servers": {
    "terraform": {
      "type": "stdio",
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "hashicorp/terraform-mcp-server:1.3.0"
      ]
    }
  }
}
```

Start the `terraform` server from VS Code's MCP server controls, then open Copilot Chat in agent mode. The public Terraform Registry tools do not require an HCP Terraform token.

For HCP Terraform or Terraform Enterprise operations, follow HashiCorp's [authenticated VS Code configuration](https://github.com/hashicorp/terraform-mcp-server#usage-with-visual-studio-code). Use VS Code input variables or another secret store for tokens; never commit credentials to this repository.

> The MCP server can expose Terraform data to the connected client and language model. Use trusted clients, review requested tool calls, and verify generated recommendations against your organization's security and compliance requirements.

## Try the Workflow

Open this repository in VS Code and ask Copilot Chat to use the Terraform MCP tools. For example:

```text
Using the Terraform MCP Server, find the latest azurerm provider version and list
the supported arguments for azurerm_virtual_network. Compare them with the local
AI instructions before proposing a module change.
```

Then try a repository task:

```text
Create a feature branch and add an Azure module following the repository AI
instructions. Use Terraform MCP to verify provider arguments, add tests, and
summarize the changes for a pull request. Do not apply infrastructure.
```

The assistant should use both context sources:

1. Repository instructions define how work should fit this project.
2. Terraform MCP provides current upstream Terraform information.
3. GitHub records the branch, discussion, automated checks, and human approval.

## GitHub Collaboration

Treat AI output like any other contribution:

1. Start from a GitHub issue or a clearly scoped prompt.
2. Work on a descriptive branch rather than directly on `main`.
3. Ask the assistant to explain which repository instructions and MCP sources informed the change.
4. Open a pull request that explains the intent and links the relevant issue.
5. Review the code, provider assumptions, security impact, and test results before merging.

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the repository's contribution requirements. The Terraform MCP Server improves context, but it does not replace human review or authorize an infrastructure deployment.

## Further Reading

- [Terraform MCP Server](https://github.com/hashicorp/terraform-mcp-server)
- [Use MCP servers in VS Code](https://code.visualstudio.com/docs/copilot/chat/mcp-servers)
- [Custom instructions for GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- [Model Context Protocol](https://modelcontextprotocol.io/introduction)