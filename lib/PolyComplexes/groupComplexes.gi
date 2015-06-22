####################################################
####################################################
InstallGlobalFunction(QuillenComplex,
function(G,p)
local
	SubsCl, Subs, fn, cl, MaxSubs, bool, MaxSimps, K, lessthan, k,
        s,t,x,m,mm,tmp;

######################################
if not IsPrimeInt(p) then 
Print("Second variable is not a prime.\n");
return fail;
fi;
######################################

SubsCl:=ConjugacyClassesSubgroups(LatticeByCyclicExtension(G, 
      IsElementaryAbelian, true));;

#SubsCl:=Filtered(SubsCl,cl-> IsPGroup(ClassElementLattice(cl,1)));
SubsCl:=Filtered(SubsCl,cl->
        PrimePGroup(ClassElementLattice(cl,1))=p);

SubsCl:=Filtered(SubsCl,cl->Order(ClassElementLattice(cl,1))>1);
Subs:=[];
for cl in SubsCl do
for x in [1..Size(cl)] do
Add(Subs,ClassElementLattice(cl,x));
od;
od;

Unbind(SubsCl);

###################
fn:=function(A,B);
return Order(A)>=Order(B);
end;
###################

Sort(Subs,fn);

MaxSimps:=[];
for s in Subs do
bool:=true;
for t in MaxSimps do
if IsSubgroup(t,s) then bool:=false; break; fi;
od;
if bool then Add(MaxSimps,s); fi;
od;

Unbind(Subs);
MaxSimps:=List(MaxSimps,s->[s]);

bool:=true;

while bool do
bool:=false;

for x in [1..Length(MaxSimps)] do
if IsBound(MaxSimps[x]) then

m:=MaxSimps[x];
if Order(m[Length(m)])>p then 
for t in MaximalSubgroups(m[Length(m)]) do
mm:=Concatenation(m,[t]);
Add(MaxSimps,mm); if Order(t)>p then bool:=true; fi;
Unbind(MaxSimps[x]);
od;
fi;

fi;
od;
od;

tmp:=MaxSimps;
MaxSimps:=[];
for m in tmp do
Add(MaxSimps,m);
od;
Unbind(tmp);
K:= MaximalSimplicesToSimplicialComplex(MaxSimps);

return K;

end);
####################################################
####################################################

######################################################
######################################################
InstallGlobalFunction(GChainComplex,
function(K,G)
local Ksimps,R, orbits, stabilizers, stabfn, Dim, lessthan, boundfn,
elts, i, k, x, m,Action ,ontuples;

elts:=Elements(G);
Ksimps:=[];
for k in [1..1+Dimension(K)] do
Ksimps[k]:=List(K!.simplicesLst[k],x->StructuralCopy(x));
od;

#############################
Action:=function(a,b,c) return 1; end;
#############################

#############################
ontuples:=function(x,g)
local g1;
g1:=g^-1;
return OnTuples(x,g1);
end;
#############################

lessthan:=function(a,b) return Order(a)<Order(b); end;
for k in [1..Dimension(K)+1] do
for x in Ksimps[k] do
Sort(x,lessthan);
od;
od;

orbits:=[];
for k in [1..1+Dimension(K)] do
orbits[k]:=OrbitsDomain(G,Ksimps[k], ontuples);
od;

stabilizers:=[];
for k in [1..1+Dimension(K)] do
stabilizers[k]:=[];
for i in [1..Length(orbits[k])] do
stabilizers[k][i]:=Stabilizer(G,orbits[k][i][1],ontuples);
od;od;

######################
Dim:=function(k);
if k<0 or k>Dimension(K) then return 0; fi;
return Length(orbits[k+1]);
end;
######################

######################
stabfn:=function(k,i);
return stabilizers[k+1][i];
end;
######################

######################
boundfn:=function(n,i)
local V,Vhat, ii, j, m,bnd,g,ob;

if n<=0 then return []; fi;

V:=orbits[n+1][i][1];
V:=SSortedList(V);

bnd:=[];

for j in [1..Length(V)] do
Vhat:=StructuralCopy(V);
RemoveSet(Vhat,V[j]);
m:=K!.enumeratedSimplex(Vhat);
m:=Ksimps[n][m];
for ii in [1..Length(orbits[n])] do
if m in orbits[n][ii] then ob:=ii; break; fi;
od;
for g in [1..Length(elts)] do
if ontuples(orbits[n][ob][1],elts[g])=m then break; fi;
od;
if IsOddInt(j) then
Add(bnd,[ob,g]);
else
Add(bnd,[-ob,g]);
fi;
od;

return bnd;

end;
######################

R:=Objectify(HapGChainComplex,
            rec(
            dimension:=Dim,
            boundary:=boundfn,
            homotopy:=fail,
            elts:=Elements(G),
            group:=G,
            stabilizer:=stabfn,
            action:=Action,
            properties:=
            [["length",Dimension(K)],
             ["characteristic",0],
             ["type","chaincomplex"]]));

return R;
end);
######################################################
######################################################

