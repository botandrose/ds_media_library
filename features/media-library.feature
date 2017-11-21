Feature: Manage media
  Background:
    Given the following media folders exist:
      | name           | parent_folder  |
      | Example folder |                |
      | Another folder |                |
    Given the following media files exist:
      | file           | parent_folder  |
      | example.jpg    |                |
      | example.mp4    | Example folder |

    Given I am on the homepage

  Scenario: See existing media
    When I check "Example folder"
    And I check "Another folder"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - example.mp4   |
      | example.jpg     |

  Scenario: Open all folders
    When I follow "Open all folders"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - example.mp4   |
      | example.jpg     |

  Scenario: Add a media folder
    When I follow "Add new folder"
    And I select "Another folder" from "Parent folder"
    And I fill in "Folder name" with "NEW folder"
    And I press "Save folder"

    Then I should see "FOLDER CREATED"
    When I check "Another folder"
    Then I should see the following media tree:
      | Another folder  |
      | - NEW folder    |
      | Example folder  |
      | example.jpg     |

  Scenario: Add a media file
    When I follow "Add new media"
    And I select "Example folder" from "Parent folder"
    And I attach the "NEW.jpg" file to "Upload media"
    And I press "Save media"

    Then I should see "MEDIA CREATED"
    When I check "Example folder"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - example.mp4   |
      | - NEW.jpg       |
      | example.jpg     |

  Scenario: Edit a media folder
    When I follow "Edit folder" within the "Example folder" folder
    And I select "Another folder" from "Parent folder"
    And I fill in "Folder name" with "EDIT folder"
    And I press "Save folder"

    Then I should see "FOLDER UPDATED"
    When I check "Another folder"
    Then I should see the following media tree:
      | Another folder  |
      | - EDIT folder   |
      | example.jpg     |
    When I check "EDIT folder"
    Then I should see the following media tree:
      | Another folder  |
      | - EDIT folder   |
      | -   example.mp4 |
      | example.jpg     |

  Scenario: Edit a media file
    When I follow "Edit media" within the "example.jpg" file
    And I select "Example folder" from "Parent folder"
    And I attach the "EDIT.jpg" file to "Upload media"
    And I press "Save media"

    Then I should see "MEDIA UPDATED"
    When I check "Example folder"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - EDIT.jpg      |
      | - example.mp4   |

  Scenario: Added media files show in root library
    When I follow "General Settings" under the "Registration Table" dropdown
    And I attach the "bg1.jpg" file to "Upload background"
    And I press "Save background"
    Then I should see "BACKGROUNDS UPDATED"

    When I follow "Media Library"

    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | bg1.jpg         |
      | example.jpg     |

  Scenario: Use media library to attach media
    When I follow "General Settings" under the "Concierge Wall" dropdown
    And I open the media library for the "Panel background"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

    When I choose "example.jpg"
    Then I should see "example.jpg"

    When I press "Save settings"
    Then I should see "GENERAL SETTINGS UPDATED"

    When I follow "General Settings" under the "Concierge Wall" dropdown
    Then I should see "example.jpg"

  Scenario: Use media library to select multiple media
    Given the following speakeasy playlists exist:
      | name             | location | timing   | media       |
      | Example playlist | A B C    | 1 minute | example.png |

    When I follow "Speakeasy"
    And I follow "Example playlist"
    And I check "Media library"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |
      | example.png     |
    And I should see "example.png" checked

    When I check "Example folder"
    And I check "example.jpg"
    And I check "example.mp4"
    And I close the modal window
    And I press "Save playlist"

    Then I should see "PLAYLIST UPDATED"
    And I should see the following speakeasy playlists:
      | LOCATION | NAME             | MEDIA ITEMS |
      | A B C    | Example playlist | 3           |

  Scenario: Removing media doesn't remove it from library
    When I follow "General Settings" under the "Registration Table" dropdown
    And I attach the "bg1.jpg" file to "Upload background"
    And I press "Save background"
    Then I should see "BACKGROUNDS UPDATED"

    When I attach the "bg2.jpg" file to "Upload background"
    And I press "Save background"
    Then I should see "BACKGROUNDS UPDATED"

    When I follow "Media Library"

    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | bg1.jpg         |
      | bg2.jpg         |
      | example.jpg     |

  Scenario: Batch move media to folders
    When I check "Select multiple media"
    And I check "Example folder"
    And I check "example.mp4"
    And I check "example.jpg"

    And I select "Another folder" from "Move selected to:"
    And I press "Move"

    Then I should see "MEDIA UPDATED"

    When I check "Another folder"
    Then I should see the following media tree:
      | Another folder  |
      | - example.jpg   |
      | - example.mp4   |
      | Example folder  |

  Scenario: (Soft) Delete media
    When I follow "General Settings" under the "Concierge Wall" dropdown
    And I open the media library for the "Panel background"
    And I choose "example.jpg"
    And I press "Save settings"
    Then I should see "GENERAL SETTINGS UPDATED"

    When I follow "Media Library"
    And I follow "Delete media" within the "example.jpg" file
    # And I confirm deletion

    Then I should see "MEDIA DELETED"
    And I should see the following media tree:
      | Another folder  |
      | Example folder  |

    When I follow "General Settings" under the "Concierge Wall" dropdown
    Then I should see "example.jpg"

  Scenario: Delete empty folder
    When I follow "Delete folder" within the "Another folder" folder
    # And I confirm deletion

    Then I should see "FOLDER DELETED"
    And I should see the following media tree:
      | Example folder  |
      | example.jpg     |

  Scenario: Delete filled folder (and move used media to root?)
    When I follow "Open all folders"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - example.mp4   |
      | example.jpg     |

    When I follow "Delete folder" within the "Example folder" folder
    # And I confirm deletion

    Then I should see "FOLDER DELETED"
    When I follow "Open all folders"
    Then I should see the following media tree:
      | Another folder  |
      | example.jpg     |
      | example.mp4     |

