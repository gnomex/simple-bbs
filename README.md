# Simple BBS
    It is a bulletin board system

## Features

* A BBS system
* Only use TCP
* User can create a simple posts
* User can create categories
* User can view posts
* All data will be pure String, to make TCP traffic analysis

# Messaging API
    All data is a JSON-like, raw data is pure strings

The structure of the JSON is:

* An action
* The action data params
* Close

## Actions

* Create: means create a new post

```ruby
# Create requires a data with a new post
# The owner will be the current user name
{
  action: 'create',
  data: {
    title: "Something",
    body: "Mussum ipsum cacilds, vidis litro abertis. Consetis adipiscings elitis. Pra lá , depois divoltis porris, paradis. Paisis, filhis, espiritis santis. Mé faiz elementum girarzis, nisi eros vermeio, in elementis mé pra quem é amistosis quis leo. Manduma pindureta quium dia nois paga. Sapien in monti palavris qui num significa nadis i pareci latim. Interessantiss quisso pudia ce receita de bolis, mais bolis eu num gostis.",
    category: "lol"
  }
}
```

* Delete: means delete a post, if you are a admin or owner

```ruby
# Delete requires a data with a post id to delete
{
  action: 'delete',
  data: {
    post_id: '1'
  }
}
```

* Show: means show the posts, by filter or all

```ruby
# Default is all posts
# Owner an category are opcional
{
  action: 'show',
  what: '[posts|users|categories]',
  data: {
    owner: "",
    category: ""
  }
}
```

* Ends the connection

```ruby
{
  action: 'marmota'
}
```

## Basic flow

1. Establish the TCP connection
2. Server will ask the username
3. Client tells its name
4. Client/Server interacts with actions
5. Close the connection when `marmota` is received

## Go!

1. Clone the source
2. go to project path (`cd ~path~/simple-bbs/`)
3. run de blundler (`bundle install`)
4. (In progress...)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
