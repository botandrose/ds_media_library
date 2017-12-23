Feature: Use media library in forms
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

  Scenario: Added media files show in root library
    When I attach the "cat.jpg" file to "Cat picture"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I follow "Manage Media Library"

    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | cat.jpg         |
      | example.jpg     |

  Scenario: Use media library to attach media
    When I open the media library for the "Cat picture"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

    When I choose "example.jpg"
    Then I should see the following "Cat picture" media library items:
      | example.jpg |

    # state persists when reopening
    When I open the media library for the "Cat picture"
    Then I should see "example.jpg" checked

    # state persists after closing again
    When I close the media library
    Then I should see the following "Cat picture" media library items:
      | example.jpg |

    # state persists after saving
    When I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see the following "Cat picture" media library items:
      | example.jpg |

    # state persists when opening after save
    When I open the media library for the "Cat picture"
    Then I should see "example.jpg" checked

  Scenario: Use media library to select multiple media
    When I open the media library for the "Dog pictures"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

    When I check "Example folder"
    And I check "example.jpg"
    And I check "example.mp4"
    And I close the media library
    Then I should see the following "Dog pictures" media library items:
      | example.mp4 |
      | example.jpg |

    # state persists when reopening
    When I open the media library for the "Dog pictures"
    And I check "Example folder"
    Then I should see "example.jpg" checked
    And I should see "example.mp4" checked

    # state persists after closing again
    When I close the media library
    Then I should see the following "Dog pictures" media library items:
      | example.mp4 |
      | example.jpg |

    # state persists after saving
    When I press "Save"
    Then I should see "WIDGET UPDATED"
    Then I should see the following "Dog pictures" media library items:
      | example.mp4 |
      | example.jpg |

    # state persists when opening after save
    When I open the media library for the "Dog pictures"
    And I check "Example folder"
    Then I should see "example.jpg" checked
    And I should see "example.mp4" checked

  Scenario: Assigning an item to an existing singular media library field replaces the original
    When I attach the "cat.jpg" file to "Cat picture"
    And I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see "cat.jpg" as the "Cat picture" media

    When I attach the "example.jpg" file to "Cat picture"
    And I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see "example.jpg" as the "Cat picture" media

    When I open the media library for the "Cat picture"
    And I choose "cat.jpg"
    And I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see "cat.jpg" as the "Cat picture" media

  Scenario: Uploading files to an existing multiple media library field appends to the original
    When I attach the following files to "Dog pictures":
      | example.jpg |
      | example.mp4 |
    And I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see the following "Dog pictures" media library items:
      | example.jpg |
      | example.mp4 |

    When I attach the following files to "Dog pictures":
      | NEW.jpg  |
      | EDIT.jpg |
    And I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see the following "Dog pictures" media library items:
      | example.jpg |
      | example.mp4 |
      | NEW.jpg     |
      | EDIT.jpg    |

  Scenario: Media library form helper can accept a block
    When I follow "Widget"
    Then I should not see "Baby name"

    When I open the media library for the "Baby picture"
    And I choose "example.jpg"
    And I fill in "Baby name" with "Cain"
    And I press "Save"
    Then I should see "WIDGET UPDATED"
    And I should see "Baby name" filled in with "Cain"

  Scenario: Media library form helper can accept a block with multiple media
    When I follow "Widget"
    Then I should not see "Embarassing picture 1 context"

    When I open the media library for the "Embarassing pictures"
    And I check "example.jpg"
    And I check "Example folder"
    And I check "example.mp4"
    And I close the media library

    When I fill in "Embarassing picture 1 context" with "Highschool"
    And I fill in "Embarassing picture 2 context" with "College"
    And I press "Save"

    Then I should see "WIDGET UPDATED"
    Then I should see the following "Embarassing pictures" media library items:
      | example.mp4 |
      | example.jpg |
    And I should see "Embarassing picture 1 context" filled in with "Highschool"
    And I should see "Embarassing picture 2 context" filled in with "College"

  Scenario: Removing media doesn't remove it from library
    When I attach the "cat.jpg" file to "Cat picture"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I open the media library for the "Cat picture"
    And I choose "example.jpg"
    And I press "Save"
    Then I should see "WIDGET UPDATED"

    When I follow "Manage Media Library"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | cat.jpg         |
      | example.jpg     |

  Scenario: Open all folders
    When I open the media library for the "Cat picture"
    And I follow "Open all folders"
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | - example.mp4   |
      | example.jpg     |

  Scenario: Search media (case-insensitive)
    When I open the media library for the "Cat picture"
    And I fill in "Search media library" with "Mp4"
    Then I should see the following media tree:
      | Example folder  |
      | - example.mp4   |

    When I clear the "Search media library" field
    Then I should see the following media tree:
      | Another folder  |
      | Example folder  |
      | example.jpg     |

