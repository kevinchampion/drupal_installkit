<?php
/**
 * @file
 * Contains InstallKitInstallTask.
 */

/**
 * Base installation task class that executes tasks during install.
 */
abstract class InstallKitInstallTask implements InstallKitInstallTaskInterface {
  /**
   * An array of arguments for processing.
   *
   * @var array
   */
  protected $arguments = array();

  /**
   * An array of contextual information.
   *
   * @var array
   */
  protected $context = NULL;

  /**
   * Creates a new instance of InstallKitInstallTask.
   *
   * @access public
   */
  final public function __construct() {
    // Empty.
  }

  /**
   * {@inheritdoc}
   */
  final public function setContext(array &$context) {
    $this->context = &$context;
    return $this;
  }

  /**
   * {@inheritdoc}
   */
  final public function setArguments(array $arguments) {
    $this->arguments = $arguments;
    return $this;
  }
}
