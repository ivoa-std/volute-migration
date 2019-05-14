Convert a document from Volute (Subversion) to Github
=====================================================

While Volute has a hierarchical structure (WG/Document), Github
provides no further hierarchy. Therefore, each document will go into a
separate repository directly under the ivoa-std organization.


1. Get the conversion script
----------------------------

::

    $ wget https://raw.githubusercontent.com/ivoa-std/volute-migration/master/convert.sh

2. Convert the repository structure to git
------------------------------------------

::

   $ ./convert.sh dal/ADQL

This will create a subdirectory `ADQL` containing the git repository
for the document from volute. Only the trunk is converted; branches
and tags are left out. The commit authors are converted with the file
`volute-users.txt.in` (slightly scrambled to confuse email scrapers).

I would then recommend to create tags for the versions (WD, PR, REC)
of the standard, in the syntax::

    v<version>_<status><release>
    v2.1_pr1

These can be converted into github "Releases" which allow add PDF,
HTML and other files, making it easier to have everything
well-structured in one place.


3. Create a github repository and push
--------------------------------------

Now create a repository on https://github.com/ivoa-std/. This requires
that you are in the ivoa-std organization. Then push the converted
directory (the example uses ADQL as repository)::

    $ cd ADQL
    $ git remote add origin git@github.com:ivoa-std/ADQL
    $ git push --set-upstream origin master --tags


4. Remove the document from volute
----------------------------------

To avoid confusion which repository to use for further development, it
is strongly recommended to replace the document directory on volute
with a README documenting that the repository was moved to github.
