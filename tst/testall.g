#
# C2MonomialGroup: Implementation of the C2-monomialgroup in GAP
#
# This file runs package tests. It is also referenced in the package
# metadata in PackageInfo.g.
#
LoadPackage( "C2MonomialGroup" );

TestDirectory(DirectoriesPackageLibrary( "C2MonomialGroup", "tst" ),
  rec(exitGAP := true));

FORCE_QUIT_GAP(1); # if we ever get here, there was an error
