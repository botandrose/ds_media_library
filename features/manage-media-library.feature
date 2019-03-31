Feature: Manage media library
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
    When I follow "Manage Media Library"

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
      | - NEW.jpg       |
      | - example.mp4   |
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

  Scenario: Batch delete media
    When I check "Select multiple media"
    And I check "Example folder"
    And I check "example.mp4"
    And I check "example.jpg"

    And I press and confirm "Delete all selected"

    Then I should see "MEDIA DELETED"

    When I check "Example folder"
    And I check "Another folder"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |

  Scenario: Search media (case-insensitive)
    When I fill in "Search media library" with "Mp4"
    Then I should see the following media tree:
      | Example folder  |
      | - example.mp4   |

    When I clear the "Search media library" field
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

  Scenario: (Soft) Delete media
    When I follow "Widget"
    And I open the media library for the "Cat picture"
    And I choose "example.jpg"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I follow "Manage Media Library"
    And I follow and confirm "Delete media" within the "example.jpg" file

    Then I should see "MEDIA DELETED"
    And I should see the following media tree:
      | Another folder  |
      | Example folder  |

  # Scenario: Deleted media is removed from search results
    When I fill in "Search media library" with "example"
    Then I should see the following media tree:
      | Example folder  |
      | - example.mp4   |

  # Scenario: Deleted media is not removed from usage
    When I follow "Widget"
    Then I should see "example.jpg"

  Scenario: Delete empty folder
    When I follow and confirm "Delete folder" within the "Another folder" folder

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

    When I follow and confirm "Delete folder" within the "Example folder" folder

    Then I should see "FOLDER DELETED"
    When I follow "Open all folders"
    Then I should see the following media tree:
      | Another folder  |
      | example.jpg     |
      | example.mp4     |

