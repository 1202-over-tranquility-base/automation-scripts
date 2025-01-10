# Auto Git Commit Automation

Automate your Git commit messages using Large Language Models (LLMs) with the provided scripts. This README outlines the setup required to integrate these scripts into your development workflow, tailored for different user environments.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Install Dependencies](#2-install-dependencies)
  - [3. Configure Environment Variables](#3-configure-environment-variables)
  - [4. Set Up the Scripts](#4-set-up-the-scripts)
  - [5. Add an Alias](#5-add-an-alias)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Features

- **Automated Commit Messages:** Generate meaningful commit messages based on your code changes using an LLM.
- **Interactive Approval:** Review and approve commit messages before finalizing the commit.
- **Customizable:** Add additional information to commit messages as needed.
- **Cross-Platform Support:** Compatible with Linux, macOS, and Windows (via WSL).

## Prerequisites

Before setting up the automation scripts, ensure you have the following installed:

- **Git:** Version control system.
- **Python 3.7+**
- **Bash Shell:** For Unix-based systems. Windows users can use Git Bash or WSL.
- **OpenAI API Key:** To interact with the LLM for generating commit messages.

## Setup Instructions

### 1. Clone the Repository

Clone your project repository (if not already cloned) and navigate to your project directory:

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```

### 2. Install Dependencies

#### Linux & macOS

1. **Ensure Python and Git are installed:**

   ```bash
   # Check Python
   python3 --version

   # Check Git
   git --version
   ```

2. **Install Python packages:**

   It's recommended to use a virtual environment.

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install --upgrade pip
   pip install openai
   ```

#### Windows

1. **Using Git Bash or WSL:**

   - **Git Bash:**
     - Install [Git for Windows](https://gitforwindows.org/).
   - **WSL:**
     - Install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install).

2. **Ensure Python and Git are installed in your environment:**

   ```bash
   # Check Python
   python --version

   # Check Git
   git --version
   ```

3. **Install Python packages:**

   ```bash
   python -m venv venv
   source venv/Scripts/activate  # For Git Bash
   # or
   source venv/bin/activate      # For WSL
   pip install --upgrade pip
   pip install openai
   ```

### 3. Configure Environment Variables

The Python script relies on the `OPENAI_API_KEY` environment variable to authenticate with the OpenAI API.

#### Linux & macOS

Add the following line to your shell configuration file (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
export OPENAI_API_KEY="your_openai_api_key_here"
```

Apply the changes:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

#### Windows

- **Using Git Bash:**

  Add the following line to your `~/.bashrc` or `~/.bash_profile`:

  ```bash
  export OPENAI_API_KEY="your_openai_api_key_here"
  ```

  Apply the changes:

  ```bash
  source ~/.bashrc
  ```

- **Using WSL:**

  Add the following line to your `~/.bashrc`:

  ```bash
  export OPENAI_API_KEY="your_openai_api_key_here"
  ```

  Apply the changes:

  ```bash
  source ~/.bashrc
  ```

- **Using Windows Environment Variables:**

  1. Open **System Properties**.
  2. Go to **Advanced** > **Environment Variables**.
  3. Under **User variables**, click **New**.
  4. Set **Variable name** to `OPENAI_API_KEY` and **Variable value** to your API key.
  5. Click **OK** to save.

### 4. Set Up the Scripts

1. **Place the Scripts:**

   Ensure both `auto_git_commit.sh` and `generate_commit_message.py` are placed in a directory within your project, for example:

   ```
   your-repo/
   ├── scripts/
   │   ├── auto_git_commit.sh
   │   └── generate_commit_message.py
   ```

2. **Update Script Paths:**

   In `auto_git_commit.sh`, update the `PYTHON_SCRIPT` path to point to the correct location of `generate_commit_message.py`. For example:

   ```bash
   PYTHON_SCRIPT="/path/to/your-repo/scripts/generate_commit_message.py"
   ```

3. **Make the Shell Script Executable:**

   ```bash
   chmod +x scripts/auto_git_commit.sh
   ```

### 5. Add an Alias

To streamline the commit process, add an alias to your shell configuration file.

#### Linux & macOS

Add the following line to your `~/.bashrc`, `~/.zshrc`, or equivalent:

```bash
alias gitauto="/path/to/your-repo/scripts/auto_git_commit.sh"
```

For example:

```bash
alias gitauto="/home/user/coding-projects/scripts/automation/auto-commit/auto_git_commit.sh"
```

Apply the changes:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

#### Windows

- **Using Git Bash or WSL:**

  Add the alias to your `~/.bashrc` or `~/.bash_profile`:

  ```bash
  alias gitauto="/path/to/your-repo/scripts/auto_git_commit.sh"
  ```

  Apply the changes:

  ```bash
  source ~/.bashrc
  ```

## Usage

Once setup is complete, you can use the `gitauto` alias to automate your commit process.

1. **Stage Your Changes:**

   ```bash
   git add .
   ```

2. **Run the Auto Commit Script:**

   ```bash
   gitauto
   ```

3. **Follow the Prompts:**

   - **Approve Commit Message:** Review the generated commit message and approve or reject it.
   - **Add Additional Information:** Optionally append more details to the commit message.
   - **Commit Confirmation:** The script will finalize the commit and add a Git note for reference.

## Troubleshooting

- **OpenAI API Key Issues:**
  - Ensure the `OPENAI_API_KEY` environment variable is correctly set.
  - Verify your API key is active and has sufficient permissions.

- **Script Permissions:**
  - Ensure `auto_git_commit.sh` is executable. Re-run `chmod +x scripts/auto_git_commit.sh` if necessary.

- **Dependencies Missing:**
  - Confirm that Python and required packages (`openai`) are installed in your environment.

- **Path Errors:**
  - Double-check that the `PYTHON_SCRIPT` path in `auto_git_commit.sh` correctly points to `generate_commit_message.py`.

- **Windows Compatibility:**
  - Ensure you're using a compatible shell environment like Git Bash or WSL.
