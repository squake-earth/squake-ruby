# SQUAKE

Find the documentation here: [docs](https://docs.squake.earth/).

## Installation

Via git:

```ruby
# Gemfile

gem 'squake', git: 'git@github.com:squake-earth/squake-ruby'
```

Via rubygems:

```ruby
# Gemfile

gem 'squake', '~> 0.1.0'
```

## Auth

An API Key can be generated on the [dashboard](https://dashboard.squake.earth/.)
You need a different API Key for production and sandbox.

## Functionality

* compute emission values
* request a price quote (with a product id)
* place a purchase order (with a price quote id)
* get a list of all available products (includes price information)

## Usage

Initialize the client:

```ruby
config = Squake::Config.new(
  api_key: 'Your API Key',     # required
  sandbox_mode: true,          # optional, default: true
  keep_alive_timeout: 30,      # optional, default: 30
  logger: Logger.new($stdout), # optional, default: Logger.new($stdout)
  enforced_api_base: nil,      # optional, default: nil. If given, overrides the API base URL.
)

# the SQUAKE client emits canonical log lines, e.g.
#   Request started http_method=get http_path=/api/v2/calculations
client = Squake::Client.new(config: config)
```

Calculate emissions

```ruby
items = [
  {
    type: 'flight',
    methodology: 'ICAO',
    origin: 'BER',
    destination: 'SIN',
    booking_class: 'economy',
    number_of_travellers: 2,
    aircraft_type: '350',
    external_reference: 'booking-id',
  }
]

# returns Squake::Model::Carbon
carbon = Squake::Calculation.create(
  client: client,        # required
  items: items,          # required
  carbon_unit: 'gram',   # optional, default: 'gram', other options: 'kilogram', 'tonne'
  expand: [],            # optional, default: [], allowed values: 'items' to enrich the response
)
```

Calculate emissions and include a price quote:

```ruby
# Find all available item types and methodologies here:
#   https://docs-v2.squake.earth/group/endpoint-calculations
items = [
  {
    type: 'flight',
    methodology: 'ICAO',
    origin: 'BER',
    destination: 'SIN',
    booking_class: 'economy',
    number_of_travellers: 2,
    aircraft_type: '350',
    external_reference: 'booking-id',
  }
]

# returns Squake::Model::Pricing
pricing = Squake::CalculationWithPricing.quote(
  client: client,        # required
  items: items,          # required
  product: 'product-id', # required
  currency: 'EUR',       # optional, default: 'EUR'
  carbon_unit: 'gram',   # optional, default: 'gram', other options: 'kilogram', 'tonne'
  expand: [],            # optional, default: [], allowed values: 'items', 'product', 'price' to enrich the response
)
```

Place a purchase order; by default the library injects a `SecureRandom.uuid` as `external_reference` to ensure idempotency, i.e. you can safely retry the request if it fails.

```ruby
uuid = SecureRandom.uuid

# returns Squake::Model::Purchase
purchase = Squake::Purchase.create(
  client: client,           # required
  pricing: pricing.id,      # required, from above
  external_reference: uuid, # optional, default: SecureRandom.uuid, used for idempotency, if given, MUST be unique
)

# retrieve the purchase later
Squake::Purchase.retrieve(
  client: client,  # required
  id: purchase.id, # required
)

# within 14 days, you can cancel the purchase worry-free
Squake::Purchase.cancel(
  client: client,  # required
  id: purchase.id, # required
)
```

## Publishing a new version

Have a Rubygems API key in your `~/.gem/credentials` file.

```shell
---
:rubygems_squake: rubygems_xxx
```

Then run:

```shell
gem build
gem push squake-0.1.0.gem --key=rubygems_squake
```
