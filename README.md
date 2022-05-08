# ExUrlbox

  A light wrapper for the Urlbox API. ExUrlbox's documentation could be found on [HexDocs](https://hexdocs.pm/ex_urlbox).

  **Compatible with Urlbox API:** `v1`

  A list of options that you can pass into `ExUrlBox.get/3`, `ExUrlBox.post/3`, `ExUrlBox.head/3`, and `ExUrlBox.delete/3` can be found here:
  https://urlbox.io/docs/options


## Installation
This package can be installed by adding `ex_urlbox` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_urlbox, "~> 0.1.0"}
  ]
end
```


## Example Usage

### GET - Synchronous
  ```elixir
  # Simple
  ExUrlbox.get("https://anthonymineo.com")

  # With options:
  ExUrlbox.get("https://anthonymineo.com", [format: "png", full_page: true])

  # With a timeout (5s):
  ExUrlbox.get("https://anthonymineo.com", [], 5_000)


  # Extract data from a response
  {:ok, screenshot} = ExUrlbox.get("https://anthonymineo.com")

  screenshot.body
  # => <<137, 80, 78, 71, 13, ...>>>

  screenshot.headers
  # => [{"content-type", "image/png"}, ...]

  screenshot.url
  # => https://api.urlbox.io/v1/:apikey/hmac(:apisecret)/png?url=https%3A%2F%2Fwww.google.com&width=1024&height=768

  ```

### POST - Async with a webhook
  Post a request to Urlbox for a screenshot.
  You should provide a `webhook_url` option to receive a postback to once the screenshot render is complete.
  ```elixir
  # Example request with options containing `webhook_url` for a postback:
  ExUrlbox.post("https://anthonymineo.com", [webhook_url: "https://app-waiting-for-incoming-post.com/"])
  ```

  **Initial response from a post:**
  ```json
  {
    "renderId": "ebcbce5q-9657-435f-aeb6-5db207ee87b5",
    "status": "created",
    "statusUrl": "https://api.urlbox.io/render/ebcbce5q-9657-435f-aeb6-5db207ee87b5"
  }
```

**Example postback to `webhook_url`:**
```json
{
  "event": "render.succeeded",
  "renderId": "ebcbce5q-9657-435f-aeb6-5db207ee87b5",
  "result": {
    "renderUrl": "https://renders.urlbox.io/urlbox1/renders/a1d7g7d45f7am5a0a69cd3de/2022/5/7/ebcbce5q-9657-435f-aeb6-5db207ee87b5.png",
    "size": 34748
  },
  "meta": {
    "startTime":"2022-05-07T20:25:28.879Z",
    "endTime":"2022-05-07T20:25:31.646Z"
  }
}
```


**NOTE: If you dont provide a `webhook_url` you will need to poll the `statusUrl` that's included in the initial post response for the status of your request:**
```json
/* GET => statusUrl */
{
  "renderId": "ebcbce5q-9657-435f-aeb6-5db207ee87b5",
  "status":	"succeeded",
  "renderUrl": "https://renders.urlbox.io/urlbox1/renders/a1d7g7d45f7am5a0a69cd3de/2022/5/7/ebcbce5q-9657-435f-aeb6-5db207ee87b5.png",
  "size": 34748
}
```

### DELETE
Urlbox will cache previously created screenshots for some time. Sending a delete request removes a previously created screenshot from the cache.

**Example request:**
```elixir
ExUrlbox.delete("https://anthonymineo.com")
```

### HEAD
If you just want to get the response status/headers without pulling down the full response body.

**Example request:**
```elixir
ExUrlbox.head("https://anthonymineo.com")
```






## Docs
The full docs can be found at [https://hexdocs.pm/ex_urlbox](https://hexdocs.pm/ex_urlbox).

Documentation has been generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm).
