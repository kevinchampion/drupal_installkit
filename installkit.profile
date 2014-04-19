<?php
/**
 * @file
 * InstallKit's implementation of core functions and hooks.
 */

require_once 'includes/installkit.system.inc';

/**
 * Denotes the version of InstallKit.
 */
define('INSTALLKIT_VERSION', '7.x-0.1');

/**
 * Defines the watchdog type.
 */
define('INSTALLKIT_WATCHDOG_TYPE', 'installkit');

/**
 * Denotes the core default administrator role.
 */
define('INSTALLKIT_USER_ADMINISTRATOR_ROLE', 'administrator');

/**
 * Denotes the core admin (uid = 1) user identifier.
 */
define('INSTALLKIT_ADMINISTRATOR_UID', 1);

/**
 * Implements hook_install_tasks_alter().
 */
function installkit_install_tasks_alter(&$tasks, $install_state) {
  global $install_state;
  installkit_load_include('inc', 'includes/installkit.install');
  installkit_install_bootstrap($tasks, $install_state);
}

/**
 * Implements hook_form_FORM_ID_alter() for install_configure_form().
 *
 * Allows the profile to alter the site configuration form.
 */
function installkit_form_install_configure_form_alter(&$form, $form_state) {
  $form['site_information']['site_name']['#default_value'] = $_SERVER['SERVER_NAME'];
}

/**
 * Loads an InstallKit include specifically.
 *
 * This function makes use of the `require_once` language construct. Therefore,
 * ensure this is a noted behavior when implementing usages of this function.
 *
 * @param string $type
 *   The type of file to include. Example: inc.
 * @param string $name
 *   The name of the file to locate and include.
 *
 * @return mixed
 *   Returns the absolute file path as a string if found and included, otherwise
 *   returns FALSE if the file was not found.
 */
function installkit_load_include($type, $name) {
  if (function_exists('drupal_get_path')) {
    $file = DRUPAL_ROOT . '/' . drupal_get_path('profile', 'installkit') . '/' . $name . '.' . $type;
    if (is_file($file)) {
      require_once $file;
      return $file;
    }
  }
  return FALSE;
}

/**
 * Returns an array of installation profiles, in reverse order.
 *
 * The returned array of installation profiles allow for proper execution
 * hierarchy, for example this base installation profile will be the last in
 * the returned array vs. the "concrete" instances will be first.
 *
 * @return array
 *   Returns an array of installation profile names.
 */
function installkit_get_install_profiles() {
  static $profiles = NULL;
  if (NULL === $profiles) {
    $profiles = drupal_get_profiles();
    $profiles = array_reverse($profiles);
  }

  return $profiles;
}

/**
 * Pass alterable variables to PROFILE_TYPE_alter().
 *
 * @param string $type
 *   The type to alter.
 * @param mixed $data
 *   The data to alter, passed by reference.
 * @param mixed $context1
 *   An additional variable that is passed by reference, optional.
 * @param mixed $context2
 *   An additional variable that is passed by reference, optional.
 */
function installkit_profile_alter($type, &$data, &$context1 = NULL, &$context2 = NULL) {
  foreach (installkit_get_install_profiles() as $profile) {
    $function = $profile . '_' . $type . '_alter';
    if (function_exists($function)) {
      $function($data, $context1, $context2);
    }
  }
}

/**
 * Log handler for logging watchdog like messages.
 *
 * @param int $type
 *   The watchdog severity level.
 * @param string $message
 *   The log message.
 * @param array $variables
 *   An array of variables.
 */
function installkit_log($type, $message, array $variables = array()) {
  watchdog(INSTALLKIT_WATCHDOG_TYPE, $message, $variables, $type);
}

/**
 * Logs an exception.
 *
 * @param Exception $exception
 *   The Exception object to log.
 */
function installkit_log_exception(Exception $exception) {
  installkit_log(WATCHDOG_ERROR, $exception->getMessage(), array(
    'exception' => $exception,
  ));
}

/**
 * Implements hook_watchdog().
 */
function installkit_watchdog(array $log_entry) {
  // Attempt to assume we are using `drush`, therefore add this watchdog
  // log to the drush log output.
  if (drupal_is_cli() && function_exists('drush_log')) {
    if (!is_array($log_entry['variables'])) {
      $log_entry['variables'] = NULL;
    }

    $message = isset($log_entry['variables']) && !empty($log_entry['variables']) ? dt($log_entry['message'], $log_entry['variables']) : $log_entry['message'];
    drush_log($message, installkit_watchdog_severity_string($log_entry['severity']));
  }
}

/**
 * Returns a string representation for Drush log for watchdog severity.
 *
 * @param int $severity
 *   A Drupal core's WATCHDOG severity level.
 *
 * @return string
 *   Returns a string representation for drush log.
 */
function installkit_watchdog_severity_string($severity) {
  switch ($severity) {
    case WATCHDOG_EMERGENCY:
    case WATCHDOG_ALERT:
    case WATCHDOG_CRITICAL:
    case WATCHDOG_ERROR:
      return 'error';

    case WATCHDOG_WARNING:
      return 'warning';

    case WATCHDOG_NOTICE:
    case WATCHDOG_INFO:
    case WATCHDOG_DEBUG:
    default:
      return 'notice';
  }
}
