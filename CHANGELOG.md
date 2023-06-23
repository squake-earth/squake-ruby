# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2023-06-21

### Added

* added `Squake.configure`
* introduced global config allowig to omit the `client` from all service calls

### Changed

* All public services now return a `Return` class that contains the actual data or an error object. This replaces the throwing of errors for control-flow.

## [0.2.1 - 0.2.4] - 2023-06-21

### Fixed

* Boilerplate bugs

## [0.2.0] - 2023-06-15

### Added

* request carbon emissions (without price quote)

## [0.1.0] - 2023-06-14

Initial release of an MVP/POC library. Only v2 of the SQUAKE API is supported.

### Added

* request carbon emission and price quote
* make a purchase
* retrieve a purchase
* cancel a purchase
