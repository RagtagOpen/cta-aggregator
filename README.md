# CTA Aggregator

The CTA Aggregator is a project to provide a platform-neutral source of truth
for activism action.  Sometimes a CTA (call to action) might be an event
at a set location or it might involve contacting a
member of congress or local politician.

There are several related projects.
* The API: A main app is a Rails app that facilitates CRUD-ing of calls to  
action and their related resources.
* [Documentation site](https://github.com/Ragtagteam/cta-aggregator-docs): a  
small site that shows visitors how to interact with the API.
* [Ruby Gem](https://github.com/Ragtagteam/cta-aggregator-client-ruby): A  
lightweight gem that will take care of adding the appropriate headers and  
coercing data into the appropriate JSON structure.
* Web Scrapers: apps that import data from websites and API endpoints.

The goal is for CTA Aggregator to serves as a backend to other sites,  
permiting them access to a broader range of action data without competing for  
their clicks, eyeballs, likes, follows, etc.

## Technology

This is an API-only Rails 5 app.  It uses Postrgres as the persistent data 
store.

The API is JSON API spec compliant.  API consumers can make requests without
caring about the underlying technology.  Click [here](http://jsonapi.org/) 
for more information on the JSON API spec.

## Usage

There are three resources that are essential to this API:
* CTA: a call to action
* Contact: each CTA has one
* Location: a CTA will have a location if it's an `onsite` CTA

## Setup

* Install PostrgreSQL
* Install Ruby (Consult `Gemfile` for version)
* Clone this repo
* Run `bin/setup` (This will install dependencies, create db's, etc.)
* Run test suite: `rake` (To ensure the app is in a good state)
* Start server: `rails s`

The setup script will create a `.env` file, which can be used to manage 
environment variables.  The `.env` file is ingored by git.  Although the script
will copy the `.env.sample` file, the sample file contains no sensitive data 
(e.g. login credentials).  If codebase requires sensitive information for local
development, then contact a contributor to get you set access to those additional
environment variables.

## Tests

This app uses Rspec and Cucumber for unit and integration tests.

Cucumber tests are written from point of view of an API client.  They're a
good example of how you'll need to structure requests to the API.


### Questions
 * Should CTA endpoint reveal upcoming CTAs by default?

### Upcoming Features
* How to run seed script on heroku review app?
* Authentication
* CTA: endpoint for CTA data in iCal format
* CTAs: Change `upcoming` query to be flexible, allowing querying for upcoming and past CTAs
* Location: get list of CTAs associated with location
* Contacts: get list of CTAs associated with contact
* Contact: Phone number validation
* Versioning: in header rather than url
