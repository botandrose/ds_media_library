require "capybara/rspec"
require "capybara/poltergeist"
require "phantomjs/poltergeist"
require "byebug"
require "./spec/support/testapp"

feature "ds_media_library" do
  background do
    Capybara.app = TestApp
    Capybara.default_driver = :poltergeist

    TestApp.routes.draw do
      mount DSMediaLibrary::Engine => "/media_library"
    end
  end

  scenario "it provides a media library" do
    visit "/media_library"
    expect(page.text).to_not be_blank
  end
end
