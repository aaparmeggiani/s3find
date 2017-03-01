## s3find

A 'find' for S3 public buckets.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3find'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install s3find
```

## Usage

### Command line wrapper

```
$ s3find -h

s3find - a find for S3 public buckets.

Usage:
 s3find <bucket> [OPTIONS]

   <bucket>   bucket_name or full URI ( http://bucket_name.s3.amazonaws.com )

Options:
    -n, --name=pattern               filters names by pattern
    -i, --iname=pattern              case insensitive -n
    -s, --sort=field                 sort by name | size | date
    -r, --rsort=field                reverse sort (descending)
    -l, --limit=num                  items to display

    -h, --help                       displays help
    -v, --version                    displays version
```

Examples:

```
$ s3find http://publicdata.landregistry.gov.uk.s3.amazonaws.com  --limit=5
2016-03-03 19:31:20   0 Bytes market-trend-data/
2016-03-03 19:42:07   0 Bytes market-trend-data/additional-price-paid-data/
2016-03-03 19:32:34   0 Bytes market-trend-data/house-price-index-data/
2016-04-28 08:30:40    111 KB market-trend-data/house-price-index-data/Annual-Change.csv
2016-04-28 08:30:40   2.02 MB market-trend-data/house-price-index-data/Average-Prices-SA-SM.csv

$ s3find http://publicdata.landregistry.gov.uk.s3.amazonaws.com --iname=change
2016-04-28 08:30:40    111 KB market-trend-data/house-price-index-data/Annual-Change.csv
2016-04-28 08:30:45    112 KB market-trend-data/house-price-index-data/Monthly-Change.csv
```

## Contributing

Bug reports and pull requests are welcome through this repo.

## License

MIT