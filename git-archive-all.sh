#!/usr/bin/env sh

# Description: Utility script for creating MDD releases.
#              The script builds archive files (tar.gz and zip) for the MDD
#              repository *including* submodules in the current path.
MDDVERSION="2.1.1"
MDDVERSIONV="v2_1_1"

# Below there should be no need for changes
MDDPREFIX="Modelica_DeviceDrivers $MDDVERSION"
MDDARCHIVE_TAR="Modelica_DeviceDrivers_$MDDVERSIONV.tar"
MDDARCHIVE_ZIP="Modelica_DeviceDrivers_$MDDVERSIONV.zip"

git archive -o $MDDARCHIVE_TAR --prefix="$MDDPREFIX/" HEAD:Modelica_DeviceDrivers/
cd Modelica_DeviceDrivers/Resources/thirdParty/googletest/
git archive -o googletest.tar --prefix="$MDDPREFIX/Resources/thirdParty/googletest/"  HEAD
cd ../../../..
mv Modelica_DeviceDrivers/Resources/thirdParty/googletest/googletest.tar .
tar --concatenate --file=$MDDARCHIVE_TAR googletest.tar
mkdir tmp_archive
tar -C tmp_archive -xf "$MDDARCHIVE_TAR"
cd tmp_archive
zip -9 -r $MDDARCHIVE_ZIP "$MDDPREFIX/"
mv $MDDARCHIVE_ZIP ..
cd ..
gzip -9 -v $MDDARCHIVE_TAR

rm googletest.tar
rm -r tmp_archive
