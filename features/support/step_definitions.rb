Given "the following media folders exist:" do |table|
  table.create! DSMediaLibrary::Folder do
    belongs_to({ :parent_folder => :parent }, DSMediaLibrary::Folder)
  end
end

Given "the following media files exist:" do |table|
  table.create! DSNode::Resource do
    belongs_to({ :parent_folder => :folder }, DSMediaLibrary::Folder)
    file :file
  end
end

Given "I am on the homepage" do
  visit "/"
end

When "I follow {string}" do |link|
  click_link link
end

When "I check {string}" do |field|
  check field
end

Then "I should see the following media tree:" do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

When "I select {string} from {string}" do |value, field|
  select value, from: field
end

When "I fill in {string} with {string}" do |field, value|
  fill_in field, with: value
end

When "I press {string}" do |button|
  click_button button
end

Then "I should see {string}" do |text|
  page.should have_text(text)
end

When "I attach the {string} file to {string}" do |path, field|
  attach_file field, "features/support/fixtures/#{path}"
end

When "I follow {string} within the {string} folder" do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

When "I follow {string} within the {string} file" do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

When "I follow {string} under the {string} dropdown" do |string, string2|
  pending # Write code here that turns the phrase above into concrete actions
end

When "I open the media library for the {string}" do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

When "I choose {string}" do |field|
  choose field
end

Given "the following speakeasy playlists exist:" do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Then "I should see {string} checked" do |string|
  find_field(field).should be_checked
end

When "I close the modal window" do
  find(".modal-close").click
end

Then "I should see the following speakeasy playlists:" do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  pending # Write code here that turns the phrase above into concrete actions
end

Given "today is {string}" do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

