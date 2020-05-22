---
title: "Islandora MODS Post Processing"
publishdate: 2020-05-22
draft: false
tags:
  - islandora_mods_via_twig
  - islandora_mods_post_processing
---

> Attention: On 21-May-2020 this optional, but recommended, sixth step was added to the workflow that is documented in [Exporting, Editing, & Replacing MODS Datastreams](/en/posts/069-exporting-editing-replacing-mods-datastreams/) and [Exporting, Editing, & Replacing MODS Datastreams: Technical Details](/en/posts/070-exporting-editing-replacing-mods-datastreams-technical-details/). This addtional workflow step comes in the form of a new _Drush_ command: _islandora\_mods_post\_processing_, an addition to my previous work in [islandora_mods_via_twig](https://github.com/DigitalGrinnell/islandora_mods_via_twig).

## Purpose

Many of the objects in _Digital.Grinnell_ are "shared" between two or more collections.  For example, [grinnell:10361](https://digital.grinnell.edu/islandora/object/grinell:10361) can be found in both the ["Social Justice"](https://digital.grinnell.edu/islandora/object/grinnell:social-justice) and "Student Scholarship"](https://digital.grinnell.edu/islandora/object/grinnell:student-scholarship) collections.

This step in the workflow is designed to account for all of an object's "duplicate" MODS records no matter which collection(s) they appear in. The intent is to make "duplicates" easily recognizable so that we don't waste time editing them more than once.

## Recap: The Original 5-Step Workflow

This document is a follow-up and additon, with technical details, to [Exporting, Editing, & Replacing MODS Datastreams: Technical Details](/en/posts/070-exporting-editing-replacing-mods-datastreams-technical-details/), post 070, in my blog. As such, it should not be necessary for metadata editors working on the 2020 _Grinnell College Libraries_ review of _Digital Grinnell_ MODS metadata to implement this step, but it should help them better understand the process as a whole.

Attention: This document uses a shorthand `./` in place of the frequently referenced `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/` directory.  For example, `./social-justice` is equivalent to the _Social Justice_ collection sub-directory at `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/social-justice`.

Briefly, the initial five steps in this workflow are:

  1. Export of all `grinnell:*` _MODS_ datastreams using `drush islandora_datastream_export`.  This step, last performed on April 14, 2020, was responsible for creating all of the `grinnell_<PID>_MODS.xml` exports found in `./<collection-PID>`.

  2. Execute my _Map-MODS-to-MASTER_ _Python 3_ script on iMac _MA8660_ to create a `mods.tsv` file for each collection, along with associated `grinnell_<PID>_MODS.log` and `grinnell_<PID>_MODS.remainder` files for each object. The resultant `./<collection-PID>/mods.tsv` files are tab-seperated-value (.tsv) files, and they are **key** to this process.

  3. Edit the MODS .tsv files.  Refer [Exporting, Editing, & Replacing MODS Datastreams](https://dlad.summittdweller.com/en/posts/069-exporting-editing-replacing-mods-datastreams/) for details and guidance.

  4. Use `drush islandora_mods_via_twig` in each ready-for-update collection to generate new .xml MODS datastream files. For a specified collection, this command will find and read the `./<collection-PID>/mods-imvt.tsv` and create one `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file for each object.

  5. Execute the `drush islandora_datastream_replace` command once for each collection.  This command will process each `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file and replace the corresponding object's MODS datastream with the contents of the .xml file.  The _digital_grinnell_ branch version of the `islandora_datastream_replace` command also performs an implicit update of the object's "Title", a transform of the new MODS to DC (_Dublin Core_), and a re-indexing of the new metadata in _Solr_.

## Step 6 - Islandora MODS Post Processing

This is an optional, but recommended, step at the end of the workflow, and it is intended for use by a system admin, the same person who executes steps 4 and 5. The process calls for running a new _Drush_ command inside the _Apache_ container on the _Digital.Grinnell_ host.

To process a collection after completion of steps 4 and 5, all that's required is running a `drush islandora_mods_post_processing`. Running that command with the `--help` option produces:

```
[islandora@dgdocker1 ~]$ docker exec -it isle-apache-dg bash
root@122092fe8182:/# cd /var/www/html/sites/default/
root@122092fe8182:/var/www/html/sites/default# drush -u 1 islandora_mods_post_processing --help
Find a collection's ./ready-for-datastream-replace/*.used files and comment out found PIDs from all *.tsv files.

Examples:
  drush -u 1 islandora_mods_post_processing social-justice  Process ../social-justice/ready-for-database-replace/*.used files.

Arguments:
  collection                                                The name of the collection to be examined for *.used files.  Defaults to "social-justice".

Aliases: impp
```

So, my command sequence to run `islandora_mods_post_processing` for the "Social Justice" collection, as an example, was:

```
[islandora@dgdocker1 ~]$ docker exec -it isle-apache-dg bash
root@122092fe8182:/# cd /var/www/html/sites/default/
root@122092fe8182:/var/www/html/sites/default# drush -u 1 islandora_mods_post_processing social-justice
```

## Process Details

The `islandora_mods_post_processing` command does the following:

  1. Builds a list of all the object PIDs that have successfully passed through steps 1 through 5, by identifying all of the `*.used` files in the `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/<target-collection>` directory. Note that `.used` files are generated as part of Step 5 in this workflow.

  2. Builds a list of all the `*.tsv` files that exist in all `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/<target-collection>` sub-directories.

  3. For each object PID identified in step 1 (above), the process searches for a match at the start of each row (the first column) in each `*.tsv` file identifed in step 2 (above).  When a match is found that PID is replaced by a hashtag-prefixed string, a "comment".  The replacement/comment string includes the hashtag, the object PID with a double colon (::), a timestamp, and the name of the collection that was processed. It will look something like this:

    ```
    # grinnell::102 - reviewed and modified at Thu, 21 May 20 23:19:59 -0500 as part of social-justice
    ```

## Repeat As Needed

Note that this process is designed to be repeated as often as required. Since the process modifies the PIDs that are searched for, there should be no chance of duplication since subsequent executions won't find the same PIDs that were found previously.


And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
