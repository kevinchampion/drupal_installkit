<?php
/**
 * @file
 * Contains InstallKitInstallDefaultsInstallTask.
 */

/**
 * Handles the default configurations of the profile install.
 */
class InstallKitInstallDefaultsInstallTask extends InstallKitInstallTask {
  /**
   * {@inheritdoc}
   */
  public function execute() {
    // For each profile that is a child of this, attempt to find the
    // default theme by invoking hook_installkit_default_theme().
    $default_theme = NULL;
    foreach (installkit_get_install_profiles() as $profile) {
      $function = $profile . '_installkit_default_theme';
      if (function_exists($function)) {
        $default_theme = $function();
      }
    }

    if ($default_theme) {
      // Disable bartik, it is no longer needed.
      theme_disable(array('bartik'));
      // Enable the default theme and set it as a the default.
      theme_enable(array($default_theme));
      variable_set('theme_default', $default_theme);
    }

    if (module_exists('uuid_menu_links')) {
      // Let's synchronize all links and paths to contain UUIDs.
      uuid_menu_links_sync();
    }

    if (module_exists('page_manager')) {
      // Disable CTools page manager node view by default.
      variable_set('page_manager_node_view_disabled', FALSE);
    }

    // Set and share the completion message.
    $this->context['message'] = st('Default configuration and setup complete');
  }
}
