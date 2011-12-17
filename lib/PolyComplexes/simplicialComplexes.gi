#####################################################################
#####################################################################
InstallOtherMethod(Dimension,
"Dimension of  simplicial complex",
[IsHapSimplicialComplex],
function(f) return EvaluateProperty(f,"dimension");
#function(f) local i;
#for i in [1..EvaluateProperty(f,"dimension")] do
#if f!.nrSimplices=0 then return i; break; fi;
#od;
return EvaluateProperty(f,"dimension");
end);
#####################################################################
#####################################################################

#####################################################################
#####################################################################
InstallOtherMethod(EulerCharacteristic,
"Euler characteristic  of a simplicial complex",
[IsHapSimplicialComplex],
function(M);
return
Sum(List([0..Dimension(M)],i->((-1)^i)*M!.nrSimplices(i)));
end);
#####################################################################
#####################################################################

#####################################################################
#####################################################################
InstallOtherMethod(Homology,
"Integral homologies  of a simplicial complex",
[IsHapSimplicialComplex],
function(M);
return
List([0..Dimension(M)],n->Homology(ChainComplex(M),n));
end);
#####################################################################
#####################################################################

#####################################################################
#####################################################################
InstallOtherMethod(Homology,
"Integral homologies  of a simplicial complex",
[IsHapSimplicialComplex,IsInt],
#function(M,n) ;
#return
#Homology(ChainComplex(M),n);
function(M,n) local P, PM, i, answer,C,A;
P:=PathComponentsOfGraph(GraphOfSimplicialComplex(M),0);
if n=0 then return P;fi;
answer:=[];
for i in [1..P] do
PM:=PathComponentsOfSimplicialComplex(M,i);
PM:=SkeletonOfSimplicialComplex(PM,n+1);
A:=ContractibleSubcomplexOfSimplicialComplex(PM);;
C:=ChainComplexOfSimplicialPair(PM,A);
answer:=Concatenation(answer,Homology(C,n));
od;
return answer;
end);
#####################################################################
#####################################################################

#####################################################################
#####################################################################
InstallOtherMethod(Homology,
"Integral homologies  of a simplicial complex",
[IsHapSimplicialComplex,IsInt,IsInt],
function(M,n,p) local P, PM, i, answer,C,A;
P:=PathComponentsOfGraph(GraphOfSimplicialComplex(M),0);
if n=0 then return P;fi;
answer:=0;
for i in [1..P] do
PM:=PathComponentsOfSimplicialComplex(M,i);
PM:=SkeletonOfSimplicialComplex(PM,n+1);
A:=ContractibleSubcomplexOfSimplicialComplex(PM);;
C:=ChainComplexOfSimplicialPair(PM,A);
answer:=answer+Homology(TensorWithIntegersModP(C,p),n);
od;
return answer;
end);
#####################################################################
#####################################################################



#####################################################################
#####################################################################
InstallOtherMethod(Bettinumbers,
"Integral homologies  of a simplicial complex",
[IsHapSimplicialComplex],
function(M)
local H;
H:=Homology(M);
return List(H,x->Length(Filtered(x,a->a=0)));
end);
#####################################################################
#####################################################################


#####################################################################
#####################################################################
#InstallOtherMethod(Homology,
#"Homology  of a simplicial complex",
#[IsHapSimplicialComplex,IsInt],
#function(M,n);
#return
#Homology(ChainComplex(M),n);
#end);
#####################################################################
#####################################################################



#####################################################################
#####################################################################
InstallOtherMethod(ChainComplex,
"Cellular chain complex of a simplicial complex",
[IsHapSimplicialComplex],
function(M)
return ChainComplexOfSimplicialComplex(M);;
end);
#####################################################################
#####################################################################

#####################################################################
#####################################################################
InstallGlobalFunction(ChainComplexOfSimplicialComplex,
function(M)
local
        Dimsn,Boundary,nullvecs,i;

#############################
Dimsn:=function(n);
return M!.nrSimplices(n);
end;
#############################

nullvecs:=[];
for i in [0..Dimension(M)] do
nullvecs[i+1]:=List([1..M!.nrSimplices(i)],a->0);
od;

#############################
Boundary:=function(n,i)
local V,Vhat, j, bnd;
V:=M!.simplices(n,i);

#bnd:=List([1..M!.nrSimplices(n-1)],a->0);
bnd:=StructuralCopy(nullvecs[n]);

for j in [1..Length(V)] do
Vhat:=StructuralCopy(V);
RemoveSet(Vhat,V[j]);
if IsOddInt(j) then
bnd[M!.enumeratedSimplex(Vhat)]:=1;
else
bnd[M!.enumeratedSimplex(Vhat)]:=-1;
fi;
od;

return bnd;
end;
#############################


return
Objectify(HapChainComplex,
           rec(
           dimension:=Dimsn,
           boundary:=Boundary,
           properties:=[
           ["length",EvaluateProperty(M,"dimension")],
           ["type","chainComplex"],
           ["characteristic",0]]
           ));

end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(SimplicesToSimplicialComplex,
function(L)
local
        Vertices,
        NrSimplices,
        SimplicesLst,
        Simplices,
        EnumeratedSimplex,
        dim,
        n,v,x;

dim:=PositionProperty(L,x->Size(x)=0);
if dim=fail then dim:=Length(L)-1; else dim:=dim-2; fi;
if Length(L)>0 then
Vertices:=Concatenation(L[1]);
else Vertices:=[];
fi;
Vertices:=SSortedList(Vertices);
SimplicesLst:=L;

#####################
NrSimplices:=function(n);
if n<0 or n>dim then return 0; fi;
return Length(SimplicesLst[n+1]);
end;
#####################

#####################
Simplices:=function(n,i);
return SimplicesLst[n+1][i];
end;
#####################


#####################
EnumeratedSimplex:=function(v);
return Position(SimplicesLst[Length(v)],v);
end;
#####################


return
Objectify(HapSimplicialComplex,
           rec(
           vertices:=Vertices,
           nrSimplices:=NrSimplices,
           simplices:=Simplices,
           simplicesLst:=SimplicesLst,
           enumeratedSimplex:=EnumeratedSimplex,
           properties:=[
           ["dimension",dim]]
           ));

end);
#################################################################
#################################################################



#################################################################
#################################################################
InstallGlobalFunction(MaximalSimplicesToSimplicialComplex,
function(V)
local
	Vertices,
        NrSimplices,
	SimplicesLst,
	Simplices,
	EnumeratedSimplex,
	dim,
	n,v,x;

dim:=Maximum(List(V,v->Length(v)))-1;
Vertices:=Concatenation(V);
Vertices:=SSortedList(Vertices);
SimplicesLst:=List([1..dim+100],i->[]); #SLOPPY!!!
SimplicesLst[1]:=List(Vertices,x->[x]);

for v in V do
for n in [1..Length(v)] do
for x in Combinations(v,n) do
AddSet(SimplicesLst[n],x);
od;
od;
od;

return SimplicesToSimplicialComplex(SimplicesLst);

end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(SkeletonOfSimplicialComplex,
function(S,k)
local
	T,p,prp;
T:=Objectify(HapSimplicialComplex, rec());
T!.vertices:=StructuralCopy(S!.vertices);
T!.nrSimplices:=StructuralCopy(S!.nrSimplices);
T!.simplices:=StructuralCopy(S!.simplices);
if IsBound(S!.simplicesLst) then
T!.simplicesLst:=StructuralCopy(S!.simplicesLst);
fi;
T!.enumeratedSimplex:=StructuralCopy(S!.enumeratedSimplex);
prp:=StructuralCopy(S!.properties);
p:=PositionProperty(prp,x->"dimension" in x);
prp[p][2]:=k;
T!.properties:=prp;

return T;
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(SimplicialMapNC,
function(K,L,F)
local
        M,SimpF;
#Assume K, L to be simplicial complexes and F to
#be a mapping of vertex sets. SimpF will be the
#mapping on simplexes.

###################################
SimpF:=function(s);
return List(s,F);
end;
###################################

M:=Objectify(HapSimplicialMap, rec());
M!.source:=K;
M!.target:=L;
M!.mapping:=SimpF;
M!.properties:=[];

return M;
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(SimplicialMap,
function(K,L,F)
local
        M,Lsimps,s,d,dim,l,Fs;

Lsimps:=[];
for d in [0..Dimension(K)] do
Lsimps[d+1]:=List([1..L!.nrSimplices(d)],i->SSortedList(L!.simplices(d,i)));
Lsimps[d+1]:=SSortedList(Lsimps[d+1]);
od;

for d in [0..Dimension(K)] do
for s in [1..K!.nrSimplices(d)] do
Fs:=List(K!.simplices(d,s),F);
Fs:=SSortedList(Fs);
if not Fs in Lsimps[Length(Fs)] then return fail; fi;
od;
od;

return SimplicialMapNC(K,L,F);
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(ChainMapOfSimplicialMap,
function(F)
	local K,L,Lsimps,zeros,CK,CL, map, d;

K:=Source(F);;
L:=Target(F);;
CK:=ChainComplex(K);
CL:=ChainComplex(L);


Lsimps:=[];
zeros:=[];
for d in [0..Dimension(L)] do
Lsimps[d+1]:=List([1..L!.nrSimplices(d)],i->SSortedList(L!.simplices(d,i)));
Lsimps[d+1]:=SSortedList(Lsimps[d+1]);
zeros[d+1]:=[1..L!.nrSimplices(d)]*0;
od;


###########################
map:=function(v,d)
local i,z,s;

z:=StructuralCopy(zeros[d+1]);

for i in [1..Length(v)] do
if not v[i]=0 then 
s:=SSortedList( F!.mapping( K!.simplices(d,i) ));
s:=Position(Lsimps[d+1],s);
z[s]:=z[s]+v[i];
fi;
od;

return z;
end;
###########################

return
Objectify(HapChainMap,
           rec(
           source:=CK,
           target:=CL,
           mapping:=map,
           properties:=[
           ["type","chainMap"],
           ["characteristic",0]]
           ));


end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(MaximalSimplicesOfSimplicialComplex,
function(K)
local
	MaxSimps, Simps, genSimps,dim,s,x,i;

dim:=EvaluateProperty(K,"dimension");
Simps:=List([1..K!.nrSimplices(dim)],i->K!.simplices(dim,i));
MaxSimps:=Simps;

while dim>0 do
dim:=dim-1;
   genSimps:=[];
   for s in Simps do
   for x in s do
   Add(genSimps,SSortedList(Filtered(s,i->not i=x)));
   od;
   od;
Simps:=genSimps;
   for i in [1..K!.nrSimplices(dim)] do
   if not K!.simplices(dim,i) in genSimps then 
      Add(Simps,K!.simplices(dim,i));
      Add(MaxSimps,K!.simplices(dim,i)); 
   fi;
   od;
od;

return MaxSimps;
end);
#################################################################
#################################################################


#################################################################
#################################################################
InstallGlobalFunction(ContractSimplicialComplex,
function(K)
local RemoveApex,RemoveEdge,Vertices,G,A,LA,Faces,bool,dim,PC,iter,row,x,i,j,k;

G:=GraphOfSimplicialComplex(K);
Faces:=K!.simplicesLst;
dim:=PositionProperty(Faces,x->Size(x)=0);
if IsInt(dim) then dim:=dim-1; else dim:=Dimension(K); fi;
A:=G!.incidenceMatrix;
PC:=PathComponentsOfGraph(G,0);
bool:=List(Faces,Length);;
Vertices:=StructuralCopy(K!.vertices);

################################################
##
RemoveApex:=function(i)
local x, y, cols, lc,D;

cols:=[];
for x in LA do
if not A[i][x]=0 then Add(cols,x); fi;
od;

if Length(cols)=0 or Length(cols)>dim then  return false; fi;

cols:=K!.vertices{cols};
AddSet(cols,K!.vertices[i]);
if not cols in Faces[Length(cols)] then return false; fi;

for x in LA do
A[i][x]:=0;
A[x][i]:=0;
od;

for x in [1..dim] do #####?
Faces[x]:=Filtered(Faces[x], a->not K!.vertices[i] in a);
od;

RemoveSet(Vertices,K!.vertices[i]);

return true;
end;
##
################################################

################################################
##
RemoveEdge:=function(i,j)
local cols, x, y,lc;


cols:=[];
for x in LA do
if (not A[i][x]=0) and (not A[j][x]=0) then Add(cols,x); fi;
od;

if Length(cols)=0  or Length(cols)>dim-2 then return false; fi;

cols:=K!.vertices{cols};
AddSet(cols,K!.vertices[i]);
AddSet(cols,K!.vertices[j]);
if not IsBound(Faces[Length(cols)]) then return false; fi;
if not cols in Faces[Length(cols)] then return false; fi;

A[i][j]:=0;
A[j][i]:=0;

for x in [2..dim+1] do #####?
Faces[x]:=Filtered(Faces[x], a->
not SSortedList([K!.vertices[i], K!.vertices[j]]) in a);
od;


return true;
end;
##
################################################


LA:=Filtered([1..Length(A)], i->Sum(A[i])>0);
iter:=Filtered(LA,i->Sum(A[i])<dim+1);

x:=true;
while x do
x:=false;
   for i in iter do
   if RemoveApex(i) then x:=true; fi;
   od;
od;

#K!.vertices:=Vertices;
#if bool=Sum(Sum(A)) then return false; fi;;;
#return true;

LA:=Filtered([1..Length(A)], i->Sum(A[i])>0);
   for i in [1..Length(LA)] do
   for j in [i+1..Length(LA)] do
   if RemoveEdge(LA[i],LA[j]) then x:=true;  fi;
   od;
   od;

if bool=List(Faces,Length) then return false; fi;;;
K!.vertices:=Vertices;
ContractSimplicialComplex(K);

return true;
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(ContractGraph,
function(G)
local RemoveApex,RemoveEdge,A,LA,bool,PC,row,x,i,j,k;

A:=G!.incidenceMatrix;
PC:=PathComponentsOfGraph(G,0);
Unbind(G!.pathComponents);
bool:=Sum(Sum(A));

################################################
##
RemoveApex:=function(i)
local x, y, cols, lc,D;

cols:=[];
for x in LA do
if not A[i][x]=0 then Add(cols,x); fi;
od;

if Length(cols)=0 then return false; fi;

lc:=Length(cols);
for x in [1..lc] do
for y in [x+1..lc] do
if A[cols[x]][cols[y]]=0  then return false; fi;
od;
od;

for x in LA do
A[i][x]:=0;
A[x][i]:=0;
od;
return true;
end;
##
################################################

################################################
##
RemoveEdge:=function(i,j)
local cols, x, y,lc;

if A[i][j]=0 then return false; fi;

cols:=[];
for x in LA do
if (not A[i][x]=0) and (not A[j][x]=0) then Add(cols,x); fi;
od;

if Length(cols)=0  then return false; fi;

lc:=Length(cols);
for x in [1..lc] do
for y in [x+1..lc] do
if A[cols[x]][cols[y]]=0  then return false; fi;
od;
od;

if A[i][j]=0 then Print("hello"); fi;
A[i][j]:=0;
A[j][i]:=0;

return true;
end;
##
################################################ 

LA:=Filtered([1..Length(A)], i->Sum(A[i])>0);

x:=true;
while x do
x:=false;
   for i in LA do
   if RemoveApex(i) then x:=true; fi;
   od;
od;

x:=true;
while x do
x:=false;
LA:=Filtered([1..Length(A)], i->Sum(A[i])>0);
   for i in [1..Length(LA)] do
   for j in [i+1..Length(LA)] do
   if RemoveEdge(LA[i],LA[j]) then x:=true;  fi;
   od;
   od;
od;

if bool=Sum(Sum(A)) then return false; fi;;;
ContractGraph(G);

#Now create the correct number of path components.
A:=Filtered(A,v->not IsZero(v));
A:=TransposedMat(A);
A:=Filtered(A,v->not IsZero(v));
G!.incidenceMatrix:=MutableCopyMat(A);
PC:=PC-PathComponentsOfGraph(G,0);

if Length(A)>0 then row:=0*A[1]; 
G!.singletons:=[];
for i in [1..PC] do
Add(A,0*row);
Add(G!.singletons,Length(A));
od;
A:=MutableCopyMat(TransposedMat(A));
for i in [1..PC] do
Add(A,0*A[1]);
od;
fi;

if  Length(A)=0 then row:=[0]; 
G!.singletons:=[];
for i in [1..PC] do
Add(A,0*row);
Add(G!.singletons,Length(A));
od;
A:=MutableCopyMat(TransposedMat(A));
for i in [1..PC-1] do #WHY PC-1???
Add(A,0*A[1]);
od;
fi;

G!.incidenceMatrix:=A;
Unbind(G!.pathComponents);
Unbind(G!.bettiZero);
k:=PositionProperty(G!.properties,x->"numberofvertices" in x);
G!.properties[k][2]:=Length(A);

return true;
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(RipsHomology,
function(arg)
local P,G,n,p,bool,PC,answer,i ;

G:=StructuralCopy(arg[1]);
n:=arg[2];
if Length(arg)>2 then p:=arg[3]; bool:=true; answer:=0;
 else bool:=false; answer:=[]; fi;

PC:=PathComponentsOfGraph(G,0);;

if n=0 and bool then return PC; fi;
if n=0 and not bool then return [1..PC]*0; fi;


for i in [1..PC] do
P:=PathComponentsOfGraph(G,i);
ContractGraph(P);

if bool then
answer:=answer+Homology(SimplicialNerveOfGraph(P,n+1),n,p);
else
answer:=Concatenation(answer,Homology(SimplicialNerveOfGraph(P,n+1),n));
fi;
od;

return answer;
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(ContractibleSubcomplexOfSimplicialComplex,
function(KK)
local L,K,Simplices, NrSimplices, EnumeratedSimplex,
      RemoveSimplexIfPoss, Link, RemovableSimplex, 
      Leaves,  G, HH,   
      Faces,dim,bool,d,k,s,t,tt,x;;

K:=PathComponentsOfSimplicialComplex(KK,1);
dim:=Dimension(K);
G:=GraphOfSimplicialComplex(K);
G:=G!.incidenceMatrix;

################
if IsBound(K!.simplicesLst) then
Faces:=StructuralCopy(K!.simplicesLst);
else
Faces:=[];
for d in [0..dim] do
Faces[d+1]:=[];
for k in [1..K!.nrSimplices(d)] do
Faces[d+1][k]:=K!.simplices(d,k);
od;
Faces[d+1]:=SSortedList(Faces[d+1]);
od;
fi;
################ 

#####################
RemoveSimplexIfPoss:=function(s)
local i,t,cnt,tt;
cnt:=0;
       for i in s do
       t:=StructuralCopy(s); RemoveSet(t,i);
       if not t in L[d-1] then cnt:=cnt+1; tt:=t; fi;
       if cnt>1 then break; fi;  
       od;

       if cnt=0 then Add(HH,s); else 
       if cnt=1 then Add(L[d],s); Add(HH,s); 
       Add(L[d-1],tt);
       return true;
       fi;
       fi;
return false;
end;
#####################


L:=[];
if Length(Faces[1])=0 then return SimplicesToSimplicialComplex(L); fi;

L[1]:=[Faces[1][1]];

for d in [2..dim+1] do
   L[d]:=[];
   HH:=[];
   bool:=true;
   while bool do
      bool:=false;
      Faces[d]:=Difference(Faces[d],HH);
      HH:=[];
      for s in Faces[d]  do 
         if RemoveSimplexIfPoss(s) then bool:=true;  fi;
      od;
   od;
od;

for d in [dim+2..dim+100] do ##SLOPPY!
L[d]:=[];
od;

return SimplicesToSimplicialComplex(L);

end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(GraphOfSimplicialComplex,
function(K)
local
	G,dim,V,d,e,x;


dim:=Length(K!.vertices);
V:=[];
for x in [1..dim] do
V[K!.vertices[x]]:=x;
od;
G:=NullMat(dim,dim);

for e in [1..K!.nrSimplices(1)] do
x:=K!.simplices(1,e);
G[V[x[1]]][V[x[2]]]:=1;
G[V[x[2]]][V[x[1]]]:=1;
od;

return IncidenceMatrixToGraph(G);

end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(PathComponentsOfSimplicialComplex,
function(K,n)
local
        G,A,P,V,L,n1,i;

G:=GraphOfSimplicialComplex(K);
P:=PathComponentsOfGraph(G,0);
A:=G!.pathComponents;

if n=0 then return P; fi;

n1:=n+1;
L:=StructuralCopy(K!.simplicesLst);
V:=Filtered([1..Length(A)],x-> n1 in A[x]);
V:=StructuralCopy(K!.vertices{V});

for i in [1..Length(L)] do
L[i]:=Filtered(L[i],x->IsSubset(V,x));
od;
return SimplicesToSimplicialComplex(L);
end);
#################################################################
#################################################################

#################################################################
#################################################################
InstallGlobalFunction(ChainComplexOfSimplicialPair,
function(K,A)
local
	Dimen,Boundary,Faces,nullvecs,dim,d,i;

dim:=Dimension(K);
Faces:=[];

for d in [1..dim+1] do
if A!.nrSimplices(d-1)>0 then
Faces[d]:=Difference(K!.simplicesLst[d],A!.simplicesLst[d]);
else
Faces[d]:=K!.simplicesLst[d];
fi;
od;

#############################
Dimen:=function(k);
if k<0 or k>dim then return 0; fi;
return Length(Faces[k+1]);
end;
#############################

nullvecs:=[];
for i in [0..dim] do
nullvecs[i+1]:=List([1..Maximum(Dimen(i),1)],a->0);
od;

#############################
Boundary:=function(n,i)
local V,Vhat, j, bnd,pos;
V:=Faces[n+1][i];

bnd:=StructuralCopy(nullvecs[n]);

for j in [1..Length(V)] do
Vhat:=StructuralCopy(V);
RemoveSet(Vhat,V[j]);
pos:=Position(Faces[n],Vhat);
if not pos=fail then

if IsOddInt(j) then
bnd[pos]:=1;
else
bnd[pos]:=-1;
fi;

fi;
od;

return bnd;
end;
#############################


return
Objectify(HapChainComplex,
           rec(
           dimension:=Dimen,
           boundary:=Boundary,
           properties:=[
           ["length",dim],
           ["type","chainComplex"],
           ["characteristic",0]]
           ));

end);
#################################################################
#################################################################
