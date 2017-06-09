# CTA Aggregator

The CTA Aggregator is a project to provide a platform-neutral source of truth
for activism actions ranging from attending a CTA to getting informed about
a piece of legislation.

It serves as a backend to other sites that permits them access to a broader
range of action data without competing for their clicks, eyeballs, likes,
follows, etc.

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

## Setup

* Install PostrgreSQL
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

## Tests

This app uses Rspec for unit and integration tests.

### Questions
 * Should AdvocacyCampaign endpoint reveal upcoming AdvocacyCampaigns by default?

### Upcoming Features
* How to run seed script on heroku review app?
* Authentication
* AdvocacyCampaign: endpoint for AdvocacyCampaign data in iCal format
* AdvocacyCampaigns: Change `upcoming` query to be flexible, allowing querying for upcoming and past AdvocacyCampaigns
* Location: get list of AdvocacyCampaigns associated with location
* Contacts: get list of AdvocacyCampaigns associated with contact
* Contact: Phone number validation
* Versioning: in header rather than url
