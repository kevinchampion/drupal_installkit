<?php
/**
 * @file
 * Contains InstallKitInstallModuleInstallTask.
 */

/**
 * Handles the installation of a module during the profile install.
 */
class InstallKitInstallModuleInstallTask extends InstallKitInstallTask {
  /**
   * {@inheritdoc}
   */
  public function execute() {
    // If no module is specified, this task cannot run, exit early.
    if (empty($this->arguments['module'])) {
      installkit_log(WATCHDOG_DEBUG, st('Unspecified module attempting to be enabled.'));
      return;
    }
    // Attempt to enable the specified module and log the results.
    $enabled = module_enable(array($this->arguments['module']), TRUE);
    $module_name = empty($this->arguments['module name']) ? $this->arguments['module'] : $this->arguments['module name'];
    if ($enabled) {
      $message = st('Installed module @module', array('@module' => $module_name));
      installkit_log(WATCHDOG_NOTICE, $message);
    }
    else {
      $message = st('Failed to install module @module', array('@module' => $module_name));
      installkit_log(WATCHDOG_ERROR, $message);
    }
    // Set the context message so that user's know what is happening.
    $this->context['message'] = $message;
  }
}
