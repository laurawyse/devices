# Rails app for managing device readings

## Getting Started

Install ruby version using any version manager, for example with rbenv:

```
rbenv install
```

Install dependencies:

```
bundle install
```

Run the server:

```
rails server
```

Run the tests:

```
bundle exec rspec
```

## API docs

#### GET /api/v1/ping
* health check that can be used to verify the server is running and reachable

sample curl command:
```
curl http://127.0.0.1:3000/api/v1/ping
```

#### POST /api/v1/readings
* store readings for a device

sample request payload:
```
{
    "id": "36d5658a-6908-479e-887e-a949ec199272",
    "readings": [
        {
            "timestamp": "2021-09-29T16:08:15+01:00",
            "count": 2
        },
        {
            "timestamp": "2021-09-29T16:11:15+01:00",
            "count": 15
        }
    ]
}
```

sample curl command:
```
curl --location 'http://127.0.0.1:3000/api/v1/readings' \
--header 'Content-Type: application/json' \
--data '{
    "id": "36d5658a-6908-479e-887e-a949ec199272",
    "readings": [
        {
            "timestamp": "2021-09-29T16:08:15+01:00",
            "count": 2
        },
        {
            "timestamp": "2021-09-29T16:11:15+01:00",
            "count": 15
        }
    ]
}'
```

#### GET /api/v1/devices/:id/latest_timestamp
* get the latest reading timestamp for a specific device

sample curl command:
```
curl http://127.0.0.1:3000/api/v1/devices/36d5658a-6908-479e-887e-a949ec199272/latest_timestamp
```

#### GET /api/v1/devices/:id/cumulative_count
* get the cumulative count for all readings for a specific device
  
sample curl command:
```
curl http://127.0.0.1:3000/api/v1/devices/36d5658a-6908-479e-887e-a949ec199272/cumulative_count
```

## Project Summary
This is a rails application that exposes the APIs described above. You likely care most about things defined in the controllers,
models, and spec folders.

Data: No database is used and instead a simple Cache class has been implemented to store devices and readings in memory. This
is done using a singleton class called "Cache." 

Tests: Unit tests can be found in the spec folder and run with rspec.

## Improvements

Given more time I would take the following actions:
* Add validations to params on both models and controllers
* Right now I'm evaluating the latest reading and cumulative count when asked for it. If these operations were read heavy and the list of readings was quite long, this could be slow. Instead I could calculate those on write and store them for a quick evaluation on read. These could also be done in an async job when readings are inserted if the readings list was extremely long and we were okay with a delay in them being updated.
* The logic to add readings to an existing device is not ideal. It stores readings in a list and then looks to see if there is already a reading with a matching timestamp before adding a new one. If we are writing a lot, this would be slow and it may be better to use a different data structure.
* Use serializers to define API response schemas. Right now these are pretty simple but if they get more complex, this would help make that interface more clearly defined.
* Improve tests
  * Some tests are dependent on others or dependent on multiple functions/apis. I would separate these to make them self contained
  * Expand to cover more edge cases
* Clean up dependencies and extra files. I used `rails new` to generate this app and while I did clean up some of the unneeded files and dependencies, there are still some unused things included here.

In a live environment I would also expect to need to add:
* authentication (right now the API doesn't require any)
* an actual database to store devices and readings

Many of these things are also noted in the actual code using `TODO` comments. More details may be found there!