<?php
/**
 * @file
 * Contains InstallKitInstallTaskInterface.
 */

/**
 * Interface for describing an installation task with InstallKit.
 */
interface InstallKitInstallTaskInterface {
  /**
   * Sets the contextual information for this task.
   *
   * @access public
   *
   * @param array $context
   *   An array of contextual information.
   *
   * @return InstallKitInstallTaskInterface
   *   Returns this instance of the InstallKitInstallTask.
   */
  public function setContext(array &$context);

  /**
   * Sets the arguments to be used within the `execute()` of this task.
   *
   * @access public
   *
   * @param array $arguments
   *   A keyed array of arguments to set.
   *
   * @return InstallKitInstallTaskInterface
   *   Returns this instance of the InstallKitInstallTask.
   */
  public function setArguments(array $arguments);

  /**
   * Performs the operations for this installation task.
   *
   * @access public
   */
  public function execute();
}
