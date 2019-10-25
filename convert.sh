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
H4sIAPZyB10CA51WS27jOBDd5xQCtA4XvZ+FJ0gC9KITI2lkkh0pkJQ9mRJZlmhTRM4zB5mLTfGj
RHbbgN0rsV7VI6li/Z4kcLNjr3iD2um6H8F5ZsRY/VE9JVVVVFV4OmH6cQUelAUnWS/hnZg/ilw9
RzlAhGtrFOs9MDCs3RFHCq2ireTC2+o2SiGB9YBgr80G2AByBdIytG0h1AfwJRt00GinNBLnYVo+
ojGCuypMSmYyUotONSPbSOKJVvaomIdWItdEfy2rh6wh9r7J3DcnVRfuYwizTrB+QO9REvsxI9Vz
QYKZlLVxHA0wpz+uLKycpQ1537qeC07EZYTo8E8oHBrNDz6tu3wrsU43vx9QooJqmeSQ4FppZVx+
KSvHLcXMAOPeYW+g9YDrGFWkIt4Rs4+rTQxT4VSJ4P/+jesHwTlI9FWY1KwrUA1KS8FaTs8vIb14
jzJGjcdRJYc9J5kyIclhT12PDbKx6ZlFIrrWO4iMtOCiuofNJgVYXxCmM1I7Dpv0Qr3sOwQfWRK1
GZDHBXIkUvrOXUMRLV0Tj7iB1lc/o5gu1ZDIhiLWI/3kgBTPcsq3Qtxz6KVbILfE+kkf6Xb0dZwc
OsRPDdJFF16TZNF3KLND6KFXyNbiH+5gl7gkV9+LHPbU80c8obhgh63FsVEYy9ELjJRcyyKHbRRZ
UddGOXp9aCNDrR3vgO8f+CIGXt0VTRU+bRrpuEEteH6YLao2xtxL+t6B78GKKiSRFbGmZxSNYhT7
zHF6+q2TLnLiZwF2JSQnxwY+LdnWzf9pJx12sX79RU+kHa9ukxwyXoNrktP96Ojl/KzAvGUglLrC
ssGRyPeUtI414IQUkR9FCpMkhrlyfq3j+Nn0kXWUFO9eyLqL/yV8DriU8XJHKRR1VThlRzvAVkhG
IMRsfUjft4gR6Uu1dyZII9iI1C4OSgzh1VvEI/eIUeLuGGVsa6jyNNOVDnY579p6cNgyRTHsvAed
a1zEqrtPLPxiNutNY6cvOM86ren2E+ORirDT1DHE9bJowmRT/9I+T2l+c7cUgchUahREii+XwxQp
ez7BUDD2hdUUsKvrUXDdfMtOoMnDi/ZdpS0kkhVWrwkIY5GzwZGIH3nr/Yiu/Abl7iIDsTNNylPl
bRSeynhKlRI5EzAFT5G/qv2oqPL4+XnLJGueDizaUwdy7ER88R8WqkVaB7DAEnzk57gzgmYxIizK
6k1IilwqMVmmC0Z5FlFcSKr87O9pllskuUxyWVkOmg1ze6S9VDiLLshZsTQ5Hj35Zwyd1yKGmW6e
hEfhc8kNTRw0JjED1qQ2qKWjSXeZUOqDM/Up2kEfPW8DMhpiBjRsDT1Po9Bt5H3PUpAZrpvhXTka
l1ujSrrIhiYqjTU31Dpa15qSebfk1pukIvYxm48r5cEin7r9XZZoUHZ16vdZzYTsyXTqcmd3vTLM
XDjxaCs4eJuHq3ty4fJTDl+6+dizEt8UdpdH1kr4llzSX69E/MXfS7p3qlubYZp3MeYQFVaaP0dZ
S4HTWZPZ4YB8kvA/bJ9Og3wNAAA=
EOF
fi

# Github target user or organization. You need write access there.
GITHUB_USER=ivoa-std

# We use the last part of the project path as github repository name,
# since github does not do hierarchical repositories
REPO=$(echo $1 | sed s:.*/::)

git svn clone ${SVNBASE}/${PROJECT} --authors-file=${AUTHORSFILE} --no-metadata

cd ${REPO}

curl https://creativecommons.org/licenses/by-sa/4.0/legalcode.txt > LICENSE
git add LICENSE
git commit -m "Include CC-BY-SA-4.0 license"

cat <<EOF
Now create a repository ${REPO} on https://github.com/${GITHUB_USER}/. 
Then, push the converted directory:

    cd ${REPO}
    git remote add origin git@github.com:${GITHUB_USER}/${REPO}
    git push --set-upstream origin master


EOF
