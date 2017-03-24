# CTA Aggregator

The CTA Aggregator is a project to provide a platform-neutral source of truth
for activism actions ranging from attending an event to getting informed about
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
* Event: a call to action
* Contact: each event has one
* Location: an event will have a location if it's an `onsite` event

## Setup

* Install PostrgreSQL
* Install Ruby (Consult `Gemfile` for version)
* Clone this repo
* Run `bin/setup` (This will install dependencies, create db's, etc.)
* Run test suite: `rake` (To ensure the app is in a good state)
* Start server: `rails s`

## Tests

This app uses Rspec and Cucumber for unit and integration tests.

Cucumber tests are written from point of view of an API client.  They're a
good example of how you'll need to structure requests to the API.


### Questions
 * Do we really need a contact's physical location?
 * Should Events endpoint reveal upcoming events by default?

### Upcoming Features
* Authentication
* Events: endpoint for Event data in iCal format
* Events: Change `upcoming` query to be flexible, allowing querying for upcoming and past events
* Location: consider location valid if it has either a zip or a city and state (don't require all three)
* Location: get list of events associated with location
* Contacts: get list of events associated with contact
* Contact: Phone number validation
* Versioning: in header rather than url
* Allow for creation of relationships when Event is created? Breaks JSON API spec, but would be convenient.
