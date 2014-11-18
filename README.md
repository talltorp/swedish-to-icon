# posten-agent-api
[ ![Codeship Status for talltorp/posten-agent-api](https://codeship.io/projects/3dda0ae0-4374-0132-7544-7a7a464bc8de/status)](https://codeship.io/projects/44699)
API for fetching the the agent associated with the zip

The service has a database which acts as a cache for the agents
It there is no match in the database for the requested zip, a call is made to the site at posten. This information in then saved in the database and returned to the requesting client.

There will be a scheduled job that goes through all the records in the database and updates them.

The page we are scraping can be found in the iframe at
``http://www.posten.se/sv/Kundservice/Sidor/Sok-servicestallen.aspx```

iframe url: ```http://www.karthotellet.com/posten_2012/sok_posten.php?```

## POST /agent
### Request
Requests are made in json

```
{
  "zip":"11234"
}
```

### Response
```200 OK```

```
{
  "name": "Posten ICA",
  "street": "storgatan 4",
  "zip": "12345",
  "city": "STOCKHOLM",
  "opening_hours": "Må-Fr 8.00-21.00, Lö 8.00-19.00, Sö 9.00-19.00"
}
```
