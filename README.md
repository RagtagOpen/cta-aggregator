# CTA Aggregator

The CTA Aggregator is a project to provide a platform-neutral source of truth for activism action.  Sometimes a CTA (call to action) might be an event at a set location or it might involve contacting a member of congress or local politician.

There are several related projects.
* The API: A main app is a Rails app that facilitates CRUD-ing of calls to action and their related resources.
* [Documentation site](https://github.com/Ragtagteam/cta-aggregator-docs): a small site that shows visitors how to interact with the API.
* [Ruby Gem](https://github.com/Ragtagteam/cta-aggregator-client-ruby): A lightweight gem that will take care of adding the appropriate headers and coercing data into the appropriate JSON structure.
* Web Scrapers: apps that import data from websites and API endpoints.

The goal is for CTA Aggregator to serves as a backend to other sites, permitting them access to a broader range of action data without competing for their clicks, eyeballs, likes, follows, etc.

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

Open http://localhost:3000

## Seed data

To refresh the seed data from 5calls and Emily's list, run

    rake emilys_list:download
    rake five_calls:download`

or, with Docker:

    docker-compose run web rake emilys_list:download
    docker-compose run web rake five_calls:download
    docker-compose run web rake db:seed

## Tests

This app uses Rspec for unit and integration tests.

### Questions
 * Should AdvocacyCampaign endpoint reveal upcoming AdvocacyCampaigns by default?

### Upcoming Features
* How to run seed script on heroku review app?
* Authentication
* AdvocacyCampaign: endpoint for AdvocacyCampaign data in iCal format
* Events: Change `upcoming` query to be flexible, allowing querying for upcoming and past Events
* Location: get list of AdvocacyCampaigns associated with location
* Contacts: get list of AdvocacyCampaigns associated with contact
* Contact: Phone number validation
* Versioning: in header rather than url
