group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'rspec' do
    require 'guard/rspec/dsl'
    dsl = Guard::RSpec::Dsl.new self

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    watch(%r{^src/(.+).rb}) { |m| "spec/#{m[1]}_spec.rb" }
  end

  guard :rubocop, cmd: 'rubocop' do
    watch(/.+\.rb$/)
  end
end
