# SQUAKE

Find the documentation here: [docs](https://docs.squake.earth/).

## Installation

Via rubygems:

```ruby
gem 'squake'
```

Test the latest version via git:

```ruby
gem 'squake', git: 'git@github.com:squake-earth/squake-ruby', branch: :main
```

## Auth

An API Key can be generated on the [dashboard](https://dashboard.squake.earth/.)
You need a different API Key for production and sandbox.

## Functionality

* compute emission values
* request a price quote for your emissions (with a product id)
* place a purchase order (with a price quote id)
* get a list of all available products (includes price information)

## Usage

### Initialize the client

either explicitly anywhere in the app

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

or once globally in e.g. an initializer

```ruby
Squake.configure do |config|
  config.api_key = ENV.fetch('SQUAKE_API_KEY') # optional if ENV var `SQUAKE_API_KEY` is set
  config.sandbox_mode = true                   # set to `false` for production
  config.keep_alive_timeout = 30               # optional, default: 30
  config.logger = Logger.new($stdout)          # Set this to `Rails.logger` when using Rails
  config.enforced_api_base = nil               # for testing to e.g. point to a local server
end
```

If you have the API Key in an ENV var named `SQUAKE_API_KEY`, you don't need any further config.

### Define items you want emissions to be computed

Find all available item types and methodologies in the [docs](https://docs-v2.squake.earth/group/endpoint-calculations).

```ruby
# NOTE: some items are also available as typed objects, found at `lib/squake/model/items/**/*.rb`
#       where `.../items/private_jet/squake` is the item for type "private_jet" and methodology "squake".
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
  },
  Squake::Model::Items::PrivateJet::Squake.new(
    origin: 'SIN',
    destination: 'HND',
    external_reference: 'my-booking-id',
    identifier: 'P180',
    identifier_kind: 'ICAO',
  ),
]
```

### Calculate emissions (without price quote)

```ruby
context = Squake::Calculation.create(
  client: client,        # required
  items: items,          # required
  carbon_unit: 'gram',   # optional, default: 'gram', other options: 'kilogram', 'tonne'
  expand: [],            # optional, default: [], allowed values: 'items' to enrich the response
)

# alias: context.failed?
if context.success?
  context.result # Squake::Model::Carbon
else
  context.errors # [Squake::Errors::APIErrorResult]
end
```

### Calculate emissions and include a price quote

```ruby
context = Squake::CalculationWithPricing.quote(
  client: client,        # required
  items: items,          # required
  product: 'product-id', # required
  currency: 'EUR',       # optional, default: 'EUR'
  carbon_unit: 'gram',   # optional, default: 'gram', other options: 'kilogram', 'tonne'
  expand: [],            # optional, default: [], allowed values: 'items', 'product', 'price' to enrich the response
)

if context.success?
  context.result # Squake::Model::Pricing
else
  context.errors # [Squake::Errors::APIErrorResult]
end
```

### Place a purchase order

by default the library injects a `SecureRandom.uuid` as `external_reference` to ensure idempotency, i.e. you can safely retry the request if it fails.

```ruby
uuid = SecureRandom.uuid

# returns Squake::Model::Purchase
context = Squake::Purchase.create(
  client: client,           # required
  pricing: pricing.id,      # required, from above
  external_reference: uuid, # optional, default: SecureRandom.uuid, used for idempotency, if given, MUST be unique
)

context.result # Squake::Model::Purchase
context.errors # [Squake::Errors::APIErrorResult]

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

## Contributions

We welcome contributions from the community. Before starting work on a major feature, please get in touch with us either via email or by opening an issue on GitHub. "Major feature" means anything that changes user-facing features or significant changes to the codebase itself.

Please commit small and focused PRs with descriptive commit messages. If you are unsure about a PR, please open a draft PR to get early feedback. A PR must have a short description ("what"), a motiviation ("why"), and, if applicable, instructions how to test the changes, measure performance improvements, etc.

## Publishing a new version

run

```shell
bin/release
```

which will guide you through the release process.
