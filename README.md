# Student workspace

This repository contains the base image for the local backend development course at IUT de Dijon, as well as a guide for using it to develop the target application.

> Since it's for local development, **do not use the image for production**

This environment provides the modern tools you need to create your application locally:

- [PHP](https://www.php.net): the server language your app will use
- [FrankenPHP](https://frankenphp.dev): NGINX/Apache replacement
- [Composer](https://getcomposer.org): PHP package manager
- [Bun](https://bun.com): JavaScript runtime and replacement for Node.js/npm
- [PostgreSQL](https://www.postgresql.org): the database
- [Redis](https://redis.io/solutions/caching/): cache and queue
- [Mailpit](https://mailpit.axllent.org): local SMTP server for email development

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Code editor ([Visual Studio Code](https://code.visualstudio.com), [Zed](https://zed.dev), [PhpStorm](https://www.jetbrains.com/phpstorm/), ...)
- [Task](https://taskfile.dev)
- Ports must be free
    - 8081: web application
    - 5173: [Vite](https://vite.dev) Hot Module Reload (HMR)
    - 5434: [PostgreSQL](https://www.postgresql.org) database
    - 6379: [Redis](https://redis.io/solutions/caching/) port
    - 8025: [Mailpit](https://mailpit.axllent.org) SMTP interface

### macOS requirements
macOS users must install [Homebrew](https://brew.sh) then install Task using [brew](https://taskfile.dev/docs/installation#homebrew).

### Windows requirements
Windows users must install WSL 2 and enable Docker Desktop’s WSL 2 integration for their Ubuntu distribution. Keep the project files inside the **WSL filesystem**, not under `/mnt/c/`; otherwise, file access and hot reloading can be painfully slow.

- Open Windows Terminal as an administrator.
- Run the `wsl --install -d Ubuntu-26.04` command
- Restart your computer with the `Restart-Computer` command.
- Create your Ubuntu user. **Keep the password.**
- Install [Task](https://taskfile.dev) within Ubuntu with [APT](https://taskfile.dev/docs/installation#apt) 
- Configure Docker Desktop to use the WSL integration: *settings > resources > WSL integration*

> Your project will live **exclusively** inside the WSL Ubuntu

### Editor extensions
#### Visual Studio Code
- [WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [Laravel](https://marketplace.visualstudio.com/items?itemName=laravel.vscode-laravel)

The Laravel extension needs the following configuration
- open Command Palette (CMD + SHIFT + P)
- select Laravel: Configure Docker Environment
- select `weather-application`
- write /app
- select Global
- if override asked, select Yes

> For Windows users, the Docker & Laravel extensions must be installed inside the WSL editor version that appears after CMD + SHIFT + P > WSL: Connect to WSL using Distro and select Ubuntu 26.04

## Prepare the project
In your environment (macOS or Ubuntu on WSL), create a directory for the project (for example, *iut-weather*).

```sh
cd ~
mkdir iut-weather
```

In this directory, copy the contents of this repository's `local/` directory, then run the commands below to start the Docker environment and create the project with the Laravel installer.

```bash
# Create the containers
task up

# Open a terminal inside the app/PHP container
task term

# Initialize the project from the container terminal
/usr/local/bin/install.sh
```

The `install.sh` command launches the Laravel installer wizard. Select the following options during the process:

- Do you want to use a starter kit? → **No**
- Which frontend stack do you want to build on? → **Blade**

Your application is now available at [localhost:8081](http://localhost:8081).

## Git
You can use any Git provider, but you must use SSH to connect to it.

You can follow the [GitHub authentication guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) to create an SSH key for other providers as well.

### Windows user
Windows users must use **WSL Ubuntu-26.04** to perform Git operations.

Follow the [GitHub authentication guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent), making sure to select the Linux tab.

## Daily usage

### Which terminal
On all operating systems, you will use one of the following system terminals: [Windows Terminal](https://apps.microsoft.com/detail/9n0dx20hk701?hl=en-US&gl=FR), the [macOS Terminal app](https://support.apple.com/guide/terminal/welcome/mac), [Ghostty](https://ghostty.org), [Warp](https://www.warp.dev), etc.

You will use two terminal environments to work with the same application:

- System terminal: the terminal provided by your operating system.
- Container terminal: a terminal opened inside the application container, which gives you access to PHP, Bun, and other development tools.

For Windows users, the system terminal can be replaced by the WSL Ubuntu terminal, where the application files are located.

Use the system terminal or WSL to launch the application containers in Docker Desktop.
Use the container terminal to interact with the application.

You can open the container terminal easily using
```sh
task term
```

> You can open as many container terminals as you need.

### Front
Even though frontend development is not part of this course, you should keep a container terminal running with the following command:

```sh
bun dev
```

This command automatically updates the browser when you modify files in the `resources/` directory.
