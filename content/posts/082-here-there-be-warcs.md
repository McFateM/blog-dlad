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
| 1. .warc File Creation | Success | Rebecca Ciota used a `wget` command to create a .warc archive file and a .cdx "index" of each site from existing, "live" web content. |
| 2. .gz Compression | Success | Rebecca compressed each .warc and .cdx file pair into a compressed .gz archive to package the contents for subsequent processing. |
| 3. MODS Metadata Prep | Success | Rebecca added two rows of control data and MODS metadata to Google Sheet https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY to prep for [IMI](https://github.com/mnylc/islandora_multi_importer) ingest. |
| 4. .gz Files Added to //Storage | Success | The two .gz files generated in a previous step were copied to [//Storage](smb://storage.grinnell.edu/MEDIADB/DGIngest/WARC) for ingest. |
| 5. Attempted IMI Ingest | Failed | The aforementioned [IMI](https://github.com/mnylc/islandora_multi_importer) ingest process was invoked with Google Sheet https://docs.google.com/spreadsheets/d/1X3rs7UhIdS6SumTwFUvRR0F6-OnGEIF5xnGzcLrFqNY in [Digital.Grinnell](https://digital.grinnell.edu/multi_importer).  The process ran for a very long time, in excess of 30 minutes, before it failed with no error messages or indication of root cause. |
| 6. Attempted "Forms" Ingest of WMI Object | Failed | I navigated to the management page in our [Pending Review](https://digital.grinnell.edu/islandora/object/pending-review/manage) collection and engaged the "Add and object to this Collection" link. I selected the "Islandora Web ARChive Content Model" and "Web ARChive MODS Form" for ingest.  The form was no available so the ingest failed. |
| 7. WARC Module Updated | Success | Steps were taken to update the key module, [islandora_solution_pack_web_archive](https://github.com/Islandora/islandora_solution_pack_web_archive) on Digital Grinnell's node DGDocker1. The update ran without error. |
| 8. Repeated Step 6 | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous step (6) but even after the update no "Web ARChive MODS Form" was available. |
| 9. Repeated Step 8 with the Correct Form | Failed | Still in the [Pending Review Manage page](https://digital.grinnell.edu/islandora/object/pending-review/manage) I repeated the previous steps (6 and 8) choosing the "DG ONE Form to Rule them All". The form opened and accepted input, but clicking "Next" presented the sub-form shown below, indicating that a .gz file could not be ingested. |


And that's time for a break.  Be back soon...
