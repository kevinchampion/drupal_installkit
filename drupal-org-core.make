api = 2
core = 7.x

; Download Drupal core.
projects[drupal][type] = "core"
projects[drupal][version] = "7.27"

; If patches are to be applied, apply them below by using projects[drupal][patch][].
; Ensure that each patch is well documented here as to why it is being applied.
; Enables multi-profile inheritance with deep dependency checking.
projects[drupal][patch][] = "https://raw.github.com/amcgowanca/drupal_installkit/7.x-1.x/patches/core/1356276-D7-inheritable-profiles.patch"
; Allow for profiles to be loaded during install in system_list().
projects[drupal][patch][] = "https://raw.github.com/amcgowanca/drupal_installkit/7.x-1.x/patches/core/drupal-system_list-include_profiles_during_install_as_modules.patch"
; Resolves the undefined tab_root_map variable in menu translate problems.
projects[drupal][patch][] = "https://raw.github.com/amcgowanca/drupal_installkit/7.x-1.x/patches/core/undefined-menu-translate-notice-951098-50.patch"
; Allows for a no time limit of max_execution_time to persist if previously set.
projects[drupal][patch][] = "https://raw.github.com/amcgowanca/drupal_installkit/7.x-1.x/patches/core/drupal_set_time_limit.patch"
; Introduces a new alter hook for UUID Menu Links module
projects[drupal][patch][] = "https://raw.github.com/amcgowanca/drupal_uuid_menu_links/7.x-0.5.7/patches/menu_get_object-load-type-alter.patch"