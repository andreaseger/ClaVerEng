group :all do
  guard 'rspec', cli: "--color --format p", rvm:['ruby-1.9.3-p374@ClassificationVerifier','jruby-1.7.2@ClassificationVerifier','rbx-head@ClassificationVerifier'] , all_after_pass: false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')            { 'spec' }
    watch('spec/factories.rb')              { 'spec' }
    watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
    watch(%r{^spec/support/(.+)_spec\.rb})  { |m| "spec/#{m[1]}s/*" }
  end
end
group :mri do
  guard 'rspec', cli: "--color --format p", rvm: 'ruby-1.9.3-p374@ClassificationVerifier' , all_after_pass: false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')            { 'spec' }
    watch('spec/factories.rb')              { 'spec' }
    watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
    watch(%r{^spec/support/(.+)_spec\.rb})  { |m| "spec/#{m[1]}s/*" }
  end
end
group :jruby do
  guard 'rspec', cli: "--color --format p", rvm: 'jruby-1.7.2@ClassificationVerifier' , all_after_pass: false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')            { 'spec' }
    watch('spec/factories.rb')              { 'spec' }
    watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
    watch(%r{^spec/support/(.+)_spec\.rb})  { |m| "spec/#{m[1]}s/*" }
  end
end
group :rbx do
  guard 'rspec', cli: "--color --format p", rvm: 'rbx-head@ClassificationVerifier' , all_after_pass: false do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')            { 'spec' }
    watch('spec/factories.rb')              { 'spec' }
    watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
    watch(%r{^spec/support/(.+)_spec\.rb})  { |m| "spec/#{m[1]}s/*" }
  end
end


notification :tmux,
  :display_message => true,
  :timeout => 3 # in seconds

#guard 'yard' do
#  watch(%r{lib/.+\.rb})
#end
