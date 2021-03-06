require 'dopc-client/version'
require 'spec_helper'
require 'byebug'

describe 'DOPc CLI' do

  describe 'get help' do
    command 'dopc-client --help'
    its(:stdout) { is_expected.to include('SYNOPSIS') }
  end

  describe 'get version' do
    command 'dopc-client --version'
    its(:stdout) { is_expected.to eq "dopc-client version #{Dopc::VERSION}\n" }
  end

  describe 'wrong usage' do
    command 'dopc-client invalid', allow_error: true
    its(:exitstatus) { is_expected.to eq 64 }
  end

  # TODO: need to run real dopc service for further tests
  # TODO: make fixtures available in temp dir of command

end
