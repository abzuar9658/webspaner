# Web Page Fetcher and Saver

Web Page Fetcher and Saver is a command-line tool that allows you to fetch web pages from the internet and save them to your local disk for later retrieval and browsing. It helps you archive web content and access it offline.

## Features

- Fetch web pages from URLs and save them locally.
- Organize saved web pages into directories based on URL or custom categories.
- View saved web pages offline using a local web server.
- Efficiently manage and browse archived web content.

## Getting Started

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-username/web-page-fetcher.git
   cd web-page-fetcher
## Usage

### Running Locally

To run the project locally, use the following command:

1. Make sure you have Ruby installed on your system. You can download it from [ruby-lang.org](https://www.ruby-lang.org/) (3.0.5 preferred).

2. Run the following commands:
   ```sh
   bundle install
   ruby main.rb fetch https://www.example.com [--meta]
### Using Docker

To run the project locally, use the following command:

1. Make sure you have Ruby installed on your system. You can download it from [ruby-lang.org](https://www.ruby-lang.org/) (3.0.5 preferred).

2. Run the following commands:
   ```sh
   docker build -t project-name .
   docker run --rm -v $(pwd):/app project-name [arguments]

