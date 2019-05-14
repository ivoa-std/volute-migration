#!/bin/sh

# Migrate a Volute document repository to github
#
# Call with wg/project as argument, e.g. dal/ADQL
#
# Requirements:
#   - git
#   - git-svn
#

set -e

#PROJECT=dal/ADQL
#PROJECT=ivoapub/ivoatex
PROJECT=$1

# Subversion base URL (volute), to be completed with the project
SVNBASE=https://volute.g-vo.org/svn/trunk/projects

# List <author> = <email> to match svn users to email addresses
AUTHORSFILE=volute-users.txt
# File is scrambled a bit (rot13, gzip, base64)
if [ ! -e ${AUTHORSFILE} ] ; then
    (base64 -d | gzip -d | tr 'A-Za-z@#<>{}' 'N-ZA-Mn-za-m#@{}<>') > ${AUTHORSFILE} <<EOF
H4sIAEO841wCA51WTW/jOAy991cY8Dk6zH0PnaItMIdpg3bQbW+SIcnJdGmJsZXIQv/7Uh9unUwC
JHOy3iOfJEskxScJ3OzYK96gdrruR3CeGTFW/1RPyVQVUxWeTrh+XIEHZcFJ1kt4J+XPgqvniANE
urZGsd4DA8PaHWmk0Cr6Si68rW4jComsBwS7MBtgA8gVSMvQtkVQH9CXTNBBo53SSJqHafiIxgju
qjAZmclMLTrVjGwjSSda2aNiHlqJXJP8tYwesoXU+y7zszlpunAeQ5x1gvUDeo+S1I+ZqZ4LE8xk
rI3jaIA5/XFlYeUsTcj71vVccBIuI0WLf1Lh0Gm+8Gnb5VOJddr5/YASFVTLhEOia6WVcfmmrBy3
FDMDjHuLvYHWA65jVJGJdEfcPq42MUyFU1MEx+F3MyjkHTra4GSvQWkpWLugD6iuT3fdo4zx4nFU
6aieE6YcSDjsmeuxQTY2PbNIQtd6B1GRBlxU97DZpNDqC8N0ZmrHYZPuppd9h+CjSqI2A/I4QI4k
St/5oVAsS9fEJW6g9dWvCNOmGoJsKLAe6e8GpEiWU6YV4d5RXjoFckuqX/SRbkdfx30VhvipQTrW
crcgZNF3KPOB0BWvkK3Ff9zBLmkJVz8KDnvm+fWdMFwww9bi2CiMhegFRkqrZcFhGyEr5tooR/cP
bVSoteMd8P0FX8TAq7tiqcKnTyMdN6gFzxezRdXGaHtJ3zvwPVhRhQRZgTVdo2gUo6hnjtPVb510
URM/12BXQnI62MCnIdu6+T/tpMMuVq5/6Yo0hfFtwiHzNbgmHbofHd2cn5WWt0yEUlFYdphin7sY
/CnyPaWrYw04IUXUR0hhkmCYG+fbOs6fLR9ZR0nx7oWsu/hfwueAS7kud5RC0VaFU340A2yFZERC
zNaH9H2LHIm+THtrgjSCjUgPxUFxIb56i3zUHnFK2h2jjG0N1Zxm2tLBLOdtWw8OW6Yohp33oHN1
i1x198mFP9xmr9LY6QvWs05r2v2keKTy6zS9FWKxLJYw+dR/PJynLH85W4pAZCo9ESSKN5fDFCl7
PslQOPbF1RSwq8UouG6+5UOgnsOL9l2lKSSSF1aviQhjwdnhSMSPvPV+RFd+g3L3OhPxTZqMp8rb
KDyV8ZQqJXImYgqegr+q/aio8vj5esuENU8LFuupBTl2It74TwvVdRoHsMASfeTnuDOCujASXJfR
m5AUuVRiMqYNRjyLKC4kVX72e+rirhMuPVw2loVmbdyeaC8VzpILOqxYmhyPJ/k9hs5rgWFmmyfh
UfpccUO9BjVIzIA16RnU0lGPu0wsvYMz8ynZwTt63gTkNMQMaNgaep6aoNuo+5FRkJmum+FdOWqU
W6NKusiGeimNNTf0dLSuNSXzbulYb5KJ1Md8Pq6UB4t8eu3vMqIW2dXpvc9mJmRPrtMrd/arV5qZ
CzsebQUHb3NzdU9HuPzE4cs2b3tW4pvC7vLIWgnf0pH0i5WIv/h3SfdOdWszTJ0uxhyiwkqd5yhr
KXBaa3I7bI1PCv4HzHYSC3YNAAA=
EOF
fi

# Github target user or organization. You need write access there.
GITHUB_USER=ivoa-std

# We use the last part of the project path as github repository name,
# since github does not do hierarchical repositories
REPO=$(echo $1 | sed s:.*/::)

git svn clone ${SVNBASE}/${PROJECT} --authors-file=${AUTHORSFILE} --no-metadata

cd ${REPO}

cat <<EOF
Now create a repository ${REPO} on https://github.com/${GITHUB_USER}/. 
Then, push the converted directory:

    cd ${REPO}
    git remote add origin git@github.com:${GITHUB_USER}/${REPO}
    git push --set-upstream origin master


EOF
