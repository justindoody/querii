# Querii Object Gem

![Searching records](http://i.imgur.com/pa0oxih.jpg)

Querii makes it easy to create query objects that return active record relations

## Why?

Querii allows you to extract complicated query collection logic out of an ActiveRecord model.

This prevents littering the base model and encourages breaking up your query logic into multiple methods, constants, etc. Querii creates a singleton that returns a standard activerecord collection (now extended by your additional querii scopes) that can be further acted upon.

This provides a pattern for extracting complicated common queries from your model or one off queries from a controller for easier testing and separation of concerns.

## Basic Usage

```ruby
module Accounts
  module FancySubset
    include Querii::QueryObject

    default_scope { where(cool: 'things') }

    scope :filter, ->(hats: 2) { where(hats: hats) }
  end
end

# basic call
Accounts::FancySubset.call # or .all

# or more advanced chain
Accounts::FancySubset.call.filter(hats: 4).where(typical: 'filtered')
# ...Account::ActiveRecord_Relation < ActiveRecord::Relation
```

### Base class

Querii infers the base model from the top level query object namespace. For the example above `Accounts` represents `Account`. You can easily override this by setting `self.model_name = 'ClassName'` within your query module.

### Default scope

A default scope is automatically defined for you with a collection of `.all`. You can set a customized default by calling `default_scope` and passing a block, proc, or lambda.

The default scope is designed for query objects that only contain a single base scope always intended to be called so you can simply do `MyQueryObj.call` or equivalently `MyQueryObj.all`.

### How it works
Querii dynamically defines a `Scopes` module when included that contains scopes defined either via `default_scope` or `scope :name, ->{}`. This pattern is taken from AR.

During a query this module is extended onto the base `ActiveRecord::Relation` and the defined default scope method is called. This returns an active record collection that can further be queried by both additional scopes defined within your Querii object and scopes or conditions on the base AR class.

Scopes can also be defined as methods explicitly by opening up the scopes class within your query object.

### Passing an already filtered relation

`Account::FancySubset.call(relation: Account.joins(:whatever).such_scope)` will work out just fine.
