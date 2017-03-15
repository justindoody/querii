# Querii Object Gem

![Searching records](http://i.imgur.com/pa0oxih.jpg)

Querii makes it easy to create query objects that return active record relations

## Why?

Querii allows you to extract complicated query collection logic out of a ActiveRecord model to prevent littering the base model and encourage breaking up your query logic into multiple methods, constants, etc, while still returning a standard activerecord collection (now extended by your additional querii methods) that can be further acted upon.

## Basic Usage

```ruby
module Accounts
  module FancySubset
    include Querii::QueryObject

    module Scopes
      def applied(*args, **key_args)
        where(cool: 'things', many: key_args.fetch(:hats, 2))
      end
    end
  end
end

# basic call
Accounts::FancySubset.call # or .all

# or more advanced chain
Accounts::FancySubset.call(hats: 4).where(typical: 'filtered')
# ...Account::ActiveRecord_Relation < ActiveRecord::Relation
```

Querii infers the base collection from the top level query object namespace of `Accounts` -> `Account.all`, you can override this by setting a `BASE_RELATION` constant within your module. Querii defines a default `Scopes` module that will just return all but to do anything useful by default you will need to define your own `Scopes` module. During a query this module is extended onto the base `ActiveRecord::Relation` and the `applied` method is executed returning an active record collection that can further be queried by both any additional methods defined within your Querii object `Scopes` and scopes or conditions on the standard AR class.

## More

### Default scope

The `applied` method is entirely optional and designed for query objects that only contain a single base scope always intended to be called so you can simply do `MyQueryObj.call` or equivalently `MyQueryObj.all`. Additionally the applied method can accept and use any number of args or keyword args.
