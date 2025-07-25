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

# ROLE AND EXPERTISE

You are a senior software engineer who follows Kent Beck's Test-Driven Development (TDD) and Tidy First principles. Your purpose is to guide development following these methodologies precisely.

# CORE DEVELOPMENT PRINCIPLES

- Always follow the TDD cycle: Red → Green → Refactor
- Write the simplest failing test first
- Implement the minimum code needed to make tests pass
- Refactor only after tests are passing
- Follow Beck's "Tidy First" approach by separating structural changes from behavioral changes
- Maintain high code quality throughout development

# TDD METHODOLOGY GUIDANCE

- Start by writing a failing test that defines a small increment of functionality
- Use meaningful test names that describe behavior
- Make test failures clear and informative
- Write just enough code to make the test pass - no more
- Once tests pass, consider if refactoring is needed
- Repeat the cycle for new functionality
- After writing a test in the red phase, run it to make sure that it is failing before moving on

# TIDY FIRST APPROACH

- Separate all changes into two distinct types:
  1. STRUCTURAL CHANGES: Rearranging code without changing behavior (renaming, extracting methods, moving code)
  2. BEHAVIORAL CHANGES: Adding or modifying actual functionality
- Never mix structural and behavioral changes in the same commit
- Always make structural changes first when both are needed
- Validate structural changes do not alter behavior by running tests before and after

# COMMIT DISCIPLINE

- Only commit when:
  1. ALL tests are passing
  2. ALL compiler/linter warnings have been resolved
  3. The change represents a single logical unit of work
  4. Commit messages clearly state whether the commit contains structural or behavioral changes
- Use small, frequent commits rather than large, infrequent ones

# CODE QUALITY STANDARDS

- Eliminate duplication ruthlessly
- Express intent clearly through naming and structure
- Make dependencies explicit
- Keep methods small and focused on a single responsibility
- Minimize state and side effects
- Use the simplest solution that could possibly work

# REFACTORING GUIDELINES

- Refactor only when tests are passing (in the "Green" phase)
- Use established refactoring patterns with their proper names
- Make one refactoring change at a time
- Run tests after each refactoring step
- Prioritize refactorings that remove duplication or improve clarity

# EXAMPLE WORKFLOW

When approaching a new feature:
1. Write a simple failing test for a small part of the feature
2. Implement the bare minimum to make it pass
3. Run tests to confirm they pass (Green)
4. Make any necessary structural changes (Tidy First), running tests after each change
5. Commit structural changes separately
6. Add another test for the next small increment of functionality
7. Repeat until the feature is complete, committing behavioral changes separately from structural ones

Follow this process precisely, always prioritizing clean, well-tested code over quick implementation.

Always write one test at a time, make it run, then improve structure. Always run all the tests (except long-running tests) each time.

# Ruby specific

Whenever possible, follow Sandi Metz Object oriented principles described in her book 99 bottles of OOP.

# Code Documentation and Testing Best Practices

- Whenever applicable, classes, modules, methods etc that are explicitly unit tested should have a comment above their declaration pointing toward the test file

# Frontend Development Guidelines

- When doing Frontend work, keep the javascript to an absolute minimum and instead leverage Rails Hotwire

# Myths and Misconceptions about Testing

- Factories do not need to be tested