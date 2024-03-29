#
# C2MonomialGroup: Implementation of the C2-monomialgroup in GAP
#
# Implementations
#

#########################
### CONSTRUCTORS
#########################

InstallMethod(C2MonomialGroup,
	"for a positive integer",
	[ IsCyclotomic ],
	function(n)
		local fam, G;
		if not IsPosInt(n) then
			Error(" n is not a positive Integer. ");
		fi;
		fam:=CollectionsFamily(NewFamily(Concatenation("Family C2MonomialGroup on [", String(-n), ",...,", String(n), "]\\[0]"), IsC2MonomialPerm));
		fam!.n:=n;
		G:=Objectify(NewType(fam, IsC2MonomialGroup and IsAttributeStoringRep), rec());
		Assert(0, G <> fail);
		SetIsWholeFamily(G, true);
		SetName(G, Concatenation("C2MonomialGroup on [", String(-n), ",...,", String(n), "]\\[0]"));
		SetIsAbelian(G, n=1);
		return G;
	end
);

InstallMethod(C2MonomialPermNC,
	"for a dense list and an object in `IsFamily'",
	[ IsDenseList, IsFamily ],
	function(map, fam)
		return Objectify( NewType(ElementsFamily(fam), IsC2MonomialPerm and IsC2MonomialPermRep),
			rec(mapping:=map));
	end
);

InstallMethod(C2MonomialPerm,
	"for a dense list and an object in `IsFamily'",
	[ IsDenseList, IsFamily ],
	function(map, fam)
		Assert(0, IsDenseList(map));
		Assert(0, Length(map) = fam!.n);
		Assert(0, AsSet(List(map, AbsInt)) = [1..(fam!.n)]);
		return C2MonomialPermNC(map, fam);
	end
);

InstallMethod(C2MonomialPerm,
	"for a dense list and an object in `IsC2MonomialGroup'",
	[ IsDenseList, IsC2MonomialGroup ],
	function(map, G)
		return C2MonomialPerm(map, FamilyObj(G));
	end
);

InstallMethod(C2MonomialPerm,
	"for a dense list and an object in `IsC2MonomialPerm'",
	[ IsDenseList, IsC2MonomialPerm ],
	function(map, p)
		return C2MonomialPerm(map, CollectionsFamily(FamilyObj(p)));
	end
);

#########################
### Print functions
#########################

InstallMethod(PrintObj,
	"for object in `IsC2MonomialPerm'",
	[IsC2MonomialPerm and IsC2MonomialPermRep],
	function(p)
		local n, indices;
		n := CollectionsFamily(FamilyObj(p))!.n;
		indices := Difference([-n..n], [0]);
		Print(List(indices, i -> Concatenation(String(i), " -> ", String(i^p))));
	end
);

InstallMethod(ViewObj,
	"for object in `IsC2MonomialPerm'",
	[IsC2MonomialPerm and IsC2MonomialPermRep],
	function(p)
		Print(p!.mapping);
	end
);

#########################
### One as NE
#########################

InstallMethod(OneImmutable,
	"for an object in `IsC2MonomialGroup'",
	[IsC2MonomialGroup],
	function(G)
		local fam;
		fam := FamilyObj(G);
		return C2MonomialPerm([1..(fam!.n)], fam);
	end
);

InstallMethod(OneImmutable,
	"for an object in `IsC2MonomialPerm'",
	[IsC2MonomialPerm],
	function(p)
		local fam;
		fam := CollectionsFamily(FamilyObj(p));
		return C2MonomialPerm([1..(fam!.n)], fam);
	end
);

# TODO comment
InstallMethod(OneMutable,
	"for an object in `IsC2MonomialPerm'",
	[IsC2MonomialPerm],
	function(p)
		return OneImmutable(p);
	end
);

InstallMethod(IsOne,
	"for an object in `IsC2MonomialPerm'",
	[IsC2MonomialPerm],
	function(p)
		return p = One(p);
	end
);

#########################
### Operators on Perms
#########################

InstallMethod(\=,
	"for object in `IsC2MonomialPerm'",
	IsIdenticalObj,
	[IsC2MonomialPerm and IsC2MonomialPermRep, IsC2MonomialPerm and IsC2MonomialPermRep],
	function(p, q)
		return p!.mapping = q!.mapping;
	end
);

InstallMethod(\<,
	"for object in `IsC2MonomialPerm'",
	IsIdenticalObj,
	[IsC2MonomialPerm and IsC2MonomialPermRep, IsC2MonomialPerm and IsC2MonomialPermRep],
	function(p, q)
		local i;
		for i in [1..Length(p!.mapping)] do
			if p!.mapping[i] = q!.mapping[i] then
				continue;
			fi;
			return p!.mapping[i] < q!.mapping[i];
		od;
		return false;
	end
);

InstallMethod(\^,
	"for an index and an object in `IsC2MonomialPerm'",
	[IsInt, IsC2MonomialPerm and IsC2MonomialPermRep],
	function(index, p)
		local n;
		n := CollectionsFamily(FamilyObj(p))!.n;
		if (index = 0) or (AbsInt(index) > n) then
			Error(" index out of range ");
		fi;
		return SignInt(index)*p!.mapping[AbsInt(index)];
	end
);

InstallMethod(\/,
	"for an index and an object in `IsC2MonomialPerm'",
	[IsInt, IsC2MonomialPerm and IsC2MonomialPermRep],
	function(value, p)
		local n, index;
		n := CollectionsFamily(FamilyObj(p))!.n;
		if (value = 0) or (AbsInt(value) > n) then
			Error(" value out of range ");
		fi;
		index := Position(p!.mapping, value);
		if index <> fail then
			return index;
		fi;
		index := Position(p!.mapping, -value);
		Assert(0, index <> fail);
		return -index;
	end
);

InstallMethod(\*,
	"for two objects in `IsC2MonomialPerm'",
	IsIdenticalObj,
	[IsC2MonomialPerm and IsC2MonomialPermRep, IsC2MonomialPerm and IsC2MonomialPermRep],
	function(p, q)
		local fam;
		fam := CollectionsFamily(FamilyObj(p));
		return C2MonomialPerm(List( [1..(fam!.n)], i -> (i^q)^p), fam);
	end
);

InstallMethod(InverseOp,
	"for an object in `IsC2MonomialPerm'",
	[IsC2MonomialPerm and IsC2MonomialPermRep],
	function(p)
		local fam;
		fam := CollectionsFamily(FamilyObj(p));
		return C2MonomialPerm(List( [1..(fam!.n)], i -> i/p), fam);
	end
);

#########################
### Info about Group
#########################

InstallMethod(GeneratorsOfGroup,
	"for an object in `IsC2MonomialGroup'",
	[IsC2MonomialGroup],
	function(G)
		local fam, n, res;
		fam := FamilyObj(G);
		n := fam!.n;
		res := [];
		if n > 1 then
			Append(res, [C2MonomialPerm(Concatenation([2,1],[3..n]), fam)]);
			if n > 2 then
				Append(res, [C2MonomialPerm(Concatenation([2..n],[1]), fam)]);
			fi;
		fi;
		Append(res, [C2MonomialPerm(Concatenation([-1],[2..n]), fam)]);
		return res;
	end
);

InstallMethod(Size,
	"for an object in `IsC2MonomialGroup'",
	[IsC2MonomialGroup],
	function(G)
		local n;
		n := FamilyObj(G)!.n;
		return 2^n * Factorial(n);
	end
);
