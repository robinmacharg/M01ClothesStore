# M01ClothesStore

Technical Test for Deloitte.  See the included PDF for the full spec.  All required items have been completed; the spec has not been intentionally exceeded and this is by design.  This does mean some niceties have been omitted, e.g. count badging on cart/wishlist, selection animation, +/- UI, more nuanced UI etc.

## Project structure.

The top-level project directory contains three subdirectories:

- `M01ClothesStore` - the main project
- `M01ClothesStoreTests` - Unit tests for the project - basic tests from the project start.  
- `M01ClothesStoreUITests` - UI Tests for the project - scaffolding only, none implemented

## M01ClothesStore

This is further subdivided into: 

- `Screens` - one group for each screen in the app
- `Views` - shared subviews, e.g. table cells
- `Repository` - Storage-related code, Fundamental objects, API access, persistence etc.
- `Protocols` - As it says
- `Misc` - bits and pieces that don't fit anywhere above.

There's also a top-level AppDelegate, Assets and the info.plist

The project targets iPhone 11 Pro (12.x+) and was written with XCode 11.2.1 running under Mojave (MacOS 10.14.x) as well as a High Sierra laptop.  I target iOS 12.2, having backported from the default 13.x that XCode created.  

The Git repo has requirements-issues for each point as well as a couple of bug/non trunk enhancements.  I kept these to a minimum since the spec didn't require them.  I used GitFlow Feature branches with Fork, although the wishlist functionalities got rolled into a single feature since they went hand-in-hand.

It was a fairly incremental dev., not looking too far ahead (although obviously I'd read the spec in its entirety).  This lack of look-ahead reflects dev. iterations and show in e.g. button functionality changing as wishlist stuff came in.

I've used groups, delegation and protocols where appropriate.  Extensions break up monolithic classes by protocol.  I've tried to keep the VCs to a reasonable size.  There's another refactoring pass to pull out commonalities, and better support testing with better dependency inversion.  Commenting could be more consistent but was slightly skimped on due to time constraints.

## App Structure

Looking at the `Main` storyboard you'll see a single `TabBarController` with three tabs, one for each major area: Catalogue, Wishlist and Cart.  There's a central singleton Repository that handles storage concerns - local model and API access.  It implements both `API` and `Model` protocols.  There's a single common auxilliary `UITableViewCell` subclass view that makes use of a delegate protocol.  Finally, some constants are defined - structurally - in the appropriately named file. 

CoreData was selected at project creation time but was not used for this exercise.
