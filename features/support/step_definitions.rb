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
  def recurse_tree root, structure = [], prefix = ""
    root.all(:xpath, "./li").each do |li|
      if label = li.first("label")
        structure << [prefix + label.text]
      end
      if root = li.first("ul")
        new_prefix = prefix.empty? ? "- #{prefix}" : prefix + "  "
        structure = recurse_tree(root, structure, new_prefix)
      end
    end
    structure
  end

  table.diff! recurse_tree(find("#dsml-media-tree"))
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

When "I attach the {string} file to {string}" do |path, field|
  attach_file field, "features/support/fixtures/#{path}"
end

When "I follow {string} within the {string} file/folder" do |link, context|
  within "li", text: context do
    click_link link
  end
end

When "I open the media library for the {string}" do |field|
  field = find_field(field)
  field.find(:xpath, "..").find("label", text: "MEDIA LIBRARY").click
end

When "I choose {string}" do |field|
  choose field
end

Then "I should see {string} checked" do |field|
  expect(find_field(field)).to be_checked
end

When "I close the modal window" do
  find(".modal-close").click
end

