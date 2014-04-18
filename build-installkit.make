api = 2
core = 7.x

; Download Drupal core.
includes[] = "https://raw.github.com/amcgowanca/drupal_installkit/7.x-1.x/drupal-org-core.make"

; Download the InstallKit installation profile.
projects[installkit][type] = "profile"
projects[installkit][download][type] = "git"
projects[installkit][download][url] = "git@github.com:amcgowanca/drupal_installkit.git"
projects[installkit][download][branch] = "7.x-1.x"
