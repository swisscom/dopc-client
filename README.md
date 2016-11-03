# DOPc Client

DOPc client is a CLI for the DOPc REST service.

See rdoc for usage documentation.

## Quickstart

* Run `bin/dopc --help` to see the usage
* Use e.g. `bin/dopc --url http://dop.example.com --api 1` to specify a
  different URL and API version

## Contributing

* Don't forget to generate rdoc file with `bundle exec dopc
  _doc` after changing code.
* Tests use rspec-command to invoke the bin script. Therefor a DOPc service
  must be running on the default address and port. Also, if tests fail it must
  be reset manually so tests have a clean setup to run again (see todos).

## Releasing

TODO

## Implementation

* The CLI uses GLI, refer to GLI documentation for further details
* Calls to the REST service are done with rest-client, requests and responses
  use JSON only for the body.

## Todo

* Authentication
* Setting up a DOPc service for testing

## Troubleshooting

* To debug use the `-d` flag.

## Authors

* Anselm Strauss <Anselm.Strauss@swisscom.com>
