SimpleCov.start 'rails' do
  add_filter '/spec/' # Exclude spec files from coverage
  add_filter '/features/' # Exclude cucumber features from coverage if not desired
  track_files '{app,lib}/**/*.rb'
end

SimpleCov.at_exit do
  SimpleCov.result.format!
end
