> [!NOTE]
> DEPRECATED - no longer maintained!

# DOPc Client

DOPc client is a CLI for the DOPc REST service.

See rdoc for usage documentation.

## Quickstart

* Run `bundle exec dopc-client --help` to see the usage
* Create config file with `bundle exec dopc-client initconfig`
* Set URL and authentication token in your configuration
* Run `bundle exec dopc-client ping` to verify calling the DOPc service

## Configuration

The configuration must be created initially with the `initconfig` command. This
will create a configuration in `/etc/dop/dopc-client.conf` for the root user,
or in `~/.dop/dopc-client.conf` for anybody else. The options used when calling
`initconfig` will be written to the configuration file, otherwise defaults are
written. An existing configuration file can be edited by hand or overwritten
with `initconfig` using the `--force` option.

## Contributing

* Don't forget to generate rdoc file with `bundle exec dopc-client _doc`
  after changing code.
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

* If using debug option, then the authentication token is shown plaintext in
  the output.

## Troubleshooting

* To debug use the `-d` flag.

## Authors

* Anselm Strauss <Anselm.Strauss@swisscom.com>
