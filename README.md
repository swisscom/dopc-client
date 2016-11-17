# DOPc Client

DOPc client is a CLI for the DOPc REST service.

See rdoc for usage documentation.

## Quickstart

* Run `bin/dopc --help` to see the usage
* Create config file with `bin/dopc initconfig`
* Set URL and authentication token in your configuration
* Run `bin/dopc ping` to verify calling the DOPc service

## Configuration

The configuration must be created initially with the `initconfig` command. This
will create a configuration in `/etc/dop/dopc.conf` for the root user, or in
`~/.dop/dopc.conf` for anybody else. The options used when calling `initconfig`
will be written to the configuration file, otherwise defaults are written. An
existing configuration file can be edited by hand or overwritten with
`initconfig` using the `--force` option.

## Contributing

* Don't forget to generate rdoc file with `bundle exec dopc
  _doc` after changing code, *be careful to not include your default
  authentication token from the config file in the generated rdoc file!*
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

* Testing: Setting up a DOPc service for testing?
* Output could use better formatting: align columns with tabs?

## Caveats

* When doing `dopc _doc` it will put the auth token from config file as default
  value into the generated documentation.

## Troubleshooting

* To debug use the `-d` flag.

## Authors

* Anselm Strauss <Anselm.Strauss@swisscom.com>
