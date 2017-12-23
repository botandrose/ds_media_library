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

When /^I open the media library for the "(.+?)"$/ do |field|
  field = find_field(field)
  field.find(:xpath, "..").find("label", text: "MEDIA LIBRARY").click
  sleep 0.3 # wait for css animation
end

When "I close the media library" do
  find(".dsml-modal-close").click
  sleep 0.3 # wait for css animation
end

Then /^I should see "(.+?)" as the "(.+?)" media$/ do |value, field|
  field = find_field(field)
  actual = field.find(:xpath, "..").all("dl dt").map(&:text).join(", ")
  expect(actual).to eq(value)
end

Then /^I should see the following "(.+?)" media library items:$/ do |field, table|
  field = find_field(field)
  actual = field.find(:xpath, "..").all("dl dt").map { |dt| [dt.text] }
  table.diff! actual
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

