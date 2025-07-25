# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Application Overview

This is a Rails 8.0.2 application called "ChatToDo" - a modern Ruby on Rails web application using PostgreSQL as the database. The application uses Rails' new solid cache, solid queue, and solid cable features for improved performance and reliability.

## Development Commands

### Database Operations
- `rails db:create` - Create the database
- `rails db:migrate` - Run database migrations
- `rails db:seed` - Seed the database with initial data
- `rails db:reset` - Drop, create, migrate, and seed the database

### Server and Development
- `rails server` or `rails s` - Start the development server (runs on port 3000)
- `rails console` or `rails c` - Start the Rails console

### Code Quality and Linting
- `bundle exec rubocop` - Run RuboCop linter (uses rails-omakase style guide)
- `bundle exec rubocop -a` - Auto-correct RuboCop violations where possible
- `bundle exec brakeman` - Run security analysis

### Testing
- `bundle exec rspec` - Run all RSpec tests
- `bundle exec rspec spec/models` - Run model specs only
- `bundle exec rspec spec/controllers` - Run controller specs only
- `bundle exec rspec spec/requests` - Run request specs only
- `bundle exec rspec --format documentation` - Run tests with detailed output
- `bundle exec rspec --format progress` - Run tests with progress output
- `bundle exec rspec spec/path/to/specific_spec.rb` - Run a specific test file
- `bundle exec rspec spec/path/to/specific_spec.rb:line_number` - Run a specific test

### Asset and Build Operations
- `rails assets:precompile` - Precompile assets for production
- `rails assets:clobber` - Remove compiled assets

## Architecture

### Framework and Stack
- **Rails Version**: 8.0.2
- **Database**: PostgreSQL with multiple databases for different concerns:
  - Main: `chat_to_do_development/production`
  - Cache: `chat_to_do_production_cache` (Solid Cache)
  - Queue: `chat_to_do_production_queue` (Solid Queue)  
  - Cable: `chat_to_do_production_cable` (Solid Cable)
- **Asset Pipeline**: Propshaft (modern Rails asset pipeline)
- **JavaScript**: Import maps with Stimulus and Turbo (Hotwire)
- **Styling**: Standard CSS (no CSS framework detected)

### Key Technologies
- **Hotwire Stack**: Turbo Rails + Stimulus for SPA-like experience
- **Solid Suite**: Modern Rails performance stack (Solid Cache, Queue, Cable)
- **Modern Browser Support**: Only supports modern browsers with webp, web push, badges, import maps, CSS nesting, and CSS :has
- **Deployment**: Kamal for Docker-based deployment, Thruster for HTTP acceleration

### Database Configuration
- Uses separate databases in production for different Rails subsystems
- Development uses single database: `chat_to_do_development`
- Test database: `chat_to_do_test`

### Code Style
- Follows **Rails Omakase** styling conventions via `rubocop-rails-omakase`
- RuboCop configuration inherits from the omakase gem
- Security scanning enabled with Brakeman

### Current State
This appears to be a freshly generated Rails 8 application with:
- No custom models, controllers, or views yet implemented
- Standard Rails application structure
- No custom routes defined (only health check)
- No test files present yet
- Basic PWA (Progressive Web App) support configured but commented out

### Development Notes
- The application name in routes and configs is "ChatToDo" suggesting a todo/task management application
- No custom business logic has been implemented yet
- Standard Rails MVC structure is in place and ready for development