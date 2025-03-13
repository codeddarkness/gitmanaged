# Git Repository Manager

A comprehensive CLI tool to manage Git repositories with ease. This tool provides a user-friendly menu interface for performing common Git operations, including specialized utilities for fixing branch rename issues.

## Features

- **Git Status**: View the current state of your repository
- **Commit Management**: Stage and commit changes with version tags
- **Push/Pull Operations**: Easily push to and pull from remotes
- **Branch Management**: Create, switch, rename, and delete branches
- **Branch Rename Fix Utility**: Fix issues with branch renaming and remote branch conflicts
- **Merge Operations**: Multiple merge strategies (regular, fast-forward, squash, rebase)
- **Tag Management**: Create, delete, and push tags
- **Remote Management**: Add, remove, and modify remote repositories
- **Log Viewing**: View repository history in different formats
- **Untracked File Management**: List, add, and clean untracked files
- **File Picker**: Browse, cherry-pick, and compare files across different branches

## Installation

### Automatic Installation (Recommended)

1. Download the installation script:
   ```bash
   curl -O https://raw.githubusercontent.com/your-username/git-manager/main/install.sh
   ```

2. Make it executable:
   ```bash
   chmod +x install.sh
   ```

3. Run the installer:
   ```bash
   ./install.sh
   ```

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/git-manager.git
   ```

2. Move to a suitable location:
   ```bash
   mv git-manager ~/.git-manager
   ```

3. Create a symbolic link:
   ```bash
   ln -s ~/.git-manager/git-manager.sh /usr/local/bin/git-manager
   ```

4. Make the script executable:
   ```bash
   chmod +x ~/.git-manager/git-manager.sh
   ```

## Usage

Simply run the command from within a Git repository:

```bash
git-manager
```

### Main Menu Options

1. **Show git status**: Display the current state of your repository
2. **Commit changes**: Stage and commit files
3. **Push changes**: Push changes to a remote repository
4. **Pull changes**: Pull changes from a remote repository
5. **Branch management**: Manage branches (create, switch, rename, delete)
6. **Fix branch rename issues**: Fix issues with branch renaming
7. **Merge branches**: Merge branches with various strategies
8. **Manage tags**: Create, delete, and push tags
9. **Manage remotes**: Configure remote repositories
10. **View logs**: View repository history
11. **Manage untracked files**: Handle untracked files
12. **Pick files from branches**: Browse and copy files between branches

## Directory Structure

```
.
├── git-manager.sh       # Main script file
├── lib/                 # Library directory
│   ├── colors.sh        # Color definitions
│   ├── common.sh        # Common utilities
│   ├── branch.sh        # Branch management functions
│   ├── commit.sh        # Commit functions
│   ├── merge.sh         # Merge functions
│   ├── tags.sh          # Tag management functions
│   ├── remotes.sh       # Remote management functions
│   ├── logs.sh          # Log viewing functions
│   ├── untracked.sh     # Untracked file management
│   └── file_picker.sh   # File picker functions
├── install.sh           # Installation script
└── README.md            # This file
```

## Solving the Branch Rename Issue

This tool includes a specialized utility to fix the "refusing to delete the current branch" error that can occur when renaming branches. The fix works by:

1. Renaming the local branch to the desired name
2. Properly setting up the remote tracking
3. Handling conflicts with existing remote branches
4. Providing options to force-push or delete conflicting remote branches

To use this feature, select option 6 from the main menu and follow the prompts.

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
