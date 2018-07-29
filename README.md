:warning: App no longer active :warning:

:warning: Consider the code in this app as sample code. :warning:

# CTA Aggregator

The CTA Aggregator, also known as Resistr, was a project to provide a platform-neutral source of truth for activism action.  Examples of a CTA (call to action) include an event at a set location, contacting a Member of Congress, or calling a local politician. The project was discontinued in Spring of 2018, as the ecosystem for which the project had been spec'd out had shifted enough to make the product no longer fit the market. This repo remains up as a technical demonstration of Ragtag engineering and as a reference implementation for the OSDI spec.

The CTA Aggregator project has several repositories:
* The API: The main app is a Rails app that facilitates CRUD-ing of calls to action and their related resources.
* [Documentation site](https://github.com/RagtagOpen/cta-aggregator-docs): a small site that shows visitors how to interact with the API.
* [Ruby Gem](https://github.com/RagtagOpen/cta-aggregator-client-ruby): A lightweight gem that will take care of adding the appropriate headers and coercing data into the appropriate JSON structure.
* [Ruby-based web scraper](https://github.com/RagtagOpen/cta-scraper): A Rails app that houses various scrapers that import data from websites, API endpoints, spreadsheets, etc.

This particular repo contains the API and nothing else. We wanted to give
contributors the freedom to write scrapers in any language they wanted to, not
just Ruby. We were open to having Python scrapers, JS scrapers, etc. if that's
how people are most comfortable contributing.

The distinction between the API and related repos can get confusing,
especially since the `cta-aggregator` repo hosts the
issues for the entire project. We do this because we want a single place we
can look to to find all issues accross the project.

The goal was for CTA Aggregator to serves as a backend to other sites,
permitting them access to a broader range of action data without competing for
their clicks, eyeballs, likes, follows, etc.

## Technology

This is an API-only Rails 5 app.  It uses Postrgres as the persistent data
store.

The API is JSON API spec compliant.  API consumers can make requests without
caring about the underlying technology.  Click [here](http://jsonapi.org/)
for more information on the JSON API spec.

## Usage

There are three resources that are essential to this API:
* AdvocacyCampaign: a call to action
* Target: each AdvocacyCampaign has one or more
* Event: is an on-site event an advocate can attend
* Location: each event has one location

## Setup (native)

* Install PostgreSQL
* Install Ruby (Consult `Gemfile` for version)
* Clone this repo
* Run `bin/setup` (This will install dependencies, create db's, etc.)
* Run test suite: `rspec` (To ensure the app is in a good state)
* Start server: `rails s`

The setup script will create a `.env` file, which can be used to manage
environment variables.  The `.env` file is ingored by git.  Although the script
will copy the `.env.sample` file, the sample file contains no sensitive data
(e.g. login credentials).  If codebase requires sensitive information for local
development, then contact a contributor to get you set access to those additional
environment variables.

## Setup (Docker)

Install [Docker](https://store.docker.com/search?type=edition&offering=community) for your platform.

    docker-compose run web bin/setup
    docker-compose run web rake
    docker-compose up

If `docker-compose run web rake` fails, try running `docker-compose up --build` in one tab, then run

    docker-compose run web bin/setup
    docker-compose run web rake
    
in another.

Open http://localhost:3000

## Seed data

To refresh the seed data from 5calls and Emily's list, run

    rake emilys_list:download
    rake five_calls:download
    rake resistance_calendar:download

or, with Docker:

    docker-compose run web rake emilys_list:download
    docker-compose run web rake five_calls:download
    docker-compose run web rake resistance_calendar:download
    docker-compose run web rake db:seed
    
## Getting an API key

If you want to POST to the API, you will need API credentials, which are associated with an email address. If you're running natively:

    rake user:create[user@example.com]
    
If you're running within Docker:

    docker-compose run web rake user:create[user@example.com]

## Tests

This app uses Rspec for unit and integration tests.

### Troubleshooting
* When running setup script, if you encounter this error: `Error: does not translate host name ‘db’`, then update an environment variable that is set in your .env file.  Replace 'db' with 'localhost' (or the host for your PostgreSQL instance) on the .env file.
