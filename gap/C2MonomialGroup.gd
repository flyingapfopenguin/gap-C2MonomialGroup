#
# C2MonomialGroup: Implementation of the C2-monomialgroup in GAP
#
#! @Chapter Introduction
#!
#! C2MonomialGroup is a package which does some
#! interesting and cool things
#!
#! @Chapter Functionality
#!
#!
#! @Section Example Methods
#!
#! This section will describe the example
#! methods of C2MonomialGroup

#! @Description
#!   Insert documentation for your function here

DeclareCategory("IsC2MonomialGroup", IsGroup and IsFinite);
DeclareOperation("C2MonomialGroup", [ IsCyclotomic ]);

DeclareCategory("IsC2MonomialPerm", IsAssociativeElement and IsMultiplicativeElementWithInverse and CanEasilyCompareElements);
DeclareCategoryCollections("IsC2MonomialPerm");
InstallTrueMethod(IsGeneratorsOfMagmaWithInverses, IsC2MonomialPermCollection);
DeclareRepresentation("IsC2MonomialPermRep", IsComponentObjectRep, ["mapping"]);
DeclareOperation("C2MonomialPermNC", [ IsDenseList, IsFamily ]);
DeclareOperation("C2MonomialPerm", [ IsDenseList, IsFamily ]);
DeclareOperation("C2MonomialPerm", [ IsDenseList, IsC2MonomialGroup ]);
DeclareOperation("C2MonomialPerm", [ IsDenseList, IsC2MonomialPerm ]);
