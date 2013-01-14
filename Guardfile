guard 'rspec', cli: "--color --format d", , all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})               { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')            { 'spec' }
  watch('spec/factories.rb')              { 'spec' }
  watch(%r{^spec/factories/(.+)\.rb})     { 'spec' }
  watch(%r{^spec/support/(.+)_spec\.rb})  { |m| "spec/#{m[1]}s/*" }
end

notification :tmux,
  :display_message => true,
  :timeout => 3 # in seconds


# guard 'shell' do
#   # watch(%r{(.*)}) {|m| `echo #{m[0]}` }
#   watch(%r{lib/(.+)\.rb$})     { |m| `echo spec/#{m[1]}_spec.rb` }
#   # watch(%r{(.*)}) {|m| raise m.to_s }
# end

guard 'yard' do
  watch(%r{lib/.+\.rb})
end
