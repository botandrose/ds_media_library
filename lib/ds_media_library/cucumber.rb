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

When /^I mark the "(.+?)" "(.+?)" media item for removal$/ do |label, value|
  field = find_field(label)
  within field.find(:xpath, "..").first("dl dfn", text: value) do
    uncheck "Remove #{label.singularize.downcase}"
  end
end

Then /^I should see "(.+?)" as the "(.+?)" media$/ do |value, label|
  field = find_field(label)
  actual = field.find(:xpath, "..").all("dl dt").map(&:text).join(", ")
  expect(actual).to eq(value)
end

Then /^I should see the following "(.+?)" media library items:$/ do |label, table|
  field = find_field(label)
  actual = field.find(:xpath, "..").all("dl dt").map { |dt| [dt.text] }
  table.diff! actual
end

Then /^I should see no "(.+?)" media$/ do |label|
  field = find_field(label)
  actual = field.find(:xpath, "..").all("dl dt").map(&:text)
  expect(actual).to eq([])
end

Then "I should see the following media tree:" do |table|
  def recurse_tree root, structure = [], prefix = ""
    root.all(:xpath, "./li").each do |li|
      if label = li.first("label")
        type_name, created_at = if label[:class].include?("folder")
           2.times.map { "" }
        else
          li.all("div")[1..2].map(&:text)
        end
        structure << [prefix + label.text, type_name, created_at]
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

