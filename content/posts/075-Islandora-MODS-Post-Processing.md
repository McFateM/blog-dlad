---
title: "Islandora MODS Post Processing"
publishdate: 2020-05-22
draft: false
tags:
  - islandora_mods_via_twig
  - islandora_mods_post_processing
---

> Attention: On 21-May-2020 this optional, but recommended, sixth step was added to the workflow that is documented in [Exporting, Editing, & Replacing MODS Datastreams](/en/posts/069-exporting-editing-replacing-mods-datastreams/) and [Exporting, Editing, & Replacing MODS Datastreams: Technical Details](/en/posts/070-exporting-editing-replacing-mods-datastreams-technical-details/). This addtional workflow step comes in the form of a new _Drush_ command: _islandora\_mods_post\_processing_, an addition to my previous work in [islandora_mods_via_twig](https://github.com/DigitalGrinnell/islandora_mods_via_twig).

# Recap: The Inital 5-Step Workflow

This document is a follow-up and additon, with technical details, to [Exporting, Editing, & Replacing MODS Datastreams: Technical Details](/en/posts/070-exporting-editing-replacing-mods-datastreams-technical-details/), post 070, in my blog. As such, it should not be necessary for metadata editors working on the 2020 _Grinnell College Libraries_ review of _Digital Grinnell_ MODS metadata to implement this step, but it should help them better understand the process as a whole.

Attention: This document uses a shorthand `./` in place of the frequently referenced `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/` directory.  For example, `./social-justice` is equivalent to the _Social Justice_ collection sub-directory at `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/social-justice`.

Briefly, the initial five steps in this workflow are:

  1. Export of all `grinnell:*` _MODS_ datastreams using `drush islandora_datastream_export`.  This step, last performed on April 14, 2020, was responsible for creating all of the `grinnell_<PID>_MODS.xml` exports found in `./<collection-PID>`.

  2. Execute my _Map-MODS-to-MASTER_ _Python 3_ script on iMac _MA8660_ to create a `mods.tsv` file for each collection, along with associated `grinnell_<PID>_MODS.log` and `grinnell_<PID>_MODS.remainder` files for each object. The resultant `./<collection-PID>/mods.tsv` files are tab-seperated-value (.tsv) files, and they are **key** to this process.

  3. Edit the MODS .tsv files.  Refer [Exporting, Editing, & Replacing MODS Datastreams](https://dlad.summittdweller.com/en/posts/069-exporting-editing-replacing-mods-datastreams/) for details and guidance.

  4. Use `drush islandora_mods_via_twig` in each ready-for-update collection to generate new .xml MODS datastream files. For a specified collection, this command will find and read the `./<collection-PID>/mods-imvt.tsv` and create one `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file for each object.

  5. Execute the `drush islandora_datastream_replace` command once for each collection.  This command will process each `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file and replace the corresponding object's MODS datastream with the contents of the .xml file.  The _digital_grinnell_ branch version of the `islandora_datastream_replace` command also performs an implicit update of the object's "Title", a transform of the new MODS to DC (_Dublin Core_), and a re-indexing of the new metadata in _Solr_.

## Step 6 - Installation MODS Post Processing

...Working on it!

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
