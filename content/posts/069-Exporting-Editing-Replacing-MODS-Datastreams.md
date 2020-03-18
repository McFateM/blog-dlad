---
title: "Exporting, Editing, & Replacing MODS Datastreams"
publishdate: 2020-03-17
lastmod: 2020-03-17T14:46:51-05:00
draft: false
tags:
  - MODS
  - Export
  - Replace
---

The transition to distance learning that's taking place at _Grinnell College_ in the wake of the _COVID-19_ pandemic may afford _GC Libraries_ an opportunity to do some overdue and necessary metadata cleaning in [Digital.Grinnell](https://digital.grinnell.edu).  I believe that library staff who cannot take their usual work home will be asked to assist, and I am personally grateful that our leadership sees fit to do this, and am looking forward to supporting and working with my outstanding colleagues who will tackle this task.

To help implement this process efficiently and effectively I'm first turning to "[Exporting, Editing, & Replacing MODS Datastreams](https://github.com/calhist/documentation/wiki/Exporting,-Editing,-&-Replacing-MODS-Datastreams)", a workflow developed by the good folks at [The California Historical Society](https://californiahistoricalsociety.org/).  I'll initiate the workflow with installation of two _Drush_ tools on my [local/development instance](https://dg.localdomain) of [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) on my Mac workstation.

## Installing Necessary Modules

The command line process in my local host/workstation terminal looks like this:

```
docker exec -w /var/www/html/sites/all/modules/islandora/ isle-apache-ld git clone https://github.com/Islandora-Labs/islandora_datastream_exporter.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ isle-apache-ld git clone https://github.com/pc37utn/islandora_datastream_replace.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ isle-apache-ld chown -R islandora:www-data *
docker exec -w /var/www/html/sites/default isle-apache-ld drush en islandora_datastream_exporter islandora_datastream_replace -y
docker exec -w /var/www/html/sites/default isle-apache-ld drush cc drush -y
```

## Exporting "grinnell:" Namespace Objects

I've elected to export all of the "grinnell:" namespace objects to my _private:_ filesystem which resides on my host at `~/GitHub/dg-isle/private` and maps into my _Apache_ container as `/var/www/private`.  The commands are:

```
docker exec -w /var/www/ isle-apache-ld chown -R islandora:www-data private
docker exec -w /var/www/ isle-apache-ld chmod 775 private
docker exec -w /var/www/html/sites/default/ isle-apache-ld drush -u 1 islandora_datastream_export --export_target=/var/www/private --query=PID:grinnell* --dsid=MODS
```

The last command in the above set populated the _export\_target_ directory mentioned above, and the result looks like this:

```
╭─mark@Marks-Mac-Mini ~/GitHub/dg-isle/private ‹master*›
╰─$ ls -alh
total 128
drwxrwxr-x@ 14 mark  staff   448B Mar 17 15:37 .
drwxr-xr-x  30 mark  staff   960B Mar 12 19:40 ..
-rw-r--r--@  1 mark  staff   675B Mar 10 14:01 .htaccess
-rw-r--r--   1 mark  staff   2.4K Mar 17 15:48 grinnell_11569_MODS.xml
-rw-r--r--   1 mark  staff   2.5K Mar 17 15:50 grinnell_20575_MODS.xml
-rw-r--r--   1 mark  staff   7.8K Mar 17 15:38 grinnell_25482_MODS.xml
-rw-r--r--   1 mark  staff   7.4K Mar 17 15:38 grinnell_25483_MODS.xml
-rw-r--r--   1 mark  staff   7.3K Mar 17 15:38 grinnell_25484_MODS.xml
-rw-r--r--   1 mark  staff   1.3K Mar 17 15:38 grinnell_25493_MODS.xml
-rw-r--r--   1 mark  staff   1.3K Mar 17 15:38 grinnell_25494_MODS.xml
-rw-r--r--   1 mark  staff   1.1K Mar 17 15:38 grinnell_25495_MODS.xml
-rw-r--r--   1 mark  staff   1.3K Mar 17 15:38 grinnell_25497_MODS.xml
-rw-r--r--   1 mark  staff   4.8K Mar 17 15:38 grinnell_25510_MODS.xml
-rw-r--r--   1 mark  staff   2.7K Mar 17 15:48 grinnell_3246_MODS.xml
```

Note that objects, like collections in the "grinnell:" namespace, which have no MODS datastream were reported as such, and were automatically excluded from populating the _export\_target_ directory.

## Editing the MODS Metadata

I found a simple and effective process for editing the `.xml` files that were produced, using [Atom](https://atom.io). For testing purposes I made changes in a few of the objects listed above: 3246, 11569, 20575, and 25497.  These changes included removing some empty XML tags, changing student/alumni graduation class years from ` '64` notation to `, Class of 1964`, as well as eliminiation of trailing whitespace and whitespace lines.  Now I'll push them back into the repository to confirm that the workflow does indeed "work".

## Importing the Changes

My command line "test" import of all the exported objects goes like this:

```
docker exec -w /var/www/html/sites/default/ isle-apache-ld drush -u 1 islandora_datastream_replace --dsid=MODS --source=/var/www/private/ --namespace=grinnell
```

And the output from that command, with whitelines removed, is:

```
╭─mark@Marks-Mac-Mini ~/GitHub/dg-isle ‹master*›
╰─$ docker exec -w /var/www/html/sites/default/ isle-apache-ld drush -u 1 islandora_datastream_replace --dsid=MODS --source=/var/www/private/ --namespace=grinnell
dsid=MODS  filename=
 dsid is not in filename!
dsid=MODS  filename=.
 dsid is not in filename!
dsid=MODS  filename=
 dsid is not in filename!
 file = grinnell_11569_MODS
pidnum=11569
Datastream replacement succeeded for grinnell:11569.                   [success]
 file = grinnell_20575_MODS
pidnum=20575
 file = grinnell_25482_MODS
pidnum=25482
Datastream replacement succeeded for grinnell:20575.                   [success]
 file = grinnell_25483_MODS
pidnum=25483
Datastream replacement succeeded for grinnell:25482.                   [success]
Datastream replacement succeeded for grinnell:25483.                   [success]
 file = grinnell_25484_MODS
pidnum=25484
Datastream replacement succeeded for grinnell:25484.                   [success]
 file = grinnell_25493_MODS
pidnum=25493
Datastream replacement succeeded for grinnell:25493.                   [success]
 file = grinnell_25494_MODS
pidnum=25494
Datastream replacement succeeded for grinnell:25494.                   [success]
 file = grinnell_25495_MODS
pidnum=25495
Datastream replacement succeeded for grinnell:25495.                   [success]
 file = grinnell_25497_MODS
pidnum=25497
Datastream replacement succeeded for grinnell:25497.                   [success]
 file = grinnell_25510_MODS
pidnum=25510
Datastream replacement succeeded for grinnell:25510.                   [success]
 file = grinnell_3246_MODS
pidnum=3246
Datastream replacement succeeded for grinnell:3246.                    [success]
```

Note that some replacment operations clearly took longer than others, and in some cases they report back in the "wrong order", but it looks like all the legitimate object MODS records got updated.  It's also worth noting that after import each processed `.xml` file name is changed to `.xml.used` so that the file is not processed again unless its name is modified beforehand.  Now to check up on one or two of them...

## Test Results

Clearly, the changes I made to the three MODS `.xml` files are present in the repository.  However, they are NOT reflected in the objects' MODS display, presumably because _Digital.Grinnell_ uses a _Solr_ display of MODS data, and _Solr_ has not been re-indexed.

So, I elected to borrow this gem from my [blog post 046](https://dlad.summittdweller.com/en/posts/046-dg-fedora-a-portable-object-repository/):

```
docker exec -w /utility_scripts isle-fedora-ld ./updateSolrIndex.sh
docker exec -w /var/www/html/sites/default/ isle-apache-ld drush cc all
```

# Woot!

It works. However, it's worth noting that changes made to objects' `title` field were NOT reflect in the object titles, presumably because those come from each object's _Dublin Core_, or "DC" datastream.  In order to ensure that those get updated we have to run the system's prescibed _MODS-to-DC_ self-transform.  I have a _Drush_ command for that too, but that's a subject for another post.

And that's a wrap.  Until next time... :smile:
