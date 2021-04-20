This gadget adds a repository to the raspberry pi to allow centralized updating.

As far as I can tell, it uses the current recommended method for key distribution.

How to create a repository.
# get hold of aptly and necessary tools

sudo apt-get install aptly bzip2 gpgv2 graphvis wget xz-utils apt-utils dpkg-dev

# build jamulus .deb files

cd jamulus-latest/distributions
# edit changelog for correct version and .1 at end....
# e.g.
#
#
# jamulus (3.7.0~git-1) UNRELEASED; urgency=medium

./build-debian-package.sh

# creates the debian package files is jamulus-latest
# create repo

aptly repo create -comment="example jamulus" -component="jamulus-example" -distribution="buster" example-jamulus

# add built .deb files to the repo
#
aptly repo add example-jamulus ~/jamulus-build-dir/jamulus_3.7.0~git-1_armhf.deb
aptly repo add example-jamulus ~/jamulus-build-dir/jamulus-headless_3.7.0~git-1_armhf.deb

#
# Now we need some secret keys to ensure our build can't be tampered with.
#
#
sudo apt-get install gnupg2 gpgv
gpg --no-default-keyring --keyring jamulus-repo.gpg --fingerprint

tmpfile=`mktemp`
cat > $tmpfile << EOF
Key-Type: 1
Key-Length: 3072
Subkey-Type: 1
Subkey-Length: 3072
Name-Real: Root Superuser
Name-Email: root@somewhere.com
Expire-Date: 3y
Passphrase: SomeSecret
EOF
gpg --gen-key --batch --no-default-keyring --keyring jamulus-repo.gpg $tmpfile
pi@raspberrypi:~ $ gpg --no-default-keyring --list-keys --keyring jamulus-repo.gpg
gpg: checking the trustdb
gpg: public key of ultimately trusted key 8CCBFC2997C95743 not found
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   2  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 2u
gpg: next trustdb check due at 2024-04-15
/home/pi/.gnupg/jamulus-repo.gpg
--------------------------------
pub   rsa3072 2021-04-16 [SCEA] [expires: 2024-04-15]
      BA4129C43934874464F3BE4F9F55C2C8C13CAB6F
uid           [ultimate] Root Superuser <root@somewhere.com>
sub   rsa3072 2021-04-16 [SEA] [expires: 2024-04-15]
##########################################################
gpg --batch --no-default-keyring --keyring jamulus-repo.gpg --yes --export-secret-keys  | gpg1 --import --no-default-keyring --keyring jamulus-repo1.gpg --batch --yes



####################################
# Now we have keys we can publish a snapshot
aptly snapshot create example-jamulus-snapshot-3.7.0 from repo example-jamulus
#
# The --gpg-key is the last 8 characters of the public key we created above.
#  e.g.
# pub   rsa3072 2021-04-16 [SCEA] [expires: 2024-04-15]
#      BA4129C43934874464F3BE4F9F55C2 >>>C8C13CAB6F<<<
aptly publish --keyring jamulus-repo1.gpg --gpg-key C13CAB6F -distribution=stable snapshot jamulus-3.7.0

########################################
# For our images to understand the aptly site is trust worthy, we
# need to export the gpg key we used to
# 03-jamulus/files/repo.gpg
gpg --no-default-keyring --keyring jamulus-repo.gpg --export --output 03-jamulus/files/repo.gpg