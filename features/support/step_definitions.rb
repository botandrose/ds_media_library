require "ds_media_library/cucumber"

Given "I am on the homepage" do
  visit "/"
end

When "I follow {string}" do |link|
  click_link link
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

Then "I should see {string}" do |text|
  expect(page).to have_text(text)
end

Then "I should not see {string}" do |text|
  expect(page).to_not have_text(text)
end

When "I attach the {string} file to {string}" do |path, field|
  attach_file field, "features/support/fixtures/#{path}"
end

When "I attach the following files to {string}:" do |field, table|
  files = table.raw.map do |row|
    "features/support/fixtures/#{row.first}"
  end
  attach_file field, files
end

When "I follow {string} within the {string} file/folder" do |link, context|
  within "li", text: context do
    click_link link
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

