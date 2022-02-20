# Geowlr

Geowlr uses data from WhosOnFirst and try its best to normalize the results.

## Dependencies

Geowlr uses Postgis, that's it.

## Import data (development)

First create the database:

```
bin/rake db:create
```

You can find a dump of our data here: https://drive.google.com/file/d/1IQiYrnpwZxAbyG0DhMUZPaLMZKBMyq1Y/view?usp=sharing
Once it's downloaded you can restore it with:

```
pg_restore -d geowlr_development -t geometries ~/geowlr.dump
```

## API

```
curl "http://localhost:3000/localities?latitude=48.8534&longitude=2.3488"
```

```
{"reference":"101751119","name":"Paris","hierarchy":{"region":"Paris","country":"France","macroregion":"Ile-of-France"},"latitude":48.856599,"longitude":2.342841}
```

