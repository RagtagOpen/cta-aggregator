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
Get a list of Events. This will return a paginated list of events. 
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
Get a list of Contacts. This will return a paginated list of contacts. 
```

```

Search for a contact based on their email address.
```

```

View a single Event

```

```

Set the contact for an Event
```

```

#### Locations
Get a list of Locations. This will return a paginated list of locations. 
```

```

Search for a contact based on zipcode.  Other filterable fields include: 
address_line_1, address_line_2, city, state, and zipcode.

```

```

View a single Contact

```

```

Set the location for an Event
```

```


Filtering: you can filter by the following attributes:
Events: ...
Contacts: email
Location:...

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

### To Do
* Events: show future events be default, and all events when requested
* Provide contact and location in event payload?
* Allow for creation of relationships when Event is created?
* Store email address lowercase


### Upcoming Features
* Authentication
* Events: endpoint for Event data in iCal format
* Contact: Phone number validation
* CTA model: validate object that if object is onsite, that it also has an location associated with it
* Location: consider location valid if it has either a zip or a city and state (don't require all three)
* Versioning: in header rather than url
* Contacts: case insensitive search for name
