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


### Examples

#### Events
These are the attributes on the events model:


Interested in the events endpoint? Here's how to interact with  it.

* GET request to `/events`: list of all events
* GET request to`/event/<UUID>`: show one event
* POST request to `/events`: create an event
* GET request to `/events/<UUID>/relationship/contact`: show contact
* GET request to `/events/<UUID>/relationship/location`: view location (if event is `onsite`)
* PUT request to `/events/<UUID>/relationship/contact` : link an existing contact to an event
* PUT request to `/events/<UUID>/relationship/location`: link an existing location to an event

And here are some examples.

Get a list of Events. This will return a paginated list of events. 
```

```

Filtering: you can filter by the following attributes:
* event_type: set filter to either `onsite` or `phone`
* upcoming: view only upcoming events

View upcoming events
```

```

View only onsite events
```

```

View only phone events
```

```

View a single Event
```

```

#### Contacts

These are the attributes on the Contact model:


Interested in the contacts endpoint? Here's how to interact with  it.
* GET request to `/contacts: list of all events 
* GET request to`/contact/<UUID>`: show one event
* POST request to `/contacts`: create an event

Get a list of Contacts. This will return a paginated list of contacts. 
```

```

Filtering: you can filter by the following attributes:
* email
* name (currently, case sensative)

Search for a contact based on their email address.
```

```

View a single contact

```

```

Set the contact for an Event
```

```

#### Locations

These are the attributes on the Location model:


Interested in the locations endpoint? Here's how to interact with  it.
* GET request to `/locations: list of all events 
* GET request to`/locations/<UUID>`: show one event
* POST request to `/locations`: create an event

Get a list of Locations. This will return a paginated list of locations. 
```

```

Filtering: you can filter by the following attributes:
* address_line_1
* address_line_2
* city
* state
* zipcode.

Search for a contact based on zipcode example.

```

```

View a single Contact

```

```

Set the location for an Event
```

```

Cucumber tests are written from point of view of an API client.  They're a
good example of how you'll need to structure requests to the API.


## Setup

* Install PostrgreSQL
* Clone this repo
* Install dependencies: `bundle install`
* Run `rake db:create:all`
* Run test suite: `rake`
* Start server: `rails s`

## Tests

This app uses Rspec and Cucumber for unit and integration tests.

### Questions
 * Do we really need a contact's physical location?
 * Should Events endpoint reveal upcoming events by deafult?

### Upcoming Features
* Authentication
* Events: endpoint for Event data in iCal format
* Events: validate that if event is onsite, that it also has an location associated with it
* Events: Change `upcoming` query to be flexible, allowing querying for upcoming and past events
* Location: consider location valid if it has either a zip or a city and state (don't require all three)
* Location: get list of events associated with location
* Contact: Phone number validation
* Contacts: case insensitive search for name
* Contacts: get list of events associated with contact
* Versioning: in header rather than url
* Allow for creation of relationships when Event is created? Breaks JSON API spec, but would be convenient.
