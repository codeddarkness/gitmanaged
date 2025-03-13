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

## Version History

The project has evolved through several versions:

- **v1**: Initial version with basic Git operations
- **v2**: Added tag versioning and merge branches functionality
- **v5**: Modular version with libraries split into separate files

The main script (`git-manager.sh`) is now designed to work with separate library files for better maintainability. The file `versions/v2_git-manager.sh` is kept as a standalone demo version that includes all functionality in a single file.

## Installation

### Quick Setup (Using the Setup Script)

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/git-manager.git
   cd git-manager
   ```

2. Run the setup script:
   ```bash
   chmod +x setup-script.sh
   ./setup-script.sh
   ```

3. The setup script will:
   - Check for required libraries
   - Create the necessary directory structure
   - Copy all library files to their correct locations
   - Make the script executable
   - Create a symbolic link (if possible)

### Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/git-manager.git
   ```

2. Move to a suitable location:
   ```bash
   mv git-manager ~/.git-manager
   ```

3. Create the lib directory:
   ```bash
   mkdir -p ~/.git-manager/lib
   ```

4. Copy the library files:
   ```bash
   cp git-manager/lib-*.sh ~/.git-manager/lib/
   ```

5. Rename the library files:
   ```bash
   cd ~/.git-manager/lib/
   for file in lib-*.sh; do mv "$file" "${file#lib-}"; done
   ```

6. Create a symbolic link:
   ```bash
   ln -s ~/.git-manager/git-manager.sh /usr/local/bin/git-manager
   ```

7. Make the script executable:
   ```bash
   chmod +x ~/.git-manager/git-manager.sh
   ```

### Using the Standalone Demo Version

If you prefer to use the standalone demo version (all functionality in a single file):

1. Copy the demo version to a location of your choice:
   ```bash
   cp versions/v2_git-manager.sh ~/git-manager.sh
   ```

2. Make it executable:
   ```bash
   chmod +x ~/git-manager.sh
   ```

3. Run it from any Git repository:
   ```bash
   ~/git-manager.sh
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
├── git-manager.sh                # Main script file (modular version)
├── lib-*.sh                      # Library files (with 'lib-' prefix)
├── versions/                     # Previous versions
│   ├── v1_git-manager.sh         # Initial version
│   ├── v2_git-manager.sh         # Enhanced version (standalone demo)
│   └── v5_git-manager.sh         # Modular version
├── setup-script.sh               # Installation script
└── README.md                     # This file
```

## Improvements and Future Features

The modular version has some improvements over the standalone demo version (`versions/v2_git-manager.sh`):

1. **Better Organization**: Each functionality is now in its own file for easier maintenance.
2. **Persistent Submenus**: All submenus now stay open until you explicitly return to the main menu.
3. **File Picker**: Added a new feature to browse, cherry-pick, and compare files across different branches.

Features that could be added in future versions:

1. **Stash Management**: Save and apply stashes
2. **Git Flow Support**: Integration with Git Flow branching model
3. **Git Hooks Management**: Create and manage Git hooks
4. **Interactive Rebasing**: Support for interactive rebasing operations
5. **Multiple Repository Management**: Manage multiple Git repositories from a single interface
6. **Conflict Resolution**: Improved tools for resolving merge conflicts
7. **History Visualization**: Better visualization of repository history
8. **Configuration Management**: Interface for managing Git configuration settings

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
