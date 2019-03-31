require "ds_media_library/cucumber"
require "timecop"

Given "I am on the homepage" do
  visit "/"
end

Given "today is {string}" do |time|
  Timecop.freeze time
end

After do |scenario|
  Timecop.return
end

When "I follow {string}" do |link|
  click_link link
end

When "I follow and confirm {string}" do |link|
  accept_confirm { click_link link }
end

When "I check {string}" do |field|
  check field
end

When "I select {string} from {string}" do |value, field|
  select value, from: field
end

When "I fill in {string} with {string}" do |field, value|
  fill_in field, with: value
end

When "I clear the {string} field" do |label|
  field = find_field(label)
  field.value.length.times do
    field.send_keys :backspace
  end
end

When "I press {string}" do |button|
  click_button button
end

When "I press and confirm {string}" do |button|
  accept_confirm { click_button button } 
end

Then "I should see {string}" do |text|
  expect(page).to have_text(text)
end

Then "I should not see {string}" do |text|
  expect(page).to_not have_text(text)
end

When "I attach the {string} file to {string}" do |path, field|
  attach_file field, File.expand_path("features/support/fixtures/#{path}")
end

When "I attach the following files to {string}:" do |field, table|
  files = table.raw.map do |row|
    File.expand_path("features/support/fixtures/#{row.first}")
  end
  attach_file field, files
end

When "I follow {string} within the {string} file/folder" do |link, context|
  within "li", text: context do
    click_link link
  end
end

When "I follow and confirm {string} within the {string} file/folder" do |link, context|
  within "li", text: context do
    accept_confirm { click_link link }
  end
end

When "I choose {string}" do |field|
  choose field
end

Then "I should see {string} checked" do |field|
  expect(find_field(field)).to be_checked
end

Then "I should see {string} filled in with {string}" do |field, value|
  expect(find_field(field).value).to eq(value)
end

