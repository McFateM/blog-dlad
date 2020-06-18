---
title: "Here There Be WARCs"
publishdate: 2020-06-17
draft: false
tags:
  - WARC
  - wget
  - web archive
  - islandora_solution_pack_web_archive
  - islandora_datastream_replace
---

The term `WARC`, an abreviation of [Web ARChive](https://en.wikipedia.org/wiki/Web_ARChive), always reminds me of things like hobbits, elves, dark lords, and orcs, of course.  But this post has nothing to do with those things so I need to clear my head and press on.

A WARC is essentially a file format used to capture the content and organization of a web site. Recently, I was asked to add a pair of WARCs to _Digital.Grinnell_. Doing so proved to be quite an adventure, but I am pleased to report that we now have these two objects to show for it:

  - [The Global Mongol Century](https://digital.grinnell.edu/islandora/object/grinnell:27856), and
  - [World Music Instruments](https://digital.grinnell.edu/islandora/object/grinnell:27858).

## WARC Ingest - Failures and Success

What follows is a table of the steps, both failed and successful, taken to ingest the two new _Digital.Grinnell_ objects, along with notes about each step in the process.

| Ingest Step | Outcome | Notes |
| ---         | ---     | ---   |
| 1. .warc File Creation | Success | Rebecca Ciota used a `wget` command to create a .warc archive file and a .cdx "index" of each site from existing, "live" web content.  The command used in the case of _WMI_ was: `wget     --warc-file=WMI_warc.warc   --recursive  --level=5     --warc-cdx     --page-requisites     --html-extension     --convert-links     --execute robots=off     --directory-prefix=. -x /solr-search  --wait=10 --random-wait    http://omeka1.grinnell.edu/x/WorldMusicInstruments`  |  
| 2. .gz Compression | **Success** | Rebecca compressed each .warc and .cdx file pair into a compressed .gz archive to package the contents for subsequent processing. |
| 3. MODS Metadata Prep | **Success** | Rebecca added two rows of control data and MODS metadata to Google Sheet https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY to prep for [IMI](https://github.com/mnylc/islandora_multi_importer) ingest. |
| 4. .gz Files Added to //Storage | **Success** | The two .gz files generated in a previous step were copied to [//Storage](smb://storage.grinnell.edu/MEDIADB/DGIngest/WARC) for ingest. |
| 5. Attempted IMI Ingest | Failed | The aforementioned [IMI](https://github.com/mnylc/islandora_multi_importer) ingest process was invoked with Google Sheet https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY in [Digital.Grinnell](https://digital.grinnell.edu/multi_importer).  The process ran for a very long time, in excess of 30 minutes, before it failed with no error messages or indication of root cause. |
| 6. Attempted "Forms" Ingest of WMI Object | Failed | I navigated to the management page in our [Pending Review](https://digital.grinnell.edu/islandora/object/pending-review/manage) collection and engaged the "Add an object to this Collection" link. I selected the "Islandora Web ARChive Content Model" and "Web ARChive MODS Form" for ingest.  The form was not available so the ingest failed. |
| 7. WARC Module Updated | **Success** | Steps were taken to update the key module, [islandora_solution_pack_web_archive](https://github.com/Islandora/islandora_solution_pack_web_archive) on Digital Grinnell's node DGDocker1. The update ran without error. |
| 8. Repeated Step 6 | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (6) but even after the update no "Web ARChive MODS Form" was available. |
| 9. Repeated Step 8 with the Correct Form | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous steps (6 and 8) choosing the "DG ONE Form to Rule them All". The form opened and accepted input, but clicking "Next" presented the sub-form shown below, indicating that a .gz file could not be ingested. |
| 10. Unzipped the .gz Files | **Success** | The WMI's .gz file was nearly 2 GB in size, so I was unable to unzip it using the archive tool on my iMac.  I was able to use `gunzip` to process the files on CentOS node _DGDocker1_. The result was a `.warc` file and `.cdx` file pair for each object (a total of 4 files). |
| 11. Repeated Step 9 | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (9) and the sub-form. I terminated the upload process after about 2 hours (included my lunch break). The process could not be resumed from that point. |
| 12. Repeated Step 11 with the "Global Mongol Century" File | Limited **Success** | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (11) but with the .warc file representing "The Global Mongol Century" archive.  This .warc file was only 24.2 MB in size and the ingest worked (taking less than 5 minutes) producing [grinnell:27856](https://digital.grinnell.edu/islandora/object/grinnell:27856). No thumbnail image or other image derivatives were created, presumably because I did not choose the `Upload a screenshot?` option. |
| 13. Investigated Using `drush` | Failed | The updated [islandora_solution_pack_web_archive](https://github.com/Islandora/islandora_solution_pack_web_archive) module includes at least one `drush` command, and a non-web ingest of such large files would be preferred. However, investigation determined that the provided `drush` command does not provide an alternate means of ingest. |
| 14. Repeat Step 12 | **Success** | I repeated step 12 still using the relatively small "Global Mongol Century" .warc, but gave the object a title of "World Music Instruments". [grinnell:27858](https://digital.grinnell.edu/islandora/object/grinnell:27858) was created, again with no thumbnail image or other image derivatives. |
| 15. Attempted to Replace the OBJ Datastream | Failed | Navigating to https://digital.grinnell.edu/islandora/object/grinnell%3A27858/manage/datastreams, I selected the `replace` link associated with the OBJ datastream in an attempt to replace the small .warc object with the proper WMI .warc.  This process failed to finish after nearly an hour of processing, presumably because the WMI .warc is simply too large causing the web process to time-out before completion. |
| 16. Replaced the OBJ Datastream Using FEDORA | **Success** | I navigated to _Digital.Grinnell_'s FEDORA admin page at http://dgdocker1.grinnell.edu:8081/fedora/admin/, opened the grinnell:27858 object, and used the FEDORA admin interface there to replace its OBJ datastream. I allowed the upload portion of the process to "spin" for more than an hour, but when I stopped it and saved changes, I found a new OBJ that is 1.97 GB in size. That new OBJ appears to be viable. |

![WARC sub-form](/images/post-082/WARC-sub-form.png "WARC Sub-Form")

And that's time for a break.  Be back soon...
