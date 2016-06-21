# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# ignore 'example'

guard :rspec, cmd: 'rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new self

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)
end
